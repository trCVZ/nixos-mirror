-- Monitors

hl.config({
    misc = {
        vrr = 0,
        force_default_wallpaper = 0, -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = true, -- If true disables the random hyprland logo / anime girl background
        disable_splash_rendering = true,
        initial_workspace_tracking = 1,
    },
})

hl.monitor({
    output = "eDP1-1",
    mode = "1920x1080@60",
    position = "0x0",
    scale = 1,
})

hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    mirror = "eDP-1",
    scale = 1,
    disabled = false,
})
