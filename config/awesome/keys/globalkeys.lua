local gears = require('gears')
local awful = require('awful')
local hotkeys_popup = require('awful.hotkeys_popup')
local config = require('main.config')
local menu = require('main.menu')
local exit = require('elements.exit')
local switcher = require('elements.switcher')
local apps = require('main.apps')

local helpers = require('main.helpers')
local terminal = config.terminal
local super = config.modkey
local alt = 'Mod1'
local ctrl = 'Control'
local shift = 'Shift'

local _M = gears.table.join(
    -- Focus client by direction (hjkl)
    awful.key({ super }, 'j', function()
        awful.client.focus.bydirection('down')
    end, { description = 'focus down', group = 'client' }),
    awful.key({ super }, 'k', function()
        awful.client.focus.bydirection('up')
    end, { description = 'focus up', group = 'client' }),
    awful.key({ super }, 'h', function()
        awful.client.focus.bydirection('left')
    end, { description = 'focus left', group = 'client' }),
    awful.key({ super }, 'l', function()
        awful.client.focus.bydirection('right')
    end, { description = 'focus right', group = 'client' }),

    -- Focus client by direction (arrow keys)
    awful.key({ super }, 'Down', function()
        awful.client.focus.bydirection('down')
    end, { description = 'focus down', group = 'client' }),
    awful.key({ super }, 'Up', function()
        awful.client.focus.bydirection('up')
    end, { description = 'focus up', group = 'client' }),
    awful.key({ super }, 'Left', function()
        awful.client.focus.bydirection('left')
    end, { description = 'focus left', group = 'client' }),
    awful.key({ super }, 'Right', function()
        awful.client.focus.bydirection('right')
    end, { description = 'focus right', group = 'client' }),

    -- Layout manipulation
    awful.key(
        { super, shift },
        'o',
        awful.client.movetoscreen,
        { description = 'cycle client current screen', group = 'screen' }
    ),
    awful.key({ super }, 'o', function()
        awful.screen.focus_relative(1)
    end, { description = 'cycle focused screen', group = 'screen' }),

    -- Urgent or undo:
    -- Jump to urgent client or (if no such lient) go back to last tag
    awful.key({ super }, 'u', function()
        local uc = awful.client.urgent.get()
        if uc == nil then
            awful.tag.history.restore()
        else
            awful.client.urgent.jumpto()
        end
    end, { description = 'jump to urgent client', group = 'client' }),

    -- Focus client by index (cycle)
    awful.key({ super }, 'z', function()
        awful.client.focus.byidx(1)
    end, { description = 'focus next by index', group = 'client' }),
    awful.key({ super, shift }, 'z', function()
        awful.client.focus.byidx(-1)
    end, { description = 'focus previous by index', group = 'client' }),

    -- Gaps
    awful.key({ super, shift }, '=', function()
        awful.tag.incgap(5, nil)
    end, { description = 'increment gaps size for the current tag', group = 'gaps' }),
    awful.key({ super }, 'minus', function()
        awful.tag.incgap(-5, nil)
    end, { description = 'decrement gap size for the current tag', group = 'gaps' }),

    -- Kill all visible clients for the current tag
    awful.key({ super, alt }, 'q', function()
        local clients = awful.screen.focused().clients
        for _, c in pairs(clients) do
            c:kill()
        end
    end, { description = 'kill all visible clients for the current tag', group = 'client' }),

    -- Restart picom (generally in case of visual glitches)
    awful.key({ super }, 'Delete', function()
        awful.spawn.with_shell('~/.local/bin/restart-picom.sh')
    end, { description = 'restart picom', group = 'awesome' }),

    -- Show hotkkey help
    awful.key({ super }, 's', hotkeys_popup.show_help, { description = 'show help', group = 'awesome' }),
    awful.key({ super }, 'w', function()
        menu.mymainmenu:show()
    end, { description = 'show main menu', group = 'awesome' }),

    -- Standard program
    awful.key({ super }, 'Return', function()
        awful.spawn(terminal)
    end, { description = 'open a terminal', group = 'launcher' }),
    awful.key({ super, shift }, 'r', awesome.restart, { description = 'reload awesome', group = 'awesome' }),

    awful.key({ super, ctrl }, 'h', function()
        awful.tag.incmwfact(-0.05)
    end, { description = 'increase master width factor', group = 'layout' }),
    awful.key({ super, ctrl }, 'l', function()
        awful.tag.incmwfact(0.05)
    end, { description = 'decrease master width factor', group = 'layout' }),
    awful.key({ super, ctrl }, 'Left', function()
        awful.tag.incmwfact(-0.05)
    end, { description = 'increase master width factor', group = 'layout' }),
    awful.key({ super, ctrl }, 'Right', function()
        awful.tag.incmwfact(0.05)
    end, { description = 'decrease master width factor', group = 'layout' }),

    awful.key({ super, alt }, 'h', function()
        awful.tag.incnmaster(1, nil, true)
    end, { description = 'increase the number of master clients', group = 'layout' }),
    awful.key({ super, alt }, 'l', function()
        awful.tag.incnmaster(-1, nil, true)
    end, { description = 'decrease the number of master clients', group = 'layout' }),
    awful.key({ super, alt }, 'Left', function()
        awful.tag.incnmaster(1, nil, true)
    end, { description = 'increase the number of master clients', group = 'layout' }),
    awful.key({ super, alt }, 'Right', function()
        awful.tag.incnmaster(-1, nil, true)
    end, { description = 'decrease the number of master clients', group = 'layout' }),

    awful.key({ super, alt }, 'k', function()
        awful.tag.incncol(1, nil, true)
    end, { description = 'increase the number of columns', group = 'layout' }),
    awful.key({ super, alt }, 'j', function()
        awful.tag.incncol(-1, nil, true)
    end, { description = 'decrease the number of columns', group = 'layout' }),
    awful.key({ super, alt }, 'Up', function()
        awful.tag.incncol(1, nil, true)
    end, { description = 'increase the number of columns', group = 'layout' }),
    awful.key({ super, alt }, 'Down', function()
        awful.tag.incncol(-1, nil, true)
    end, { description = 'decrease the number of columns', group = 'layout' }),

    awful.key({ super }, 'space', function()
        awful.layout.inc(1)
    end, { description = 'select next', group = 'layout' }),
    awful.key({ super, shift }, 'space', function()
        awful.layout.inc(-1)
    end, { description = 'select previous', group = 'layout' }),

    awful.key({ super, ctrl }, 'n', function()
        local c = awful.client.restore()
        -- Focus restored client
        if c then
            c:emit_signal('request::activate', 'key.unminimize', { raise = true })
        end
    end, { description = 'restore minimized', group = 'client' }),

    -- Prompt
    awful.key({ super }, 'd', function()
        awful.spawn.with_shell('rofi -matching fuzzy -show drun')
    end, { description = 'rofi launcher', group = 'launcher' }),

    awful.key({ super }, '=', function()
        local s = awful.screen.focused()
        if s and s.enable_wibar then
            if s.statusbar.visible then
                s.disable_wibar()
            else
                s.enable_wibar()
            end
        end
    end, { description = 'Show/hide statusbar', group = 'screen' }),

    -- Exit screen
    awful.key({ super }, 'Escape', function()
        exit.show()
    end, { description = 'Show exit modal', group = 'awesome' }),
    awful.key({ super }, 'XF86PowerOff', function()
        exit.show()
    end, { description = 'Show exit modal', group = 'awesome' }),

    -- Volume control with volume keys
    awful.key({}, 'XF86AudioMute', function()
        helpers.volume_control(0)
    end, { description = '(un)mute volume', group = 'volume' }),
    awful.key({}, 'XF86AudioLowerVolume', function()
        helpers.volume_control(-5)
    end, { description = '(un)mute volume', group = 'volume' }),
    awful.key({}, 'XF86AudioRaiseVolume', function()
        helpers.volume_control(5)
    end, { description = '(un)mute volume', group = 'volume' }),

    awful.key({ super }, 'F6', function()
        helpers.run_or_raise({ class = 'Pavicontrol'}, false, 'pavucontrol')
    end, { description = 'open pulseaudio volume manager', group = 'volume' }),

    awful.key({}, 'XF86AudioPrev', function()
        awful.spawn.with_shell('playerctl previous')
    end, { description = 'general previous', group = 'media' }),
    awful.key({}, 'XF86AudioPlay', function()
        awful.spawn.with_shell('playerctl play-pause')
    end, { description = 'general pause/play', group = 'media' }),
    awful.key({}, 'XF86AudioPrev', function()
        awful.spawn.with_shell('playerctl next')
    end, { description = 'general next', group = 'media' }),

    -- Window switcher
    awful.key({ super }, 'Tab', function()
        switcher.show(awful.screen.focused())
    end, { description = 'Activate window switcher', group = 'client' }),
    awful.key({ alt }, 'Tab', function()
        switcher.show(awful.screen.focused())
    end, { description = 'Activate window switcher', group = 'client' }),

    -- Screenshots
    awful.key({ super }, 'c', function()
        apps.screenshot('full')
    end, { description = 'Take a full-screen screenshot', group = 'screen' }),
    awful.key({ super, ctrl }, 'c', function()
        apps.screenshot('selection')
    end, { description = 'Take a screenshot of selected area', group = 'screen' }),
    awful.key({ super, shift }, 'c', function()
        apps.screenshot('clipboard')
    end, { description = 'Copy selection of screen to clipboard', group = 'screen' })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    _M = gears.table.join(
        _M,
        -- View tag only.
        awful.key({ super }, '#' .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                tag:view_only()
            end
        end, { description = 'view tag #' .. i, group = 'tag' }),
        -- Toggle tag display.
        awful.key({ super, ctrl }, '#' .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end, { description = 'toggle tag #' .. i, group = 'tag' }),
        -- Move client to tag.
        awful.key({ super, shift }, '#' .. i + 9, function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end, { description = 'move focused client to tag #' .. i, group = 'tag' }),
        -- Toggle tag on focused client.
        awful.key({ super, ctrl, shift }, '#' .. i + 9, function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end, { description = 'toggle focused client on tag #' .. i, group = 'tag' })
    )
end

return _M
