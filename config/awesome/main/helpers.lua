local awful = require('awful')
local beautiful = require('beautiful')
local xresources = require('beautiful.xresources')
local wibox = require('wibox')
local dpi = xresources.apply_dpi

local helpers = {}

function helpers.vertical_pad(height)
    return wibox.widget({
        forced_height = height,
        layout = wibox.layout.fixed.vertical,
    })
end

function helpers.horizontal_pad(width)
    return wibox.widget({
        forced_width = width,
        layout = wibox.layout.fixed.horizontal,
    })
end

function helpers.colorize_text(text, color)
    return "<span foreground='" .. color .. "'>" .. text .. '</span>'
end

function helpers.color_mix(color1, color2, perc)
    local p = perc or 0.5
    local q = -perc

    color1 = color1:gsub('#', '')
    color2 = color2:gsub('#', '')

    local red = math.floor(p * tonumber('0x' .. color1.sub(1, 2) + q * tonumber('0x' .. color2:sub(1, 2))))
    local green = math.floor(p * tonumber('0x' .. color1.sub(3, 4) + q * tonumber('0x' .. color2:sub(3, 4))))
    local blue = math.floor(p * tonumber('0x' .. color1.sub(5, 6) + q * tonumber('0x' .. color2:sub(5, 6))))

    local hex = '#' .. string.format('%x', red) .. string.format('%x', green) .. string.format('%x', blue)
    return hex
end

-- Add a hover cursor to a widget by changing the cursor on
-- mouse::enter and mouse::leave
-- You can find the names of the available cursors by opening any
-- cursor theme and looking in the "cursors folder"
-- For example: "hand1" is the cursor that appears when hovering over links
function helpers.add_hover_cursor(w, hover_cursor)
    local original_cursor = 'left_ptr'

    w:connect_signal('mouse::enter', function()
        local b = _G.mouse.current_wibox
        if b then
            b.cursor = hover_cursor
        end
    end)

    w:connect_signal('mouse::exit', function()
        local b = _G.mouse.current_wibox
        if b then
            b.cursor = original_cursor
        end
    end)
end

-- Tag back and forth:
-- If you try to focus the tag you are already at, go back to the previous tag.
-- Useful for quick switching after for example checking an incoming chat
-- message at tagand coming back to your work at tagwith the same
-- keypress.
function helpers.tag_back_and_forth(tag_index)
    local s = mouse.screen
    local tag = s.tags[tag_index]
    if tag then
        if tag == s.selected_tag then
            awful.tag.history.restore()
        else
            tag:view_only()
        end
    end
end

local direction_translate = {
    ['up'] = 'top',
    ['down'] = 'bottom',
    ['left'] = 'left',
    ['right'] = 'right',
}
function helpers.move_to_edge(c, direction)
    local old = c:geometry()
    local new = awful.placement[direction_translate[direction]](
        c,
        { honor_padding = true, honor_workarea = true, margins = beautiful.useless_gap * 2, pretend = true }
    )
    if direction == 'up' or direction == 'down' then
        c:geometry({ x = old.x, y = new.y })
    else
        c:geometry({ x = new.x, y = new.y })
    end
end

-- Resize DWIM (Do What I Mean)
-- Resize client or factor
-- Constants --
local floating_resize_amount = dpi(10)
local tiling_resize_factor = 0.
---------------
function helpers.resize_dwim(c, direction)
    if c and c.floating then
        if direction == 'up' then
            c:relative_move(0, 0, 0, -floating_resize_amount)
        elseif direction == 'down' then
            c:relative_move(0, 0, 0, floating_resize_amount)
        elseif direction == 'left' then
            c:relative_move(0, 0, -floating_resize_amount, 0)
        elseif direction == 'right' then
            c:relative_move(0, 0, floating_resize_amount, 0)
        end
    elseif awful.layout.get(mouse.screen) ~= awful.layout.suit.floating then
        if direction == 'up' then
            awful.client.incwfact(-tiling_resize_factor)
        elseif direction == 'down' then
            awful.client.incwfact(tiling_resize_factor)
        elseif direction == 'left' then
            awful.tag.incmwfact(-tiling_resize_factor)
        elseif direction == 'right' then
            awful.tag.incmwfact(tiling_resize_factor)
        end
    end
end

-- Move client DWIM (Do What I Mean)
-- Move to edge if the client / layout is floating
-- Swap by index if maximized
-- Else swap client by direction
function helpers.move_client_dwim(c, direction)
    if c.floating or (awful.layout.get(mouse.screen) == awful.layout.suit.floating) then
        helpers.move_to_edge(c, direction)
    elseif awful.layout.get(mouse.screen) == awful.layout.suit.max then
        if direction == 'up' or direction == 'left' then
            awful.client.swap.byidx(-1, c)
        elseif direction == 'down' or direction == 'right' then
            awful.client.swap.byidx(1, c)
        end
    else
        awful.client.swap.bydirection(direction, c, nil)
    end
end

function helpers.round(number, decimals)
    local power = 10 ^ decimals
    return math.floor(number * power) / power
end

function helpers.volume_control(step)
    local cmd
    if step == 0 then
        cmd = 'pactl set-sink-mute @DEFAULT_SINK@ toggle'
    else
        local sign = step > 0 and '+' or ''
        cmd = table.concat({
            'pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ ',
            sign,
            tostring(step),
            '%',
        })
    end
    awful.spawn.with_shell(cmd)
end

function helpers.send_key(c, key)
    awful.spawn.with_shell('xdotool key --window ' .. tostring(c.window) .. ' ' .. key)
end

function helpers.send_key_sequence(c, seq)
    awful.spawn.with_shell('xdotool type --delay 5 --window ' .. tostring(c.window) .. ' ' .. seq)
end

function helpers.fake_escape()
    root.fake_input('key_press', 'Escape')
    root.fake_input('key_press', 'Escape')
end

-- Given a 'match' condition, returns an array with clients that match it, or
-- just the first found client if 'first_only' is true
function helpers.find_clients(match, first_only)
    local function matcher(c)
        return awful.rules.match(c, match)
    end

    if first_only then
        for c in awful.client.iterate(matcher) do
            return c
        end
    else
        local clients = {}
        for c in awful.client.iterate(matcher) do
            table.insert(clients, c)
        end
        return clients
    end
    return nil
end

-- Given a 'match' condition, calls the specified function 'f_do' on all the
-- clients that match it
function helpers.find_clients(match, f_do)
    local function matcher(c)
        return awful.rules.match(c, match)
    end

    for c in awful.client.iterate(matcher) do
        f_do(c)
    end
end

function helpers.run_or_raise(match, move, spawn_cmd, spawn_args)
    local function matcher(c)
        return awful.rules.match(c, match)
    end

    -- Find and raise
    local found = false
    for c in awful.client.iterate(matcher) do
        found = true
        c.minimized = false
        if move then
            c:move_to_tag(mouse.screen.select.selected_tag)
            client.focus = c
        else
            c:jump_to()
        end
        break
    end

    -- Spawn if not found
    if not found then
        awful.spawn(spawn_cmd, spawn_args)
    end
end

return helpers
