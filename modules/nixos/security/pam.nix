{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.my.pamHardening;

  pamPkg = config.security.pam.package; # pkgs.pam by default

  # pam_pwquality lives in libpwquality, not in the `pam` package itself.
  # libpwquality is a multiple-output derivation: the actual .so (incl. the
  # PAM module under lib/security/) lives in the `lib` output, NOT the
  # default `out` output (which only has headers/pkg-config files). Using
  # `pkgs.libpwquality` directly resolves to `.out` and produces a path
  # where pam_pwquality.so does not exist -> PAM fails with
  # "Module is unknown".
  pwqualityPkg = pkgs.libpwquality.lib;

  faillockSettings = {
    deny = cfg.faillock.deny;
    unlock_time = cfg.faillock.unlockTime;
    fail_interval = cfg.faillock.failInterval;
    audit = true;
  }
  // optionalAttrs cfg.faillock.evenDenyRoot { even_deny_root = true; }
  // optionalAttrs (cfg.faillock.dir != null) { dir = cfg.faillock.dir; };

  # Build the faillock rule-set for one PAM service, wired in relative to
  # the existing "unix" rule so we don't have to know / guess absolute
  # order numbers (which are an internal, unstable implementation detail).
  mkFaillockRules = serviceName: {
    rules.auth.faillock-preauth = {
      order = config.security.pam.services.${serviceName}.rules.auth.unix.order - 10;
      control = "required";
      modulePath = "${pamPkg}/lib/security/pam_faillock.so";
      settings = faillockSettings // {
        preauth = true;
        silent = true;
      };
    };

    rules.auth.faillock-authfail = {
      order = config.security.pam.services.${serviceName}.rules.auth.unix.order + 10;
      control = "[default=die]";
      modulePath = "${pamPkg}/lib/security/pam_faillock.so";
      settings = faillockSettings // {
        authfail = true;
      };
    };

    rules.account.faillock = {
      order = config.security.pam.services.${serviceName}.rules.account.unix.order - 10;
      control = "required";
      modulePath = "${pamPkg}/lib/security/pam_faillock.so";
      settings = { };
    };
  };

in

{
  ###### interface

  options.my.pamHardening = {
    enable = mkEnableOption "a hardened PAM baseline (password quality, faillock brute-force lockout, strong password hashing, login.defs and auditd hardening)";

    services = mkOption {
      type = types.listOf types.str;
      default = [
        "login"
        "sshd"
        "sudo"
        "su"
      ];
      example = [
        "login"
        "sshd"
      ];
      description = ''
        Names of PAM services (i.e. `security.pam.services.<name>`) that
        should get the `pam_faillock` brute-force lockout rules applied.

        Every service listed here must already exist (either created by
        another NixOS module such as `services.openssh`, or by
        `security.pam.services.<name> = {}`), and must use the default
        rule stack (`useDefaultRules = true`, the default), since the
        faillock rules are inserted relative to the built-in `unix` rule.
      '';
    };

    passwordQuality = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enforce password quality via `pam_pwquality` on `passwd`.";
      };

      minLength = mkOption {
        type = types.ints.positive;
        default = 14;
        description = "Minimum password length.";
      };

      minClasses = mkOption {
        type = types.ints.between 0 4;
        default = 3;
        description = ''
          Minimum number of character classes (upper, lower, digit,
          other) that must be present in the password.
        '';
      };

      difok = mkOption {
        type = types.int;
        default = 4;
        description = "Number of characters that must differ from the old password.";
      };

      maxRepeat = mkOption {
        type = types.int;
        default = 3;
        description = "Maximum number of allowed consecutive identical characters (0 disables the check).";
      };

      maxClassRepeat = mkOption {
        type = types.int;
        default = 4;
        description = "Maximum number of allowed consecutive characters from the same class (0 disables the check).";
      };

      dictCheck = mkOption {
        type = types.bool;
        default = true;
        description = "Reject passwords found in a cracklib dictionary.";
      };

      userCheck = mkOption {
        type = types.bool;
        default = true;
        description = "Reject passwords containing the username.";
      };

      enforceForRoot = mkOption {
        type = types.bool;
        default = true;
        description = "Also enforce the password policy for root.";
      };

      retry = mkOption {
        type = types.ints.positive;
        default = 3;
        description = "Number of attempts before returning a failure.";
      };
    };

    passwordHashing = {
      algorithm = mkOption {
        type = types.enum [
          "sha512"
          "yescrypt"
        ];
        default = "sha512";
        description = ''
          Hashing scheme used by `pam_unix` in `/etc/pam.d/passwd`.
          `yescrypt` is the modern glibc default and generally preferred
          on systems where the C library / `crypt()` supports it;
          `sha512` is universally supported and still considered strong.
        '';
      };

      rounds = mkOption {
        type = types.nullOr types.ints.positive;
        default = 65536;
        description = ''
          Number of hashing rounds. Only applies to `sha512`; ignored
          for `yescrypt` (which has its own internal cost parameter).
          Set to `null` to let libxcrypt pick its default.
        '';
      };
    };

    faillock = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable `pam_faillock` brute-force lockout on `my.pamHardening.services`.";
      };

      deny = mkOption {
        type = types.ints.positive;
        default = 5;
        description = "Number of failed attempts before the account is locked.";
      };

      unlockTime = mkOption {
        type = types.ints.unsigned;
        default = 900;
        description = "Seconds the account stays locked after too many failures (0 = require manual `faillock --reset`).";
      };

      failInterval = mkOption {
        type = types.ints.positive;
        default = 900;
        description = "Sliding time window (seconds) during which failures are counted.";
      };

      evenDenyRoot = mkOption {
        type = types.bool;
        default = true;
        description = "Whether root is also subject to lockout.";
      };

      dir = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/var/lib/faillock";
        description = ''
          Directory used to store the per-user failure tallies. Defaults
          to upstream's own default (`/var/run/faillock`, i.e. tmpfs,
          cleared on reboot) when left as `null`. Set this to a
          persistent path if tallies should survive a reboot; the
          directory will be created automatically via `systemd.tmpfiles`.
        '';
      };
    };

    loginDefs = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to apply the `login.defs` hardening settings below.";
      };

      umask = mkOption {
        type = types.str;
        default = "027";
        description = "Default UMASK for newly created files.";
      };

      passwordAging = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Whether to manage password expiry at all
            (`PASS_MAX_DAYS`/`PASS_MIN_DAYS`/`PASS_WARN_AGE`). Set to
            `false` if you never want passwords to expire and don't want
            this module touching those `login.defs` fields (they'll keep
            whatever value the distro/other modules set, typically no
            expiry).
          '';
        };

        passMaxDays = mkOption {
          type = types.ints.positive;
          default = 90;
          description = "Maximum password age in days. Ignored if `passwordAging.enable` is `false`.";
        };

        passMinDays = mkOption {
          type = types.ints.unsigned;
          default = 1;
          description = "Minimum number of days between password changes. Ignored if `passwordAging.enable` is `false`.";
        };

        passWarnAge = mkOption {
          type = types.ints.unsigned;
          default = 14;
          description = "Number of days before password expiry that a warning is issued. Ignored if `passwordAging.enable` is `false`.";
        };
      };

      loginRetries = mkOption {
        type = types.ints.positive;
        default = 5;
        description = "Maximum number of login retries in case of authentication failure (getty/login, independent of pam_faillock).";
      };

      loginTimeout = mkOption {
        type = types.ints.positive;
        default = 60;
        description = "Timeout in seconds for the login prompt.";
      };
    };

    maxLogins = mkOption {
      type = types.nullOr types.ints.positive;
      default = 10;
      description = ''
        If set, adds a `security.pam.loginLimits` entry capping the
        number of concurrent logins per user (`* hard maxlogins N`).
        Set to `null` to leave `security.pam.loginLimits` untouched.
      '';
    };

    disableCoreDumps = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to disable core dumps for all users via `security.pam.loginLimits`.";
    };

    auditd.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable `auditd` (`security.auditd.enable`) as part of the hardened baseline.";
    };
  };

  ###### implementation

  config = mkIf cfg.enable (mkMerge [

    # -- password quality (passwd service) ---------------------------------
    #
    # IMPORTANT: this is deliberately NOT done via `security.pam.services.passwd.text`.
    # The base PAM module already sets `text = lib.mkDefault <auto-generated-from-rules>;`.
    # `text` has type `lib.types.lines`, whose merge behaviour for two definitions
    # at the *same* priority is to CONCATENATE them, not to have one override the
    # other. Two `mkDefault` texts therefore get glued together, with the base
    # module's own `password sufficient pam_unix.so ...` rule ending up first in
    # the file -- and since `sufficient` short-circuits the stack on success,
    # pam_pwquality would never even run. Inserting a named rule into
    # `rules.password` instead avoids this entirely: it's a distinct key in an
    # attrset, ordered explicitly relative to the existing `unix` rule.
    (mkIf cfg.passwordQuality.enable {
      security.pam.services.passwd.rules.password.pwquality = {
        order = config.security.pam.services.passwd.rules.password.unix.order - 10;
        control = "requisite"; # hard-stop the whole stack immediately on failure
        modulePath = "${pwqualityPkg}/lib/security/pam_pwquality.so";
        settings = {
          retry = cfg.passwordQuality.retry;
          minlen = cfg.passwordQuality.minLength;
          minclass = cfg.passwordQuality.minClasses;
          difok = cfg.passwordQuality.difok;
          maxrepeat = cfg.passwordQuality.maxRepeat;
          maxclassrepeat = cfg.passwordQuality.maxClassRepeat;
          dictcheck = cfg.passwordQuality.dictCheck;
          usercheck = cfg.passwordQuality.userCheck;
          enforce_for_root = cfg.passwordQuality.enforceForRoot;
        };
      };
    })

    # -- password hashing scheme (passwd service) --------------------------
    #
    # Same reasoning: we patch the *settings* of the existing `unix` rule
    # instead of replacing `.text`. `settings` is a plain attrset value, so
    # NixOS merges it key-by-key with whatever the base module already set
    # (e.g. `nullok`), rather than concatenating text. The one real collision
    # is `yescrypt`, which the base module sets to `true` by default when
    # `security.pam.enableLegacySettings` is on -- so it's forced explicitly
    # here with `mkForce` to make the chosen algorithm authoritative.
    {
      security.pam.services.passwd.rules.password.unix.settings = mkMerge [
        (mkIf (cfg.passwordHashing.algorithm == "sha512") {
          sha512 = true;
        })
        (mkIf (cfg.passwordHashing.algorithm == "sha512" && cfg.passwordHashing.rounds != null) {
          rounds = cfg.passwordHashing.rounds;
        })
        {
          yescrypt = mkForce (cfg.passwordHashing.algorithm == "yescrypt");
        }
      ];
    }

    # -- brute-force lockout (login/sshd/sudo/su/...) ----------------------
    (mkIf cfg.faillock.enable {
      security.pam.services = genAttrs cfg.services mkFaillockRules;

      systemd.tmpfiles.rules = mkIf (cfg.faillock.dir != null) [
        "d ${cfg.faillock.dir} 0700 root root -"
      ];
    })

    # -- login.defs ----------------------------------------------------------
    (mkIf cfg.loginDefs.enable {
      security.loginDefs.settings = {
        UMASK = cfg.loginDefs.umask;
        LOGIN_RETRIES = cfg.loginDefs.loginRetries;
        LOGIN_TIMEOUT = cfg.loginDefs.loginTimeout;
        ENCRYPT_METHOD = lib.toUpper cfg.passwordHashing.algorithm;
      }
      // optionalAttrs cfg.loginDefs.passwordAging.enable {
        PASS_MAX_DAYS = cfg.loginDefs.passwordAging.passMaxDays;
        PASS_MIN_DAYS = cfg.loginDefs.passwordAging.passMinDays;
        PASS_WARN_AGE = cfg.loginDefs.passwordAging.passWarnAge;
      };
    })

    # -- resource limits -------------------------------------------------
    {
      security.pam.loginLimits =
        optional (cfg.maxLogins != null) {
          domain = "*";
          type = "hard";
          item = "maxlogins";
          value = cfg.maxLogins;
        }
        ++ optional cfg.disableCoreDumps {
          domain = "*";
          type = "hard";
          item = "core";
          value = "0";
        };
    }

    # -- auditd ------------------------------------------------------------
    (mkIf cfg.auditd.enable {
      security.auditd.enable = true;
    })
  ]);
}
