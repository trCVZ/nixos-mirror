# Mouse

hl.config({
    input = {
        sensitivity = 0.5,

        accel_profile = "flat",

        force_no_accel = false,

        follow_mouse = 1,

        natural_scroll = false,

        left_handed = false,

        scroll_method = "2fg",

        scroll_factor = 1.0,

        -- Touchpad
        touchpad = {
            natural_scroll = true,

            disable_while_typing = true,

            tap_to_click = true,

            drag_lock = true,

            clickfinger_behavior = true,

            tap_button_map = "lrm",

            scroll_factor = 0.7,

            middle_button_emulation = false,
        },
    },

    cursor = {
        no_hardware_cursors = 1,

        enable_hyprcursor = true,
    },
})

hl.config({
    gestures = {

        workspace_swipe_distance = 400,

        workspace_swipe_invert = true,

        workspace_swipe_cancel_ratio = 0.2,

        workspace_swipe_min_speed_to_force = 30,

        workspace_swipe_forever = true,

        workspace_swipe_direction_lock = true,

        workspace_swipe_direction_lock_threshold = 10,

        workspace_swipe_create_new = false,
    }
})

-- 3-finger horizontal swipe
hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})
