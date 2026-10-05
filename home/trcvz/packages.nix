{ config, pkgs, ... }:
{
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
  };

  home.packages = with pkgs; [
    #################
    # Hyprland
    #################
    kitty
    waybar
    hyprsunset
    hyprpaper
    hyprlock
    hypridle

    nwg-displays
    qt6.qtwayland
    qt6.qtmultimedia
    hyprpolkitagent
    kdePackages.breeze-icons
    kdePackages.kconfig
    kdePackages.kservice
    dmidecode
    efibootmgr

    appimage-run

    quickshell

    #################
    # Fonts
    #################
    nerd-fonts.jetbrains-mono

    # Cursor
    bibata-cursors

    ssh-to-age

    #################
    # Terminal utilities
    #################
    # Modern CLI utilities
    ripgrep
    btop
    fastfetch

    unzip
    zip
    file
    ffmpeg
    fzf

    tree-sitter

    kubectl

    #################
    # Development tools
    #################
    # C/C++
    # gcc
    llvm
    libcxx
    cmake
    ninja
    lld
    glfw
    clang
    clang-tools
    gnumake
    # Javascript
    nodejs_24
    # Lua
    lua
    lua-language-server
    # Python
    python3
    pyright
    ruff
    uv
    # Rust
    rustc
    # Java
    openjdk
    maven

    #################
    # Launchers
    #################
    rofi
    rofimoji

    #################
    # Clipboard
    #################
    wl-clipboard
    cliphist

    #################
    # Notifications
    #################
    mako
    libnotify

    #################
    # Applications
    #################
    obs-studio
    ardour
    firefox
    neothesia
    zenity

    neovim
    vscode
    keepassxc

    ## Notes
    obsidian

    # Latex
    texliveFull

    trash-cli
    # Lecteur PDF
    zathura
    kdePackages.dolphin

    # Lecteur MP3 et MP4
    mpv
    yt-dlp

    # Music
    musescore

    ## Gaming
    # r2modman

    ## Voice / Community
    discord
    steam

    libresprite
  ];
}
