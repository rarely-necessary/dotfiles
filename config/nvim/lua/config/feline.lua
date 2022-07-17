if pcall(require, 'feline') then
    local g, fn, bo = vim.g, vim.fn, vim.bo
    local vi_mode = require('feline.providers.vi_mode')
    local lsp = require('feline.providers.lsp')
    local gps = require('nvim-gps')

    local colors = {
      bg            = g.terminal_color_1,
      fg            = g.terminal_color_foreground,
      fg_secondary  = g.terminal_color_11,
      bg_alt        = g.terminal_color_3,
      fg_alt        = g.terminal_color_6,
      bg_inactive   = g.terminal_color_15,
      fg_inactive   = g.terminal_color_8,
      black         = g.terminal_color_background,
      error         = g.terminal_color_9,
    }

    local vi_mode_colors = {
      NORMAL        = g.terminal_color_1,
      INSERT        = g.terminal_color_3,
      VISUAL        = g.terminal_color_13,
      BLOCK         = g.terminal_color_13,
      LINES         = g.terminal_color_13,
      REPLACE       = g.terminal_color_2,
      ['V-REPLACE'] = g.terminal_color_2,
      SELECT        = g.terminal_color_12,
      COMMAND       = g.terminal_color_10,
      SHELL         = g.terminal_color_10,
      TERM          = g.terminal_color_10,
    }

    local components = {
      active = {},
      inactive = {},
    }

    local function is_file()
      return vim.bo.buftype ~= 'nofile' and vim.bo.buftype ~= 'quickfix'
    end

    local function diagnostics_exist()
      if (lsp.diagnostics_exist('ERROR')
        or lsp.diagnostics_exist('WARN')
        or lsp.diagnostics_exist('HINT')
        or lsp.diagnostics_exist('INFO')
      ) then
        return true
      end
      return false
    end

    -- Active statusline: left, center, right
    table.insert(components.active, {})
    table.insert(components.active, {})
    table.insert(components.active, {})

    -- Inactive statusline: left, right
    table.insert(components.inactive, {})
    table.insert(components.inactive, {})

    -- Left (active)
    components.active[1] = {
      -- Mode indicator
      {
        hl = function()
          return {
            name = vi_mode.get_mode_highlight_name(),
            fg = vi_mode.get_mode_color(),
            bg = colors.black,
            style = 'bold,'
          }
        end,
        provider = function()
          return '   '
        end,
      },
      -- File info
      {
        left_sep = {
          str = 'left_rounded',
          hl = {
            fg = colors.bg,
            bg = colors.black
          }
        },
        right_sep = {
          str = ' ',
          hl = {
            fg = colors.bg,
            bg = colors.bg
          },
        },
        hl = function()
          return {
            style = (bo.modified and 'italic') or 'NONE',
            bg = colors.bg,
          }
        end,
        provider = {
          name = 'file_info',
          opts = {
            colored_icon = false,
            file_modified_icon = '',
          }
        }
      },
      -- TS location info
      {
        hl = {
          fg = colors.fg_secondary,
          bg = colors.bg
        },
        provider = function()
          local location = gps.get_location()
          if (location ~= nil and location ~= '') then
            return '> ' .. location
          else
            return location
          end
        end,
        enabled = function()
          return gps.is_available()
        end
      },
      -- Git
      {
        left_sep = {
          str = 'left_rounded',
          hl = {
            bg = colors.bg,
            fg = colors.fg_alt
          }
        },
        right_sep = {
          str = 'right_rounded',
          hl = {
            bg = colors.bg,
            fg = colors.fg_alt
          }
        },
        hl = {
          fg = colors.bg_alt,
          bg = colors.fg_alt
        },
        icon = ' ',
        provider = function()
          return fn['gitbranch#name']()
        end,
      },
      {
        provider = '',
        hl = {
          bg = colors.bg
        }
      }
    }

    -- Middle (active)
    components.active[2] = {
      {
        provider = '',
        hl = {
          bg = colors.bg
        }
      }
    }

    -- Right (active)
    components.active[3] = {
      -- Diagnostics
      {
        left_sep = {
          str = 'left_rounded',
          always_visible = true,
          hl = function()
            return {
              bg = colors.bg,
              fg = (diagnostics_exist() and colors.bg_alt) or colors.bg
            }
          end
        },
        provider = ''
      },
      {
        hl = {
          fg = colors.error,
          bg = colors.bg_alt,
        },
        provider = 'diagnostic_errors',
      },
      {
        hl = {
          fg = colors.fg_alt,
          bg = colors.bg_alt,
        },
        provider = 'diagnostic_warnings',
      },
      {
        hl = {
          fg = colors.fg_alt,
          bg = colors.bg_alt,
        },
        provider = 'diagnostic_hints',
      },
      {
        hl = {
          fg = colors.fg_alt,
          bg = colors.bg_alt,
        },
        provider = 'diagnostic_info',
      },
      {
        right_sep = {
          str = 'right_rounded',
          always_visible = true,
          hl = function()
            return {
              bg = colors.bg,
              fg = (diagnostics_exist() and colors.bg_alt) or colors.bg
            }
          end
        },
        hl = {
          bg = colors.bg_alt
        },
        provider = ''
      },
      -- File Encoding
      {
        left_sep = {
          str = ' ',
          hl = {
            bg = colors.bg
          }
        },
        right_sep = {
          str = ' ',
          hl = {
            bg = colors.bg
          }
        },
        hl = {
          bg = colors.bg,
          fg = colors.fg_secondary,
          style = 'bold'
        },
        provider = 'file_encoding'
      },
      -- Filetype
      {
        right_sep = {
          str = ' ',
          hl = {
            bg = colors.bg
          }
        },
        hl = {
          bg = colors.bg,
          fg = colors.fg_secondary,
          style = 'bold'
        },
        provider = 'file_type'
      },
      -- Line percentage
      {
        right_sep = {
          str = 'right_rounded',
          hl = {
            fg = colors.bg,
            bg = colors.black,
          }
        },
        hl = {
          bg = colors.bg,
          fg = colors.fg_secondary,
          style = 'bold'
        },
        provider = 'line_percentage'
      },
      -- Position
      {
        left_sep = {
          str = ' ',
          hl = {
            bg = colors.black
          }
        },
        hl = {
          fg = colors.bg,
          bg = colors.black,
          style = 'bold'
        },
        provider = 'position'
      }
    }

    -- Left (inactive)
    components.inactive[1] = {
      {
        enabled = is_file,
        hl = {
          fg = colors.black,
          bg = colors.black
        },
        provider = ' ',
      },
      {
        enabled = is_file,
        left_sep = {
          str = 'left_rounded',
          hl = {
            fg = colors.bg_inactive,
            bg = colors.black
          }
        },
        hl = function()
          return {
            bg = colors.bg_inactive,
            fg = colors.fg_inactive,
            style = (bo.modified and 'bold,italic') or 'none'
          }
        end,
        provider = {
          name = 'file_info',
          opts = {
            colored_icon = false,
            file_modified_icon = '',
          }
        }
      },
    }

    -- Right (inactive)
    components.inactive[2] = {
      {
        right_sep = {
          str = 'right_rounded',
          hl = {
            fg = colors.bg_inactive,
            bg = colors.black
          }
        },
        hl = {
          fg = colors.fg_inactive,
          bg = colors.bg_inactive,
          style = 'bold'
        },
        icon = '',
        provider = 'file_type',
        enabled = is_file,
      },
      {
        enabled = is_file,
        hl = {
          fg = colors.black,
          bg = colors.black
        },
        provider = ' '
      },
    }

    require('feline').setup{
      colors = {
        fg = colors.fg,
        bg = colors.bg,
      },
      components = components,
      vi_mode_colors = vi_mode_colors,
    }
else
    print('Failed to load feline')
end
