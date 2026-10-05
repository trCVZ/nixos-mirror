return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local builtin = require('telescope.builtin')

    -- Recherche de fichiers (avec fichiers cachés)
    vim.keymap.set('n', '<leader>ff', function()
      builtin.find_files({ hidden = true })
    end, { desc = 'Rechercher un fichier (y compris cachés)' })

    -- Recherche de tous les fichiers, y compris ceux ignorés
    vim.keymap.set('n', '<leader>ffa', function()
      builtin.find_files({ no_ignore = true, hidden = true })
    end, { desc = 'Rechercher tous les fichiers (y compris ignorés)' })

    -- Recherche de texte dans les fichiers (live grep)
    vim.keymap.set('n', '<leader>fg', function()
      builtin.live_grep()
    end, { desc = 'Rechercher du texte dans les fichiers' })

    -- Recherche de texte dans tous les fichiers, y compris ceux ignorés
    vim.keymap.set('n', '<leader>fga', function()
      builtin.live_grep({ no_ignore = true })
    end, { desc = 'Rechercher du texte dans tous les fichiers (y compris ignorés)' })
  end,
}
