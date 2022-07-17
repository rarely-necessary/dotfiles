local M = {}

function M.setup()
    vim.g.tabline_show_icons = true
    local events = {
        'BufAdd',
        'BufEnter',
        'BufFilePost',
        'BufUnload',
        "BufWinEnter",
        'BufWritePost',
        'CursorHold',
        'FileType',
        'TabEnter',
        'TextChanged',
        'TextChangedI',
        'VimResized',
        'WinEnter'
    }

    local autocmd = {'augroup tabline', 'autocmd!'}
    for _,def in ipairs(events) do
        local command = string.format('autocmd %s * lua require("tabline").tabline()', def)
        table.insert(autocmd, command)
    end
    table.insert(autocmd, 'augroup END')

    vim.cmd(table.concat(autocmd, '\n'))
end

local function get_tab_name(n, sel)
    local buflist = vim.fn.tabpagebuflist(n)  -- Returns a list of buffer #s in this tab page (either table or number)
    local winnr = vim.fn.tabpagewinnr(n)      -- Returns the number of the current window in tab page

    local bufnr = type(buflist)=='table' and buflist[winnr] or buflist
    local bufname = vim.fn.bufname(bufnr)   -- Get name of active buffer on tab page

    if vim.fn.getbufvar(bufnr, '&modified') == 1 then
        bufname = (sel and '%#TabModifiedSel#' or '%#TabModified#') .. bufname
    end

    if bufname == '' then bufname = '[No Name]' end
    return bufname
end

function M.tabline()
    local tabline = {}
    local num_tabs = vim.fn.tabpagenr('$') - 1
    local get_icon = require('nvim-web-devicons').get_icon

    for i = 0, num_tabs, 1 do
        table.insert(tabline, '%'.. i+1 .. 'T') -- Tabline name

        local sel = i + 1 == vim.fn.tabpagenr()
        if sel then
            table.insert(tabline, '%#TablineSel# ')
        else
            table.insert(tabline, '%#Tabline# ')
        end

        -- Active buffer
        local bufname = get_tab_name(i+1, sel)

        -- Add window number indicator for mult-window tabs
        local num_windows = vim.fn.tabpagewinnr(i+1, '$')
        if num_windows > 1 then
            local color = sel and '%#TabWinNumSel#' or '%#TabWinNum#'
            table.insert(tabline, color .. num_windows..' ')
        end

        -- Use icon, if necessary
        if vim.g.tabline_show_icons then
            local icon
            local color = sel and '%#TablineSel#' or '%#Tabline#'
            local ext = bufname:match("[^.]+$")
            icon = get_icon(bufname, ext, { default = true })
            if (icon == nil) then icon = '' end

            table.insert(tabline, color .. icon .. ' ')
        end

        -- Actually attach icon and buffername now
        table.insert(tabline, (sel and '%#TabLineSel#' or '%#TabLine#') .. bufname .. '  ')
        table.insert(tabline, '%#TablineFill# ')
    end

    -- Cleanup (separator)
    table.insert(tabline, '%#TabLineFill#%T')

    vim.o.tabline = table.concat(tabline, '')
end

return M
