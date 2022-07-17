require('impatient').enable_profile()
-------------------------- HELPERS --------------------------
local cmd, fn = vim.cmd, vim.fn          --Commands and functions
local autocmd = vim.api.nvim_create_autocmd
local g, v = vim.g, vim.v                --Variables
local go, bo, wo = vim.o, vim.bo, vim.wo --Options

local function MyFoldText()
    local line = fn.getline(v.foldstart)
    local sub = fn.substitute(line, [[/\*\|\*/\|{{{\d\=]], '', 'g')
    return v.folddashes .. sub
end

-------------------------- PLUGINS --------------------------
cmd 'packadd packer.nvim'

---------------------- CUSTOM COMMANDS ----------------------
cmd 'command -nargs=1 Tabs :set tabstop=<args> shiftwidth=<args>'

-------------------------- OPTIONS --------------------------
------- General -------
cmd 'filetype plugin indent on'
cmd 'syntax enable'
g.mapleader         = ' '                     --Set leader to <Space>
g.python_host_prog  = 0                       --Disable python2
g.python3_host_prog = '/bin/python'           --Define python exe (helps startup time?)
go.completeopt      = 'menu,menuone,noselect'
go.ignorecase       = true                    --Ignore case when searching
go.smartcase        = true                    --...unless capital letters are used
go.backspace        = 'indent,eol,start'      --Better backspace behavior

----- Tabs/Spaces -----
bo.expandtab  = true                          --Uses spaces not tabs
bo.shiftwidth = 4                             --Number of spaces for autoindent
bo.tabstop    = 4                             --Number of spaces a tab counts for

------- Folding -------
wo.foldmethod = 'expr'                        --Use tree-sitter for folding
wo.foldexpr   = 'nvim_treesitter#foldexpr()'
wo.foldlevel  = 999                           --Don't fold by default
wo.foldtext   = MyFoldText()                  --Custom fold text

------ Interface ------
go.showmode       = false                     --Don't show the mode we're in (statusline does that)
go.scrolloff      = 999                       --Typewriter mode
bo.textwidth      = 999                       --No wrapping by default
wo.number         = true                      --Show line numbers (absolute)
wo.relativenumber = true                      --Show line numbers (relative)
wo.signcolumn     = 'number'                  --Keep errors in the line number column

-------- Color --------
go.termguicolors = true                       -- GUI colors in terminal

------ Autocmds -------
autocmd({ 'TermOpen' }, {
    pattern = { '*' },
    command = 'setlocal nonumber norelativenumber'
})

------------------------- HIGHLIGHT -------------------------
cmd 'colorscheme elly-lua'

-- Stop the colorscheme from changing the terminal background
-- cmd 'autocmd Colorscheme * highlight Normal ctermbg=NONE guibg=NONE'

------------------------- EXTERNALS -------------------------
require('plugins')          -- Packer config
require('keys')             -- Keymappings
require('tabline').setup()  -- Custom tabline UI
require('packer_compiled')
require('statusline').setup()
