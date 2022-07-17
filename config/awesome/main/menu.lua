local beautiful = require('beautiful')
local awful = require('awful')
local hotkeys_popup = require('awful.hotkeys_popup')
local config = require('main.config')

-- {{{ Menu
-- Create a launcher widget and a main menu
local _M = {
    myawesomemenu = {
        {
            'hotkeys',
            function()
                hotkeys_popup.show_help(nil, awful.screen.focused())
            end,
        },
        { 'manual', config.terminal .. ' -e man awesome' },
        { 'edit config', config.editor_cmd .. ' ' .. awesome.conffile },
        { 'restart', awesome.restart },
        {
            'quit',
            function()
                awesome.quit()
            end,
        },
    },
}

_M.mymainmenu = awful.menu({
    items = {
        { 'awesome', _M.myawesomemenu, beautiful.awesome_icon },
        { 'open terminal', config.terminal },
    },
})

_M.mylauncher = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = _M.mymainmenu,
})

-- }}}

return _M
