-------------------------- Helpers --------------------------
local fn, set = vim.fn, vim.keymap.set

-- Make list-like commands more intuitive
local function CCR()
    local function starts_with(str, start)
        if type(start) == 'table' then
            for _, s in ipairs(start) do
                if str:sub(1, #s) == s then
                    return true
                end
            end
            return false
        else
            return str:sub(1, #start) == start
        end
    end
    local function ends_with(str, ending)
        if type(ending) == 'table' then
            for _, e in ipairs(ending) do
                if e == '' or str:sub(-#e) == e then
                    return true
                end
            end
            return false
        else
            return ending == '' or str:sub(-#ending) == ending
        end
    end

    if fn.getcmdtype() ~= ':' then
        return [[<CR>]]
    end
    local cmdline = fn.getcmdline():lower()

    if cmdline == 'ls' or cmdline == 'files' or cmdline == 'buffers' then
        -- like :ls but prompts for a buffer command
        return [[<CR>:b]]
    elseif ends_with(cmdline, { 'nu', 'num', 'numb', 'numbe', 'number' }) or starts_with(cmdline, '#') then
        -- like :g//# but prompts for a command
        return [[<CR>:]]
    elseif starts_with(cmdline, { 'dli', 'il' }) then
        -- like :dlist or :ilist but prompts for a count for :djump or :ijump
        return [[<CR>:]] .. cmdline:sub(1, 2) .. 'j ' .. cmdline:gmatch('%w+')() .. [[<S-Left><Left>]]
    elseif starts_with(cmdline, { 'cli', 'lli' }) then
        -- like :clist or :llist but prompts for an error/location number
        return [[<CR>:sil ]] .. cmdline.sub(1, 2) .. cmdline.sub(1, 2) .. [[<Space>]]
    elseif starts_with(cmdline, 'old') then
        -- like :oldfiles but prompts for an old file to edit
        vim.o.nomore = true
        return [[<CR>:sil se more|e #<]]
    elseif starts_with(cmdline, 'changes') then
        -- like :changes but prompts for a change to jump to
        vim.o.nomore = true
        return [[<CR>:sil se more|norm! g;<S-Left>]]
    elseif starts_with(cmdline, 'ju') then
        -- like :jumps but prompts for a position to jump to
        vim.o.nomore = true
        return [[<CR>:sil se more|norm! <C-o><S-Left>]]
    elseif starts_with(cmdline, 'marks') then
        -- like :marks but prompts for a mark to jump to
        return [[<CR>:norm! `]]
    elseif starts_with(cmdline, 'undol') then
        -- like :undolist but prompts for a change to undo
        return [[<CR>:u]]
    else
        return [[<CR>]]
    end
end

-- Get highlight group (TS or standard)
local function Show_hl_captures()
    local parsers = require('nvim-treesitter.parsers')
    local queries = require('nvim-treesitter.query')
    local ts_utils = require('nvim-treesitter.ts_utils')
    local utils = require('nvim-treesitter.utils')

    local hlmap = vim.treesitter.highlighter.hl_map
    local bufnr = vim.api.nvim_get_current_buf()
    local lang = parsers.get_buf_lang(bufnr)
    local hl_captures = vim.tbl_keys(hlmap)

    if not lang then
        return
    end

    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    row = row - 1

    local matches = {}
    if parsers.has_parser(lang) then
        for m in queries.iter_group_results(bufnr, 'highlights') do
            for _, c in pairs(hl_captures) do
                local node = utils.get_at_path(m, c .. '.node')
                if node and ts_utils.is_in_node_range(node, row, col) then
                    table.insert(matches, '@' .. c .. ' -> ' .. hlmap[c])
                end
            end
        end
    end
    local synId = fn.synID(row + 1, col, 1)
    local syntax = fn.synIDattr(synId, 'name')
    local trans = fn.synIDattr(fn.synIDtrans(synId), 'name')
    table.insert(matches,  '@' .. syntax .. ' -> ' .. trans)
    if #matches == 0 then
        matches = { 'No matches found!' }
    end
    vim.lsp.util.open_floating_preview(matches, 'hl-capture')
end

-------------------------- Terminal --------------------------
set('n', [[<ESC>]], [[<C-\><C-n>]])                               -- Esc leaves cmp menus as well

-------------------------- Command --------------------------
set('c', [[<CR>]], CCR, { expr = true })                          -- Better handling for some cmds

--------------------------- Normal --------------------------
----- General -----
set('n', [[<leader>q]]  , [[:Bdelete<CR>]]                      ) -- Delete buf, not win
set('n', [[<leader>rt]] , [[:set number! relativenumber! <CR>]] ) -- Number column toggle
set('n', [[<M-\>]]      , [[:g//#<Left><Left>]]                 ) -- Make g search easier
set('n', [[<leader>hb]] , Show_hl_captures                      ) -- Show HL groups

------- LSP -------
set('n', [[<leader>dn]], function()                               -- Go to next diagnostic
    vim.diagnostic.goto_next({ float = { border = 'rounded' } })
end)
set('n', [[<leader>dp]], function()                               -- Go to previous diagnostic
    vim.diagnostic.goto_prev({ float = { border = 'rounded' } })
end)
set('n', [[<leader>db]], function()                               -- Go to previous diagnostic (alias)
    vim.diagnostic.goto_prev({ float = { border = 'rounded' } })
end)
set('n', [[<leader>do]], vim.diagnostic.setloclist)               -- Open diagnostics in quickfix window
set('n', [[<leader>dd]], function()                               -- Open diagnostics here
    vim.diagnostic.open_float(0, { scope = 'line', border = 'rounded' })
end)
set('n', [[<leader>dl]], function()                               -- Open diagnostics here (alias)
    vim.diagnostic.open_float(0, { scope = 'line', border = 'rounded' })
end)
set('n', [[<leader>dh]], function()                               -- Open diagnostics here (alias)
    vim.diagnostic.open_float(0, { scope = 'line', border = 'rounded' })
end)
set('n', 'gT', vim.lsp.buf.type_definition)

---- Telescope ----
-- Normal (f for file)
set('n', [[<leader>f/]], [[:Telescope current_buffer_fuzzy_find<CR>]]   ) -- / for search
set('n', [[<leader>fb]], [[:Telescope buffers<CR>]]                     ) -- b for buffers
set('n', [[<leader>fc]], [[:Telescope colorscheme<CR>]]                 ) -- c for colors
set('n', [[<leader>fd]], [[:Telescope lsp_document_diagnostics<CR>]]    ) -- d for diagnostics
set('n', [[<leader>ff]], [[:Telescope find_files<CR>]]                  ) -- f for files
set('n', [[<leader>fg]], [[:Telescope live_grep<CR>]]                   ) -- g for grep
set('n', [[<leader>fh]], [[:Telescope help_tags<CR>]]                   ) -- h for help
set('n', [[<leader>fk]], [[:Telescope keymaps<CR>]]                     ) -- k for keys
set('n', [[<leader>fm]], [[:Telescope marks<CR>]]                       ) -- m for (book)marks
set('n', [[<leader>fs]], [[:Telescope highlights<CR>]]                  ) -- s for syntax
set('n', [[<leader>fa]], [[:Telescope lsp_code_actions]]                ) -- a for actions
-- Git (g for git)
set('n', [[<leader>gc]], [[:Telescope git_commits<CR>]]                 ) -- c for commits
set('n', [[<leader>gs]], [[:Telescope git_status<CR>]]                  ) -- s for status

------ Tree -------
set('n', [[<leader>tt]], [[:NvimTreeToggle<CR>]]    ) -- Toggle filetree
set('n', [[<leader>te]], [[:Explore<CR>]]           ) -- Toggle file explorer (netrw)
set('n', [[<leader>tr]], [[:NvimTreeRefresh<CR>]]   ) -- Refresh filetree

----- Arduino -----
set('n', [[<leader>am]], [[:ArduinoVerify<CR>]], { buffer = 0 }             ) -- Build .ino
set('n', [[<leader>au]], [[:ArduinoUpload<CR>]], { buffer = 0 }             ) -- Upload .ino
set('n', [[<leader>ad]], [[:ArduinoUploadAndSerial<CR>]], { buffer = 0 }    ) -- "" and open serial
set('n', [[<leader>ab]], [[:ArduinoChooseBoard<CR>]], { buffer = 0 }        ) -- Choose arduino board
set('n', [[<leader>ap]], [[:ArduinoChooseProgrammer<CR>]], { buffer = 0 }   ) -- Choose "" programmer
