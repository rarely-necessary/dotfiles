if pcall(require, 'neorg') then
    require('neorg').setup({
        load = {
            ['core.defaults'] = {},
            ['core.norg.concealer'] = {
                config = {
                    icon_preset = 'diamond',
                    markup_preset = 'dimmed',
                    dim_code_blocks = true
                }
            },
            ['core.keybinds'] = {
                config = {
                    default_keybinds = true,
                    -- neorg_leader = '<Space>o'
                }
            },
            ['core.norg.dirman'] = {
                config = {
                    workspaces = {
                        -- work = '~/Projects/CRM',
                        default = '~/neorg'
                    }
                }
            },
            ['core.norg.completion'] = {
                config = {
                    engine = 'nvim-cmp'
                }
            },
            ['core.norg.journal'] = {
                config = {
                    workspace = 'default',
                    journal_folder = '/journal/',
                    use_folders = true
                }
            },
            ['core.gtd.base'] = {
                config = {
                    workspace = 'default',
                }
            },
            ['core.gtd.queries'] = {},
            ['core.norg.qol.toc'] = {
                config = {
                    close_split_on_jump = true,
                }
            }
        }
    })
else
    print('Failed to load neorg')
end
