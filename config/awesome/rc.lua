-- If LuaRocks is installd, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, 'luarocks.loader')

-- Standard awesome library
local awful = require('awful')
local menubar = require('menubar')
require('awful.autofocus')
-- Theme handling library
local beautiful = require('beautiful')
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require('awful.hotkeys_popup.keys')

require('main.errors')
require('main.tags')
require('main.signals')
require('signals')

local config = require('main.config')
local rules = require('main.rules')
local notifications = require('notifications')
notifications.init('witchy')

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
local theme = require('themes.witchy.theme')
beautiful.init(theme)

-- beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

awful.layout.layouts = require('main.layouts')
menubar.utils.terminal = config.terminal -- Set the terminal for applications that require it
-- }}}

local keys = {
    clientbuttons = require('keys.clientbuttons'),
    clientkeys = require('keys.clientkeys'),
    globalbuttons = require('keys.globalbuttons'),
    globalkeys = require('keys.globalkeys'),
}

root.buttons(keys.globalbuttons)
root.keys(keys.globalkeys)

awful.rules.rules = rules(keys.clientkeys, keys.clientbuttons)
require('deco')
require('elements.exit').init()
require('elements.switcher').init()
require('elements.statusbar')
