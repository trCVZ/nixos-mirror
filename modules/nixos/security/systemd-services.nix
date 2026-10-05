{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Journald
  systemd.services.systemd-journald = {
    serviceConfig = {
      UMask = "0077";
      PrivateNetwork = true;
      ProtetcHome = true;
      ProctectHostname = true;
      ProtectKernelModules = true;
    };
  };

  # DBus
  #systemd.services.dbus-broker = {
  #	serviceConfig = {
  #		RemoveIPC = true;
  #		NoNewPrivileges = true;
  #		PrivateDevices = true;
  #		PrivateTmp = true;
  #		ProtectClock = true;
  #		ProtectKernelLogs = true;
  #		ProtectKernelModules = true;
  #		ProtectKernelTunables = true;
  #		ProtectHostname = true;
  #		ProtectHome = true;
  #		ProtectSystem = "strict";
  #		ProtectControlGroups = true;
  #		PrivateMounts = true;
  #		PrivateNetwork = true;
  #		PrivateUsers = true;
  #		RestrictSUIDSGID = true;
  #		LockPersonality = true;
  #		MemoryDenyWriteExecute = true;
  #		RestrictNamespaces = true;
  #		RestrictRealtime = true;
  #		RestrictAddressFamilies = [ "AF_UNIX" ];
  #		User = "root";
  #		DynamicUser = false;
  #		CapabilityBoundingSet = [ "" ];
  #		SystemCallFilter = [ "@system-service" "~@privileged" "~@resources" ];
  #		SystemCallArchitectures = "native";
  #		SystemCallErrorNumber = "EPERM";
  #		ProtectProc = "invisible";
  #		ProcSubset = "pid";
  #		IPAddressDeny = [ "any" ];
  #		# DevicePolicy = "strict";
  #	};
  #};

  # Emergency Shell
  # systemd.services.emergency = {
  # 	serviceConfig = {
  # 		RemoveIPC = true;
  # 		NoNewPrivileges = true;
  # 		PrivateDevices = true;
  # 	     	PrivateTmp = true;
  # 		ProtectClock = true;
  # 		ProtectKernelLogs = true;
  # 		ProtectKernelModules = true;
  # 		ProtectKernelTunables = true;
  # 		ProtectHostname = true;
  # 		ProtectHome = true;
  # 		ProtectSystem = "strict";
  # 		ProtectControlGroups = true;
  # 		PrivateMounts = true;
  # 		PrivateNetwork = true;
  # 		PrivateUsers = true;
  # 		RestrictSUIDSGID = true;
  # 		LockPersonality = true;
  # 		MemoryDenyWriteExecute = true;
  # 		RestrictNamespaces = true;
  # 		RestrictRealtime = true;
  # 		RestrictAddressFamilies = [ "AF_UNIX" ];
  # 		User = "root";
  # 		DynamicUser = false;
  # 		CapabilityBoundingSet = [ "" ];
  # 		SystemCallFilter = [ "@system-service" "~@privileged" "~@resources" ];
  # 		SystemCallArchitectures = "native";
  # 		SystemCallErrorNumber = "EPERM";
  # 		ProtectProc = "invisible";
  # 		ProcSubset = "pid";
  # 		IPAddressDeny = [ "any" ];
  # 		# DevicePolicy = "strict";
  # 	};
  # };

  # NetworkManager

  systemd.services.NetworkManager = {
    serviceConfig = {
      # RemoveIPC = true;
      NoNewPrivileges = true;
      PrivateDevices = true;
      PrivateTmp = true;
      ProtectClock = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectHostname = true;
      ProtectHome = true;
      ProtectSystem = "strict";
      ProtectControlGroups = true;
      PrivateMounts = true;
      # PrivateNetwork = true;
      # PrivateUsers = true;
      # RestrictSUIDSGID = true;
      #LockPersonality = true;
      # MemoryDenyWriteExecute = true;
      # RestrictNamespaces = true;
      # RestrictRealtime = true;
      # RestrictAddressFamilies = [ "AF_UNIX" ];
      User = "root";
      DynamicUser = false;
      # CapabilityBoundingSet = [ "" ];
      # SystemCallFilter = [ "@system-service" "~@privileged" "~@resources" ];
      # SystemCallArchitectures = "native";
      # SystemCallErrorNumber = "EPERM";
      # ProtectProc = "invisible";
      # ProcSubset = "pid";
      # IPAddressDeny = [ "any" ];
      # DevicePolicy = "strict";
    };
  };

  # NetworManager-dispatcher

  systemd.services.NetworkManager-dispatcher = {
    serviceConfig = {
      RemoveIPC = true;
      NoNewPrivileges = true;
      PrivateDevices = true;
      PrivateTmp = true;
      ProtectClock = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectHostname = true;
      ProtectHome = true;
      ProtectSystem = "strict";
      ProtectControlGroups = true;
      PrivateMounts = true;
      # PrivateNetwork = true;
      # PrivateUsers = true;
      # RestrictSUIDSGID = true;
      # LockPersonality = true;
      # MemoryDenyWriteExecute = true;
      # RestrictNamespaces = true;
      # RestrictRealtime = true;
      # RestrictAddressFamilies = [ "AF_UNIX" ];
      User = "root";
      DynamicUser = false;
      # CapabilityBoundingSet = [ "" ];
      # SystemCallFilter = [ "@system-service" "~@privileged" "~@resources" ];
      # SystemCallArchitectures = "native";
      # SystemCallErrorNumber = "EPERM";
      # ProtectProc = "invisible";
      # ProcSubset = "pid";
      # IPAddressDeny = [ "any" ];
      # DevicePolicy = "strict";
    };
  };

  # Nix Daemon
  #systemd.services.nix-daemon = {
  #	serviceConfig = lib.mkForce {
  #		NoNewPrivileges         = true;
  #		PrivateTmp              = true;
  #		ProtectHome             = true;
  #		ProtectSystem           = "full";
  #		ProtectClock            = true;
  #		ProtectHostname         = true;
  #		ProtectControlGroups    = true;
  #		ProtectKernelLogs       = true;
  #		ProtectKernelModules    = true;
  #		ProtectKernelTunables   = true;
  #		ProtectProc             = "invisible";
  #		PrivateDevices          = true;
  #		PrivateUsers            = true;
  #		PrivateNetwork          = true;
  #		RestrictNamespaces      = true;
  #		RestrictRealtime        = true;
  #		RestrictSUIDSGID        = true;
  #		LockPersonality         = true;
  #		MemoryDenyWriteExecute  = true;
  #		RestrictAddressFamilies = ["AF_UNIX"];
  #		CapabilityBoundingSet   = [];
  #		SystemCallFilter        = [ "@system-service" ];
  #		SystemCallArchitectures = "native";
  #		SystemCallErrorNumber   = "EPERM";
  #		NoExecPaths             = [ "/" ];
  #		ExecPaths               = [ "/nix/store" ];
  #	};
  #};

  # Systemd-rfkill

  systemd.services.systemd-rfkill = {
    serviceConfig = {
      ProtectSystem = "strict";
      ProtectHome = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      ProtectClock = true;
      ProtectProc = "invisible";
      ProcSubset = "pid";
      PrivateTmp = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      LockPersonality = true;
      RestrictRealtime = true;
      SystemCallArchitectures = "native";
      UMask = "0077";
      IPAddressDeny = "any";
    };
  };
}
