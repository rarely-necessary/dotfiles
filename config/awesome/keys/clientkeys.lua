local gears = require('gears')
local awful = require('awful')
local config = require('main.config')
local helpers = require('main.helpers')
local super = config.modkey
local alt = 'Mod1'
local ctrl = 'Control'
local shift = 'Shift'

local _M = gears.table.join(
    awful.key({ super }, 'f', function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end, { description = 'toggle fullscreen', group = 'client' }),

    awful.key(
        { super, ctrl },
        'space',
        awful.client.floating.toggle,
        { description = 'toggle floating', group = 'client' }
    ),

    awful.key({ super, ctrl }, 'Return', function(c)
        c:swap(awful.client.getmaster())
    end, { description = 'move to master', group = 'client' }),

    awful.key({ super }, 't', function(c)
        c.ontop = not c.ontop
    end, { description = 'toggle keep on top', group = 'client' }),

    awful.key({ super }, 'n', function(c)
        -- The client currently has the input focus, so it cannot be
        -- minimized, since minimized clients can't have the focus.
        c.minimized = true
    end, { description = 'minimize', group = 'client' }),

    awful.key({ super }, 'm', function(c)
        c.maximized = not c.maximized
        c:raise()
    end, { description = '(un)maximize', group = 'client' }),

    awful.key({ super, ctrl }, 'm', function(c)
        c.maximized_vertical = not c.maximized_vertical
        c:raise()
    end, { description = '(un)maximize vertically', group = 'client' }),

    awful.key({ super, shift }, 'm', function(c)
        c.maximized_horizontal = not c.maximized_horizontal
        c:raise()
    end, { description = '(un)maximize horizontally', group = 'client' }),

    awful.key({ super, shift }, 'q', function(c)
        c:kill()
    end, { description = 'close client', group = 'client' }),
    awful.key({ alt }, 'F4', function(c)
        c:kill()
    end, { description = 'close client', group = 'client' }),

    -- Move client (hjkl)
    awful.key({ super, shift }, 'l', function(c)
        helpers.move_client_dwim(c, 'right')
    end, { description = 'move client to the right' }),
    awful.key({ super, shift }, 'h', function(c)
        helpers.move_client_dwim(c, 'left')
    end, { description = 'move client to the left' }),
    awful.key({ super, shift }, 'k', function(c)
        helpers.move_client_dwim(c, 'up')
    end, { description = 'move client up' }),
    awful.key({ super, shift }, 'j', function(c)
        helpers.move_client_dwim(c, 'down')
    end, { description = 'move client down' }),

    -- Move client (arrow keys)
    awful.key({ super, shift }, 'Right', function(c)
        helpers.move_client_dwim(c, 'right')
    end, { description = 'move client to the right', group = 'client' }),
    awful.key({ super, shift }, 'Left', function(c)
        helpers.move_client_dwim(c, 'left')
    end, { description = 'move client to the left', group = 'client' }),
    awful.key({ super, shift }, 'Up', function(c)
        helpers.move_client_dwim(c, 'up')
    end, { description = 'move client up', group = 'client' }),
    awful.key({ super, shift }, 'Down', function(c)
        helpers.move_client_dwim(c, 'down')
    end, { description = 'move client down', group = 'client' })
)

return _M
