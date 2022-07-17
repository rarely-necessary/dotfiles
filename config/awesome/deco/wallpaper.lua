local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')

local function set_wallpaper(s)
    awful.wallpaper({
        screen = s,
        widget = {
            {
                image = beautiful.wallpaper,
                widget = wibox.widget.imagebox,
                resize = true,
            },
            valign = 'canter',
            halign = 'center',
            tiled = false,
            widget = wibox.container.tile,
        },
    })
end

screen.connect_signal('request::wallpaper', function(s)
    set_wallpaper(s)
end)
