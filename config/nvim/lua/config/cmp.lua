if pcall(require, 'cmp') then
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    local lspkind = require('lspkind')

    local function mapping(callback, fallback)
        if cmp.visible then
            callback()
        else
            fallback()
        end
    end

    cmp.setup({
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end
        },
        formatting = {
            format = lspkind.cmp_format({
                with_text = false,
                menu = ({
                    buffer = '｢Buffer｣',
                    nvim_lsp = '｢LSP｣',
                    luasnip = '｢LuaSnip｣',
                    nvim_lua = '｢Lua｣',
                    latex_symbols = '｢Latex｣',
                    neorg = '｢Neorg｣',
                })
            })
        },
        mapping = {
            ['<C-n>'] = function(fallback) mapping(cmp.select_next_item, fallback) end,
            ['<C-p>'] = function(fallback) mapping(cmp.select_prev_item, fallback) end,
            ['<C-d>'] = function(fallback) mapping(function() cmp.scroll_docs(4) end, fallback) end,
            ['<C-u>'] = function(fallback) mapping(function() cmp.scroll_docs(-4) end, fallback) end,
            ['<C-f>'] = function(fallback) mapping(function() cmp.scroll_docs(8) end, fallback) end,
            ['<C-b>'] = function(fallback) mapping(function() cmp.scroll_docs(-8) end, fallback) end,
            ['<C-y>'] = function(fallback) mapping(cmp.confirm, fallback) end,
            ['<C-CR>'] = function(fallback) mapping(cmp.confirm, fallback) end,
            ['<C-e>'] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
            ['<M-k>'] = function(fallback)
                if luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end,
            ['<M-h>'] = function(fallback)
                if luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end,
            ['<M-j>'] = function(fallback)
                if luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end,
            ['<M-l>'] = function(fallback)
                if luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end,
        },
        sources = cmp.config.sources({
            { name = 'luasnip' },
            { name = 'nvim_lsp' },
            { name = 'buffer' },
            { name = 'path' },
            { name = 'neorg' },
            { name = 'calc' },
            { name = 'omni' },
        }),
    })
    else
	print('Failed to load cmp.lua')
end
