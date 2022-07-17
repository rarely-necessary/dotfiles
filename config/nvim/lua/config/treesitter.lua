require('nvim-treesitter.configs').setup({
    ensure_installed = {
        'bash',
        'c',
        'c_sharp',
        'cmake',
        'cpp',
        'css',
        'go',
        'graphql',
        'help',
        'html',
        'http',
        'java',
        'javascript',
        'jsdoc',
        'json',
        'json5',
        'latex',
        'lua',
        'make',
        'ninja',
        'norg',
        'perl',
        'python',
        'rasi',
        'regex',
        'ruby',
        'rust',
        'scala',
        'scheme',
        'scss',
        'supercollider',
        'toml',
        'tsx',
        'vim',
        'vue',
        'yaml',
        'zig'
    },
    highlight = {
        enable = true
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<M-w>', -- Maps in normal mode to init the node/scope selection
            node_incremental = '<M-w>', -- Increment to the upper named parent
            node_decremental = '<M-C-w>', -- Decrement to the previous node
            scope_incremental = '<M-e>',  -- Increment to the upper scope
        }
    },
    indent = {
        enable = false,
        disable= {'yaml'}
    },
    rainbow = {
        enable = true
    },
    textobjects = {
        select = {
            enable = true,
            -- Automatically jump forward to jextobj, similar to targets.vim
            lookahead = true,
            keymaps = {
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
                ['aa'] = '@parameter.outer',
                ['ia'] = '@parameter.inner',
            }
        },
        swap = {
            enable = true,
            swap_next = {
                ['<Leader>a'] = '@parameter.inner'
            },
            swap_prev = {
                ['<Leader>A'] = '@parameter.inner'
            }
        },
        move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
                [']m'] = '@function.outer',
                [']]'] = '@class.outer'
            },
            goto_next_end = {
                [']M'] = '@function.outer',
                [']['] = '@class.outer'
            },
            goto_previous_start = {
                ['[m'] = '@function.inner',
                ['[['] = '@class.inner'
            },
            goto_previous_end = {
                ['[M'] = '@function.inner',
                ['[]'] = '@class.inner'
            },
        },
        lsp_interop = {
            enable = true,
            border = 'none',
            peek_definition_code = {
                ['<Leader>df'] = '@function.outer',
                ['<Leader>dF'] = '@class.outer'
            }
        }
    }
})

local parser_config = require('nvim-treesitter.parsers').get_parser_configs()

parser_config.norg = {
    install_info = {
        url = 'https://github.com/nvim-neorg/tree-sitter-norg',
        files = { 'src/parser.c', 'src/scanner.cc' },
        branch = 'main'
    },
}

parser_config.norg_meta = {
    install_info = {
        url = 'https://github.com/nvim-neorg/tree-sitter-norg-meta',
        files = { 'src/parser.c' },
        branch = 'main'
    },
}

parser_config.norg_table = {
    install_info = {
        url = 'https://github.com/nvim-neorg/tree-sitter-norg-table',
        files = { 'src/parser.c' },
        branch = 'main'
    },
}

parser_config.org = {
    install_info = {
        url = 'https://github.com/milisims/tree-sitter-org',
        revision = 'f110024d539e676f25b72b7c80b0fd43c34264ef',
        files = {'src/parser.c', 'src/scanner.cc'},
    },
    filetype = 'org',
}
