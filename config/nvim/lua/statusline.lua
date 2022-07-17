-- Much code taken or inspired from feline-nvim/feline.nvim
local api, g, fn, bo = vim.api, vim.g, vim.fn, vim.bo
local gps = require('nvim-gps')
local lsp, diagnostic = vim.lsp, vim.diagnostic
local block = '▊'
local M = {}

local cn = {
    c00       = g.terminal_color_0,
    c01       = g.terminal_color_1,
    c02       = g.terminal_color_2,
    c03       = g.terminal_color_3,
    c04       = g.terminal_color_4,
    c05       = g.terminal_color_5,
    c06       = g.terminal_color_6,
    c07       = g.terminal_color_7,
    c08       = g.terminal_color_8,
    bk00      = g.terminal_color_9,
    bk01      = g.terminal_color_10,
    bk02      = g.terminal_color_11,
    bk03      = g.terminal_color_12,
    comment   = g.terminal_color_13,
    error     = g.terminal_color_14,
    selection = g.terminal_color_15,
}

local active_colors = {
    reset       = { fg = cn.bko1,   bg = cn.bk01 },
    cap         = { fg = cn.c03,    bg = cn.bk01 },
    filename    = { fg = cn.c07,    bg = cn.bk01 },
    fn_edited   = { fg = cn.c07,    bg = cn.bk01, style = 'bold,italic' },
    location    = { fg = cn.c08,    bg = cn.bk01 },
    encoding    = { fg = cn.c08,    bg = cn.bk01 },
    ft          = { fg = cn.c08,    bg = cn.bk01 },
    git         = { fg = cn.c00,    bg = cn.comment },
    position    = { fg = cn.c04,    bg = cn.bk01 },
    percent     = { fg = cn.c04,    bg = cn.bk01 },
    lsp         = {
        error   = { fg = cn.error,  bg = cn.bk01 },
        warn    = { fg = cn.error,  bg = cn.bk01 },
        info    = { fg = cn.c06,    bg = cn.bk01 },
    },
}

local inactive_colors = {
    cap         = { fg = cn.comment, bg = cn.bk01 },
    filename    = { fg = cn.comment, bg = cn.bk01 },
    fn_edited   = { fg = cn.comment, bg = cn.bk01, style = 'bold,italic' },
    lsp         = { fg = cn.comment, bg = cn.bk01 },
    encoding    = { fg = cn.comment, bg = cn.bk01 },
    ft          = { fg = cn.comment, bg = cn.bk01 },
}

local vi_colors = {
  NORMAL        = cn.c03,
  INSERT        = cn.c01,
  VISUAL        = cn.selection,
  REPLACE       = cn.c02,
  SELECT        = cn.selection,
  COMMAND       = cn.c07,
}

local vi_translate = {
    n              = 'NORMAL',
    no             = 'NORMAL_PENDING',
    nov            = 'NORMAL_PENDING',
    niI            = 'NORMAL',
    niR            = 'NORMAL',
    niV            = 'NORMAL',
    nt             = 'NORMAL',
    v              = 'VISUAL',
    vs             = 'VISUAL',
    V              = 'VISUAL',
    Vs             = 'VISUAL',
    ['CTRL-V']     = 'VISUAL',
    ['CTRL-Vs']    = 'VISUAL',
    s              = 'SELECT',
    S              = 'SELECT',
    ['CTRL-S']     = 'SELECT',
    i              = 'INSERT',
    ic             = 'INSERT',
    ix             = 'INSERT',
    R              = 'REPLACE',
    Rc             = 'REPLACE',
    Rx             = 'REPLACE',
    Rv             = 'REPLACE',
    Rvc            = 'REPLACE',
    Rvx            = 'REPLACE',
    c              = 'COMMAND',
    cv             = 'COMMAND',
    r              = 'COMMAND',
    rm             = 'COMMAND',
    ['r?']         = 'COMMAND',
    ['!']          = 'COMMAND',
    t              = 'COMMAND'
}

local function value_or_none(str)
    if str == nil or str == '' then
        return 'NONE'
    end
    return str
end

local function hi (group_name, spec)
    local translator = { fg = 'guifg', bg = 'guibg', style = 'gui', sp = 'guisp' }

    local command = {}

    for key, val in pairs(translator) do
        table.insert(command, val..'='..(value_or_none(spec[key])))
    end

    if #command > 0 then
        table.insert(command, 1, 'highlight '..group_name)
        vim.cmd(table.concat(command, ' '))
    end
end

function M.generate(active)
    for name, fg in pairs(vi_colors) do
        hi('StatusComponent_vi_' .. name, { fg = fg, bg = cn.bk01, style = 'bold' })
    end

    hi('StatusComponent_Reset',             active_colors.reset)
    hi('StatusComponent_Cap',               active_colors.cap)
    hi('StatusComponent_Filename',          active_colors.filename)
    hi('StatusComponent_Filename_Edited',   active_colors.fn_edited)
    hi('StatusComponent_Location',          active_colors.location)
    hi('StatusComponent_LSP_Error',         active_colors.lsp.error)
    hi('StatusComponent_LSP_Warning',       active_colors.lsp.warn)
    hi('StatusComponent_LSP_Info',          active_colors.lsp.info)
    hi('StatusComponent_Encoding',          active_colors.encoding)
    hi('StatusComponent_Filetype',          active_colors.ft)
    hi('StatusComponent_Git',               active_colors.git)
    hi('StatusComponent_Position',          active_colors.position)
    hi('StatusComponent_Percent',           active_colors.percent)

    hi('StatusComponent_Inactive_Cap',              inactive_colors.cap)
    hi('StatusComponent_Inactive_Filename',         inactive_colors.filename)
    hi('StatusComponent_Inactive_Filename_Edited',  inactive_colors.fn_edited)
    hi('StatusComponent_Inactive_Encoding',         inactive_colors.encoding)
    hi('StatusComponent_Inactive_Filetype',         inactive_colors.ft)

    -- local reset = '%#StatusComponent_Reset#'
    local reset = '%#StatusLine#'

    --- VI MODE ---
    -- Get name & colors
    local vim_mode = api.nvim_get_mode()
    -- Create component
    -- local vi_component = table.concat({'%#StatusComponent_vi_', vi_translate[vim_mode.mode], '#   '}, '')

    --- Caps ---
    -- Create components
    local cap = table.concat({
        -- active and '%#StatusComponent_Cap#' or '%#StatusComponent_Inactive_Cap#',
        active and '%#StatusComponent_vi_' .. vi_translate[vim_mode.mode] .. '#' or '%#StatusComponent_Inactive_Cap#',
        block
    })

    --- FILE INFO ---
    -- Get information
    local buf_name      = fn.expand('%:t')
    local buf_mod       = vim.bo.modified
    local extension     = fn.fnamemodify(buf_name, ':e')
    local icon, iconhl  = require('nvim-web-devicons').get_icon(
        buf_name,
        extension,
        { default = true }
    )
    local readonly      = vim.bo.readonly
    -- Create component
    local filename_component = table.concat({
        icon, ' ',
        readonly and '🔒' or '',
        (active and ( buf_mod and '%#StatusComponent_Filename_Edited#' or '%#StatusComponent_Filename#')
            or ( buf_mod and '%#StatusComponent_Inactive_Filename_Edited#' or '%#StatusComponent_Inactive_Filename#')),
        buf_name
    }, '')
    local location_component = table.concat({
        (gps.is_available() and gps.get_location() ~= '' and active)
            and '%#StatusComponent_Location#' .. '> ' .. gps.get_location()
            or ''
    }, '')

    --- GIT INFO ---
    -- Get information
    local git_branch = fn['gitbranch#name']()
    -- Create component
    local git_component = ''
    if git_branch ~= nil and git_branch ~= '' and active then
        git_component = table.concat({
            '%#StatusComponent_Git#  ', git_branch, ' '
        }, '')
    end

    --- LSP INFO ---
    -- Get information
    local lsp_attached = lsp.buf_get_clients(0) ~= nil
    local errors       = vim.tbl_count(diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }))
    local warns        = vim.tbl_count(diagnostic.get(0, { severity = vim.diagnostic.severity.WARN }))
    local hints        = vim.tbl_count(diagnostic.get(0, { severity = vim.diagnostic.severity.HINT }))
    local infos        = vim.tbl_count(diagnostic.get(0, { severity = vim.diagnostic.severity.INFO }))
    -- Create component
    local lsp_component = ''
    if lsp_attached and (errors > 0 or warns > 0 or hints > 0 or infos > 0) and active then
        lsp_component = table.concat({
            '%#StatusComponent_LSP_Error#'  , errors > 0 and '  ' .. errors or '',
            '%#StatusComponent_LSP_Warning#' , warns > 0 and '  ' .. warns or '',
            '%#StatusComponent_LSP_Info#' , hints > 0 and '  ' .. hints or '',
            '%#StatusComponent_LSP_Info#' , infos > 0 and '  ' .. infos or '',
        }, '')
    end

    --- ENCODING ---
    -- Get information
    local encoding = ((bo.fenc ~= '' and bo.fenc) or vim.o.enc):upper()
    -- Create component
    local encoding_component = table.concat({
        (active and '%#StatusComponent_Encoding#' or '%#StatusComponent_Inactive_Encoding#'),
        encoding
    }, '')

    --- FILETYPE ---
    -- Get information
    local ft = vim.api.nvim_buf_get_option(0, 'filetype')
    local clients = vim.lsp.get_active_clients()
    if active and next(clients) ~= nil then
        for _, client in ipairs(clients) do
            local filetypes = client.config.filetypes
            if filetypes and vim.fn.index(filetypes, ft) ~= -1 then
                ft = client.name
            end
        end
    end
    -- Create component
    local ft_component = table.concat({
        (active and '%#StatusComponent_Filetype#' or '%#StatusComponent_Inactive_Filetype#'),
        ft
    }, '')

    --- POSITION ---
    -- Get information
    local row, col = unpack(api.nvim_win_get_cursor(0))
    local vim_col  = vim.str_utfindex(api.nvim_get_current_line(), col) + 1
    local lines    = api.nvim_buf_line_count(0)
    local percent
    if row == 1 then
        percent    = 'Top'
    elseif row == lines then
        percent    = 'Bot'
    else
        percent    = string.format('%2d%%%%', math.ceil(row / lines * 99))
    end
    local position = string.format('%d:%d', row, vim_col)
    -- Create components
    local percent_component  = active and table.concat({'%#StatusComponent_Percent#', '(', percent, ')'}, '') or ''
    local position_component = active and table.concat({'%#StatusComponent_Position#', position}, '') or ''

    --- Generate full statusline ---
    if bo.buftype == 'nofile' then
        return ''
    end

    local statusline_full = ''

    if active then
        statusline_full = table.concat({
            cap, ' ',
            filename_component, ' ',
            location_component, ' ',
            reset,
            '%=',
            lsp_component, ' ',
            encoding_component, ' ',
            ft_component, ' ',
            git_component,
            reset, ' ',
            position_component, ' ', percent_component, ' ',
            cap
        }, '')
    else
        statusline_full = table.concat({
            cap, ' ',
            filename_component, ' ',
            '%=',
            encoding_component, ' ',
            ft_component, ' ',
            cap
        }, '')
    end

    return statusline_full
end

function M.statusline()
    return M.generate(api.nvim_get_current_win() == tonumber(g.actual_curwin))
end

function M.setup()
    vim.opt.statusline = "%{%v:lua.require'statusline'.statusline()%}"
end

return M
