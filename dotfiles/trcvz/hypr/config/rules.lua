
hl.window_rule({
    name = "suppress-maximize",
    match = { class = ".*" },
    suppress_event = "maximize"
})

hl.window_rule({
    name = "fix-xwayland",
    match = {
        class = "^$",
        xwayland = true,
        float = true,
        fullscreen = false
    },
    no_focus = true
})
