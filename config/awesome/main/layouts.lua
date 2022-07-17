local awful = require('awful')

-- Table of layouts to cover with awful.layout.inc, order matters.
local _M = {
    awful.layout.suit.tile.left,
    awful.layout.suit.floating,
    awful.layout.suit.tile.right,
    awful.layout.suit.tile.top,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.fair,
    awful.layout.suit.max,
    awful.layout.suit.magnifier,
}

return _M
