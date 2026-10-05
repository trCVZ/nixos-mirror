{
  config,
  lib,
  pkgs,
  ...
}:

{
  # home.activation.copyHyprDotfiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  # 	cp -r /home/trcvz/000-Nixos/dotfiles/trcvz/hypr /home/trcvz/.config/
  # '';

  # home.activation.copyWaybarFiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  # 	cp -r /home/trcvz/000-Nixos/dotfiles/trcvz/waybar /home/trcvz/.config/
  # '';

  # home.activation.copyMakoFiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  # 	cp -r /home/trcvz/000-Nixos/dotfiles/trcvz/mako /home/trcvz/.config/
  # '';

  # home.activation.copyBtopFiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  # 	cp -r /home/trcvz/000-Nixos/dotfiles/trcvz/btop /home/trcvz/.config/
  # '';

  # home.activation.copyRofiFiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  # 	cp -r /home/trcvz/000-Nixos/dotfiles/trcvz/rofi /home/trcvz/.config/
  # '';

  # # home.activation.copyNvimFiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  # # 	cp -r /home/trcvz/000-Nixos/dotfiles/trcvz/nvim /home/trcvz/.config
  # # '';

  # home.activation.copyKittyFiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  # 	cp -r /home/trcvz/000-Nixos/dotfiles/trcvz/kitty /home/trcvz/.config
  # '';

  # home.activation.copyZshFiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  # 	cp -r /home/trcvz/000-Nixos/dotfiles/trcvz/.zshrc /home/trcvz/.zshrc
  # '';
}
