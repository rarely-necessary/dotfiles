local fn = vim.fn
local lsp_installer = require('nvim-lsp-installer')
local lsp = require('lspconfig')

lsp_installer.setup({})

lsp.cssls.setup({})
lsp.html.setup({})
lsp.solargraph.setup({})
lsp.sumneko_lua.setup({
    Lua = {
        runtime = {
            version = 'LuaJIT'
        },
        diagnostics = {
            globals = {
                -- Vim
                'vim',
                -- AwesomeWM
                'awesome',
                'client',
                'root',
                'mouse',
                'tag',
            },
        },
        workspace = {
            library = {
                ['/usr/share/nvim/runtime/lua'] = true,
                ['/usr/share/nvim/runtime/lua/lsp'] = true,
                ['/usr/share/awesome/lib'] = true
            }
        }
    }
})
lsp.tsserver.setup({})
lsp.yamlls.setup({
    yaml = {
        schemaStore = {
            url = 'https://www.schemastore.org/api/json/catalog.json',
            enable = true
        },
        format = { enable = true },
        validate = { enable = true },
        editor = { formatOnType = true }
    },
    hover = true,
    completion = true,
    customTags = { -- For Cloudformation .yml files
        '!fn',
        '!And',
        '!If',
        '!Not',
        '!Equals',
        '!Or',
        '!FindInMap sequence',
        '!Base64',
        '!Cidr',
        '!Ref',
        '!Ref Scalar',
        '!Sub',
        '!GetAtt',
        '!GetAZs',
        '!ImportValue',
        '!Select',
        '!Split',
        '!Join sequence'
    }
})

local signs = { Error = '•', Warn = '•', Hint = '•', Info = '•' }

for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
end

-- Stop the LSPs from writing on the screen
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false,
        underline = true,
    }
)
