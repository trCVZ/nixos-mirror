
hl.on("hyprland.start", function()

    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("waybar")

    hl.exec_cmd("firefox", { workspace = "1 silent" })
    hl.exec_cmd("emacs --daemon")

    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("hypridle")

    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

end)
