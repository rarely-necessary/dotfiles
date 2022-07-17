require('packer').startup({function(use)
    -- Package Manager
    use { 'wbthomason/packer.nvim', event = 'VimEnter' }

    -- Organization
    use {
        'nvim-neorg/neorg',
        config = function() require('config.neorg') end,
        requires = 'nvim-lua/plenary.nvim'
    }

    ------- Editing -------
    --Marks
    use {
        'chentoast/marks.nvim',
        config = function()
            require('marks').setup({
                default_mappings = true,
                builtin_marks = { '.', '<', '>' },
                cyclic = true,
                force_write_shada = false,
                refresh_interval = 250,
                sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20},
                excluded_filetypes = {},
                mappings = {},
            })
        end
    }
    -- Autopair brackets/parenth/quotes/etc
    use { 'windwp/nvim-autopairs', config = function() require('config.autopairs') end }
    -- Two-character f/t movement using 's'
    use 'justinmk/vim-sneak'
    -- Easily align text
    use 'godlygeek/tabular'
    -- Automatically grab tab amount
    use 'tpope/vim-sleuth'
    -- Add/change surroundings
    use 'tpope/vim-surround'

    ------ Eye Candy ------
    -- Dashboard
    use { 'goolord/alpha-nvim', config = function() require('config.alpha') end }
    -- Indent lines
    use {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            require('indent_blankline').setup({
                buftype_exclude = { 'terminal' },
                filetype_exclude = { 'alpha', 'packer' },
                show_current_context = true,
                show_trailing_blankline_indent = false,
            })
        end,
    }
    -- Color previews
    use { 'norcalli/nvim-colorizer.lua', config = function() require('colorizer').setup() end }
    -- Rainbow parentheses/brackets
    use {
        'luochen1990/rainbow',
        config = function()
            vim.g.rainbow_active = 1    -- Have to activate the non-ts rainbows plugin
            vim.g.rainbow_conf = {      -- Set our own colors for the rainbow hierarchy
                guifgs = {
                    '#cccccc',
                    '#f2777a',
                    '#ffcc66',
                    '#6699cc',
                },
            }
        end
    }
    -- Rainbow parentheses/backets (TS)
    use 'p00f/nvim-ts-rainbow'

    ------ Interface ------
    -- Statusline Treesitter info
    use { 'SmiteshP/nvim-gps', config = function() require('nvim-gps').setup() end }
    -- Sidebar filetree
    use {
        'kyazdani42/nvim-tree.lua',
        config = function()
            require('nvim-tree').setup({
                disable_netrw = false,
                hijack_netrw = false,
                actions = {
                    open_file = {
                        quit_on_open = true,
                    }
                }
            })
            vim.api.nvim_create_autocmd('BufEnter', {
                pattern = { '*' },
                command = [[if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif]]
            })
        end,
    }
    -- Fuzzy finder
    use {
        'nvim-telescope/telescope.nvim',
        config = function()
            require('telescope').setup({
                defaults = {
                    file_ignore_patterns = { 'node_modules' },
                },
            })
        end
    }
    -- Focus/zen mode
    use {
        'folke/zen-mode.nvim',
        config = function()
            require('zen-mode').setup({
                window = {
                    height = 0.85,
                    width = 80,
                    options = {
                        number = false,
                        relativenumber = false,
                        signcolumn = 'no',
                    },
                },
                plugins = {
                    kitty = {
                        enabled = true,
                    },
                },
            })
        end,
    }

    -------- Utils --------
    -- use 'psliwka/termcolors.nvim'
    -- Quicker filetype detection
    use 'nathom/filetype.nvim'
    -- Completion icons
    use 'onsails/lspkind-nvim'
    -- Defines some missing nvim APIs
    use { 'norcalli/nvim_utils', config = function() require('nvim_utils') end }
    -- Lua icons
    use 'kyazdani42/nvim-web-devicons'
    -- Lua helpers
    use 'nvim-lua/plenary.nvim'
    -- Popup API from Vim
    use 'nvim-lua/popup.nvim'
    -- Exit buffer, not window
    use 'moll/vim-bbye'
    -- Quick plugin to display git branch
    use 'itchyny/vim-gitbranch'
    -- Startup profiler (non-lua)
    use 'dstein64/vim-startuptime'
    -- Faster loading (& profiling) for lua modules
    use 'lewis6991/impatient.nvim'

    --- Language Utils ----
    -- Sonic Pi utils
    use 'lilyinstarlight/vim-sonic-pi'
    -- For eww customization
    use 'elkowar/yuck.vim'
    -- HTML expansions
    use { 'mattn/emmet-vim', config = function() vim.g.user_emmet_leader_key = '<C-h>' end }
    -- In-browser markdown preview
    use({
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    })
    -- Easy configuration for builtin LSP
    use { 'neovim/nvim-lspconfig', config = function() require('config.lsp') end}
    -- Easily install LSP servers
    use {
        'williamboman/nvim-lsp-installer',
        config = function()
            require('nvim-lsp-installer').setup({})
            require('config.lsp')
        end,
    }
    -- Tree-sitter management
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function() require('config.treesitter') end
    }
    -- Better handling of text objects using treesitter
    use 'nvim-treesitter/nvim-treesitter-textobjects'
    -- Arduino tools
    use 'stevearc/vim-arduino'
    -- Commenting
    use { 'numToStr/Comment.nvim', config = function() require('Comment').setup() end }
    -- use 'tpope/vim-commentary'
    -- Versatile <K> behavior
    use { 'romainl/vim-devdocs', config = function() vim.o.keywordprg = ':DD' end }
    -- Ending keywords for languages that use it
    use 'tpope/vim-endwise'
    -- MDX/JS support
    use 'jxnblk/vim-mdx-js'
    -- Better LaTeX support
    use {
        'lervag/vimtex',
        config = function()
            vim.g.tex_flavor = 'latex'     -- May not be necessary, but vimtex gets mad sometimes
            vim.g.vimtex_quickfix_mode = 0 -- Don't let quickfix open itself
        end
    }
    -- Collection of completion utils
    use 'hrsh7th/cmp-nvim-lsp'
    use { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' }
    use { 'hrsh7th/cmp-path', after = 'nvim-cmp' }
    use { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' }
    use { 'hrsh7th/cmp-calc', after = 'nvim-cmp' }
    use { 'hrsh7th/cmp-omni', after = 'nvim-cmp' }
    use { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' }
    -- Completion engine
    use { 'hrsh7th/nvim-cmp', after = 'LuaSnip', config = function() require('config.cmp') end }
    -- Huge collection of snippets
    use 'rafamadriz/friendly-snippets'
    -- Snippet engine
    use {
        'L3MON4D3/LuaSnip',
        config = function() require('luasnip.loaders.from_vscode').lazy_load() end,
    }
end, config = {
    display = {
        open_fn = require('packer.util').float,
    },
    profile = { enable = true },
    compile_path = vim.fn.stdpath('config')..'/lua/packer_compiled.lua'
}})
