return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        -- Variable globale pour garder l’état de transparence
        local transparent = false

        -- Fonction de configuration Catppuccin
        local function setup_catppuccin()
            require("catppuccin").setup({
                flavour = "mocha",
                accent = "lavender",
                term_colors = true,
                transparent_background = transparent,
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    nvimtree = true,
                    treesitter = true,
                    telescope = true,
                    lualine = true,
                    indent_blankline = { enabled = true },
                    native_lsp = {
                        enabled = true,
                        virtual_text = {
                            errors = { "italic" },
                            hints = { "italic" },
                            warnings = { "italic" },
                            information = { "italic" },
                        },
                        underlines = {
                            errors = { "underline" },
                            hints = { "underline" },
                            warnings = { "underline" },
                            information = { "underline" },
                        },
                    },
                },
            })
            vim.cmd.colorscheme("catppuccin")
        end

        -- Charger le thème une première fois
        setup_catppuccin()

        -- Définir la fonction de toggle
        local function toggle_transparency()
            transparent = not transparent
            setup_catppuccin()
        end

        -- Créer le keybind <leader>bg
        vim.keymap.set("n", "<leader>bg", toggle_transparency, { desc = "Toggle transparent background" })
    end,
}


