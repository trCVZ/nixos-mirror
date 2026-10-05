-- =========================================================
-- KEYBINDS (Hyprland Lua - FIXED)
-- =========================================================

local mainMod = "SUPER"

-- =========================================================
-- AUDIO
-- =========================================================

hl.bind("XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),
    { repeating = true, locked = true }
)

hl.bind("XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { repeating = true, locked = true }
)

hl.bind("XF86AudioMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true }
)

-- =========================================================
-- BRIGHTNESS
-- =========================================================

hl.bind("XF86MonBrightnessUp",
    hl.dsp.exec_cmd("brightnessctl set +5%"),
    { repeating = true, locked = true }
)

hl.bind("XF86MonBrightnessDown",
    hl.dsp.exec_cmd("brightnessctl set 5%-"),
    { repeating = true, locked = true }
)

-- =========================================================
-- NIGHTSHIFT
-- =========================================================

local nightshiftScript = "~/.config/waybar/scripts/toggle_nightshift.sh"

hl.bind(mainMod .. " + N",
    hl.dsp.exec_cmd(nightshiftScript .. " toggle")
)

-- =========================================================
-- ROFI
-- =========================================================

local function rofi(cmd)
    return hl.dsp.exec_cmd("pkill rofi || " .. cmd)
end

hl.bind(mainMod .. " + R", rofi("~/.config/rofi/launchers/launcher.sh"))
hl.bind(mainMod .. " + P", rofi("~/.config/rofi/powermenu/powermenu.sh"))
hl.bind(mainMod .. " + E", rofi("~/.config/rofi/emoji/emoji.sh"))
hl.bind(mainMod .. " + B", rofi("~/.config/rofi/wallpaper/wallpaper.sh"))
hl.bind(mainMod .. " + W", rofi("~/.config/rofi/clipboard/clipboard.sh"))

hl.bind(mainMod .. " + SHIFT + W",
    hl.dsp.exec_cmd("cliphist wipe")
)

-- =========================================================
-- APPLICATIONS
-- =========================================================

local terminal = "kitty"
local filebrowser = "yazi"

hl.bind(mainMod .. " + A",
    hl.dsp.exec_cmd(terminal)
)

hl.bind(mainMod .. " + Y",
    hl.dsp.exec_cmd("kitty -e " .. filebrowser)
)

hl.bind(mainMod .. " + Q",
    hl.dsp.window.close()
)

hl.bind(mainMod .. " + SHIFT + M",
    hl.dsp.exit()
)

hl.bind(mainMod .. " + SHIFT + L",
    hl.dsp.exec_cmd("hyprlock")
)

hl.bind(mainMod .. " + F",
    hl.dsp.window.fullscreen({ action = "toggle" })
)

-- =========================================================
-- FOCUS NAVIGATION
-- =========================================================

hl.bind(mainMod .. " + H",
    hl.dsp.focus({ direction = "left" })
)

hl.bind(mainMod .. " + L",
    hl.dsp.focus({ direction = "right" })
)

hl.bind(mainMod .. " + K",
    hl.dsp.focus({ direction = "up" })
)

hl.bind(mainMod .. " + J",
    hl.dsp.focus({ direction = "down" })
)

-- =========================================================
-- WORKSPACES
-- =========================================================

for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i,
        hl.dsp.focus({ workspace = i })
    )

    hl.bind(mainMod .. " + SHIFT + " .. i,
        hl.dsp.window.move({ workspace = i })
    )
end
