local awful = require('awful')
local layouts = require('main.layouts')

-- Each screen has its own tag table.
awful.screen.connect_for_each_screen(function(s)
    awful.tag({ '1', '2', '3', '4', '5', '6', '7', '8', '9' }, s, layouts[1])
end)
