-- ========================================
-- |            TEMPS & RÉPONSE           |
-- ========================================
vim.o.timeoutlen = 500           -- Durée (ms) avant de considérer une touche multi-stroke comme terminée (objectif: 300)
vim.o.updatetime = 250           -- Temps d'attente pour déclencher des événements (ex: CursorHold, LSP, gitsigns)

-- ========================================
-- |            AFFICHAGE                |
-- ========================================
vim.wo.number = true             -- Affiche les numéros de ligne absolus
vim.o.relativenumber = true      -- Affiche les numéros de ligne relatifs
vim.o.signcolumn = 'yes'         -- Colonne pour les signes (Git, LSP) toujours visible
vim.o.cursorline = true           -- Surligner la ligne du curseur
vim.o.wrap = false                -- Désactive le retour automatique à la ligne
vim.o.linebreak = true            -- Coupure des lignes sur des mots (utile si wrap=true)
vim.o.scrolloff = 4               -- Lignes visibles au-dessus et en-dessous du curseur
vim.o.sidescrolloff = 8           -- Colonnes visibles à gauche et à droite du curseur
vim.o.numberwidth = 4             -- Largeur réservée pour les numéros de ligne
vim.opt.termguicolors = true      -- Activer TrueColor pour les thèmes modernes
vim.o.showmode = false            -- Ne pas afficher --INSERT-- car souvent géré par la statusline
vim.o.showtabline = 2             -- Toujours afficher la ligne des onglets
vim.o.cmdheight = 1               -- Ligne de commande minimale

-- Numero de ligne dans l'explorateur de fichiers de Neovim
vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    vim.opt_local.number = true          -- ligne courante en absolu
    vim.opt_local.relativenumber = true  -- autres lignes en relatif
  end,
})

-- ========================================
-- |            CLAVIER & SOURIS        |
-- ========================================
vim.o.mouse = 'a'                 -- Activer la souris dans tous les modes
vim.o.whichwrap = 'bs<>[]hl'      -- Permet au curseur de passer d'une ligne à l'autre
vim.o.backspace = 'indent,eol,start' -- Backspace plus intuitif
vim.o.clipboard = 'unnamedplus'   -- Utiliser le presse-papier système

-- ========================================
-- |            INDENTATION & TAB        |
-- ========================================
vim.o.autoindent = true           -- Copier l'indentation de la ligne précédente
vim.o.smartindent = true          -- Indentation intelligente pour les blocs de code
vim.o.shiftwidth = 4               -- Largeur de l'indentation automatique
vim.o.tabstop = 4                  -- Largeur d'une tabulation
vim.o.softtabstop = 4              -- Largeur de tabulation en insertion
vim.o.expandtab = true             -- Convertir les tabulations en espaces

-- ========================================
-- |            RECHERCHE & COMPLÉTION  |
-- ========================================
vim.o.ignorecase = true            -- Recherche insensible à la casse
vim.o.smartcase = true             -- Recherche sensible si majuscules présentes
vim.o.hlsearch = true              -- Met en surbrillance les résultats de recherche
vim.o.completeopt = 'menuone,noselect' -- Comportement du menu de complétion
vim.o.pumheight = 10               -- Hauteur max du menu popup de complétion
vim.opt.shortmess:append 'c'       -- Masquer messages inutiles lors de l'auto-complétion
vim.opt.iskeyword:append '-'       -- Considérer les mots avec tirets comme un seul mot

-- ========================================
-- |            FORMATAGE & COMMENTAIRES |
-- ========================================
vim.o.breakindent = true           -- Indentation visuelle des lignes wrapped
vim.opt.formatoptions:remove { 'c', 'r', 'o' } -- Ne pas prolonger automatiquement les commentaires
vim.o.conceallevel = 0             -- Afficher tous les caractères, utile pour Markdown/LaTeX

-- ========================================
-- |            FICHIERS & UNDO         |
-- ========================================
vim.o.undofile = true              -- Sauvegarder l'historique des undo
vim.o.backup = false                -- Pas de fichier backup
vim.o.writebackup = false           -- Pas de backup pendant l'écriture
vim.o.swapfile = false              -- Pas de fichier swap
vim.o.fileencoding = 'utf-8'       -- Encodage des fichiers sauvegardés en UTF-8
vim.opt.runtimepath:remove '/usr/share/vim/vimfiles' -- Séparer plugins Vim et Neovim
