local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')
local helpers = require('main.helpers')
local xresources = require('beautiful.xresources')
local dpi = xresources.apply_dpi

local _M = {}

-- Feather symbols
local icon_font = 'icomoon-feather 40'
local poweroff_text_icon = ''
local reboot_text_icon = ''
local suspend_text_icon = ''
local exit_text_icon = ''
local lock_text_icon = ''

local button_bg = '#171717'
local button_size = dpi(120)

-- Commands
local function poweroff_command()
    awful.spawn.with_shell('poweroff')
end
local function reboot_command()
    awful.spawn.with_shell('reboot')
end
local function suspend_command()
    _M.show()
    awful.spawn.with_shell('systemctl suspend')
end
local function exit_command()
    awesome.quit()
end
local function lock_command()
    awful.spawn.with_shell('betterlockscreen -l dimblur')
end

-- Helper function that generates the clickable buttons

local function create_button(symbol, hover_color, _, command)
    local icon = wibox.widget({
        forced_height = button_size,
        forced_width = button_size,
        align = 'center',
        valign = 'center',
        font = icon_font,
        text = symbol,
        -- markup = helpers.colorize_text(symbol, color),
        widget = wibox.widget.textbox(),
    })

    -- Bind left click to run the command
    icon:buttons(gears.table.join(awful.button({}, 1, function()
        command()
    end)))

    -- Change color on hover
    icon:connect_signal('mouse::enter', function()
        icon.markup = helpers.colorize_text(icon.text, hover_color)
        -- button.border_color = hover_color
    end)
    icon:connect_signal('mouse::leave', function()
        icon.markup = helpers.colorize_text(icon.text, '#e0e5e3')
        -- button.border_color = button_bg
    end)

    -- Use helper function to change the cursor on hover
    helpers.add_hover_cursor(icon, 'hand1')

    return icon
end

-- Create the buttons
local poweroff = create_button(poweroff_text_icon, '#f6e3c9', 'Poweroff', poweroff_command)
local reboot = create_button(reboot_text_icon, '#f6e3c9', 'Reboot', reboot_command)
local suspend = create_button(suspend_text_icon, '#f6e3c9', 'Suspend', suspend_command)
local exit = create_button(exit_text_icon, '#f6e3c9', 'Exit', exit_command)
local lock = create_button(lock_text_icon, '#f6e3c9', 'Lock', lock_command)

local exit_screen = wibox({ visible = false, ontop = true, type = 'dock' })

function _M.init()
    awful.placement.maximize(exit_screen)

    exit_screen.bg = beautiful.exit_screen_bg or beautiful.wibar_bg or '#171717'
    exit_screen.fg = beautiful.exit_screen_fg or beautiful.wibar_fg or '#e0e5e3'

    exit_screen:buttons(gears.table.join(
        -- Left click - Hide exit_screen
        awful.button({}, 1, function()
            _M.hide()
        end),
        -- Middle click - Hide exit_screen
        awful.button({}, 2, function()
            _M.hide()
        end),
        -- Right click - Hide exit_screen
        awful.button({}, 3, function()
            _M.hide()
        end)
    ))

    local menu = wibox.widget({
        nil,
        {
            nil,
            {
                nil,
                {
                    nil,
                    poweroff,
                    reboot,
                    suspend,
                    exit,
                    lock,
                    spacing = dpi(25),
                    layout = wibox.layout.fixed.horizontal,
                },
                left = dpi(25),
                right = dpi(25),
                widget = wibox.container.margin
            },
            align = 'center',
            valign = 'center',
            forced_height = button_size * 1.5,
            forced_width = button_size * 5 + 6 * dpi(25),
            border_width = dpi(8),
            border_color = button_bg,
            -- shape = helpers.rrect(dpi(20)),
            bg = button_bg,
            widget = wibox.container.background,
        },
        expand = 'none',
        layout = wibox.layout.align.horizontal,
    })

    exit_screen:setup({
        nil,
        {
            nil,
            {
                nil,
                {
                    nil,
                    {
                        nil,
                        {
                            nil,
                            menu,
                            expand = 'none',
                            layout = wibox.layout.align.vertical,
                        },
                        align = 'center',
                        vlaign = 'center',
                        -- forced_height = button_size*1.5 + 0.4*button_size,
                        -- forced_width = button_size*5+6*dpi(25) + 0.4*button_size,
                        forced_height = button_size * 1.5,
                        forced_width = button_size * 5 + 6 * dpi(25) + dpi(10),
                        -- border_width = dpi(12),
                        -- border_color = button_bg,
                        -- shape = helpers.rrect(dpi(20)),
                        bg = beautiful.border_inner,
                        widget = wibox.container.background,
                    },
                    expand = 'none',
                    layout = wibox.layout.align.horizontal,
                },
                -- expand = "none",
                -- layout = wibox.layout.align.vertical
                align = 'center',
                vlaign = 'center',
                -- forced_height = button_size*1.5 + 0.4*button_size,
                -- forced_width = button_size*5+6*dpi(25) + 0.4*button_size,
                forced_height = button_size * 1.5,
                forced_width = button_size * 5 + 6 * dpi(25) + dpi(20),
                -- border_width = dpi(12),
                -- border_color = button_bg,
                -- shape = helpers.rrect(dpi(20)),
                bg = beautiful.border_outer,
                widget = wibox.container.background,
            },
            expand = 'none',
            layout = wibox.layout.align.horizontal,
        },
        expand = 'none',
        layout = wibox.layout.align.vertical,
    })
end

local exit_screen_grabber
function _M.hide()
    awful.keygrabber.stop(exit_screen_grabber)
    exit_screen.visible = false
end

local keybinds = {
    ['escape'] = _M.hide,
    ['q'] = _M.hide,
    ['x'] = _M.hide,
    ['s'] = function()
        suspend_command()
        _M.hide()
    end,
    ['e'] = exit_command,
    ['p'] = poweroff_command,
    ['r'] = reboot_command,
    ['l'] = function()
        lock_command()
        -- Kinda fixes the "white" (undimmed) flash that appears between
        -- exit screen disappearing and lock screen appearing
        gears.timer.delayed_call(function()
            _M.hide()
        end)
    end,
}

function _M.show()
    exit_screen_grabber = awful.keygrabber.run(function(_, key, event)
        -- Ignore case
        key = key:lower()

        if event == 'release' then
            return
        end

        if keybinds[key] then
            keybinds[key]()
        end
    end)
    exit_screen.visible = true
end

return _M
