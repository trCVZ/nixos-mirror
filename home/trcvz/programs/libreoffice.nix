{
  pkgs,
  ...
}:
# nix-prefetch-url --type sha256 --print-path https://raw.githubusercontent.com/catppuccin/libreoffice/main/themes/mocha/lavender/catppuccin-mocha-lavender.soc
# nix hash convert --hash-algo sha256 --to sri 1b6nmykzva26agbc6lf4zk2y0ipfsgka73kg4lw4l6gj6821l37f
let
  catppuccinLibreOffice = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/libreoffice/main/themes/mocha/lavender/catppuccin-mocha-lavender.soc";
    hash = "sha256-7gwaBDLyGUo4JW+Oo+bT7kbgxfzEUcPWU0ao/aev1qw=";
  };
in
{
  xdg.configFile."libreoffice/4/user/config/catppuccin-mocha-lavender.soc".source =
    catppuccinLibreOffice;
}
