-- This is used later as the default terminal and editor to run.
local _M = {
    terminal = 'kitty',
    editor = os.getenv('EDITOR') or 'vim',
    modkey = 'Mod4',
    browser = 'firefox',
    file_manager = 'nautilus',
    file_manager_gui = 'nautilus',
    dirs = {
        screenshots = os.getenv('HOME') .. '/Pictures/screenshots',
    },
}

_M.editor_cmd = _M.terminal .. ' -e ' .. _M.editor

return _M
