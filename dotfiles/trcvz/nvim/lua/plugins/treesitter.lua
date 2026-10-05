return {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    lazy = false,
    config = function()
        require("nvim-treesitter.configs").setup({
            -- Langages à installer
            ensure_installed = {
                "lua",
                "vim",
                "vimdoc",
                "bash",
                "c",
                "cpp",
                "python",
                "r",
                "java",
                "json",
                "yaml",
                "html",
                "css",
                "javascript",
                "typescript",
                "markdown",
                "markdown_inline",
                "query",
            },

            sync_install = false,
            auto_install = false,

            -- Config
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false
            },

            indent = {
                enable = true,
            },

            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<CR>",
                    node_incremental = "<CR>",
                    node_decremental = "<BS>",
                    scope_incremental = "<TAB>",
                },
            },

        })
    end,
}

