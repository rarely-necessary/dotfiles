local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local naughty = require('naughty')
local helpers = require('main.helpers')
local xresources = require('beautiful.xresources')
local dpi = xresources.apply_dpi

-- For antialiasing
-- The real background color is set in the widget_template

local default_icon = ''

local app_config = {
    ['volume'] = { icon = '', title = false },
    ['muted'] = { icon = '', title = false },
    ['screenshot'] = { icon = '', title = false },
    ['night_mode'] = { icon = '', title = false },
    ['NetworkManager'] = { icon = '', title = true },
    ['playerctl'] = { icon = '', title = true },
    ['mpv'] = { icon = '', title = true },
    ['play'] = { icon = '', title = true },
    ['pause'] = { icon = '', title = true },
}

naughty.connect_signal('request::display', function(n)
    local icon, title_visible
    local color = '#f6e3c9'

    if app_config[n.app_name] then
        icon = app_config[n.app_name].icon
        title_visible = app_config[n.app_name].title
    else
        icon = default_icon
        title_visible = true
    end

    local actions = wibox.widget({
        notification = n,
        base_layout = wibox.widget({
            spacing = dpi(10),
            layout = wibox.layout.flex.horizontal,
        }),
        widget_template = {
            {
                {
                    {
                        id = 'text_role',
                        font = 'sans 11',
                        widget = wibox.widget.textbox,
                    },
                    left = dpi(6),
                    right = dpi(6),
                    widget = wibox.container.margin,
                },
                widget = wibox.container.place,
            },
            forced_height = dpi(25),
            forced_width = dpi(70),
            bg = beautiful.notification_action_bg_normal,
            widget = wibox.container.background,
        },
        style = {
            underline_normal = false,
            underline_selected = true,
        },
        widget = naughty.list.actions,
    })

    naughty.layout.box({
        notification = n,
        type = 'notification',
        -- For antialiasing: The real shape is set in widget_template
        shape = gears.shape.rectangle,
        border_width = dpi(0),
        position = beautiful.notification_position,
        bg = '#00000000',
        widget_template = {
            {
                {
                    {
                        {
                            {
                                image = os.getenv('HOME') .. '/.config/awesome/img/witchy/notif.svg',
                                resize = true,
                                upscale = false,
                                downscale = true,
                                halign = 'center',
                                widget = wibox.widget.imagebox,
                                forced_height = dpi(100),
                            },
                            widget = wibox.container.margin,
                            margins = { top = dpi(10) },
                        },
                        {
                            markup = helpers.colorize_text(icon, color),
                            align = 'center',
                            valign = 'center',
                            font = 'icomoon-feather 18',
                            widget = wibox.widget.textbox,
                        },
                        {
                            align = 'center',
                            visible = title_visible,
                            font = beautiful.notification_title_font,
                            markup = '<b>' .. helpers.colorize_text(n.title, beautiful.notification_fg) .. '</b>',
                            widget = wibox.widget.textbox,
                        },
                        {
                            align = 'center',
                            widget = naughty.widget.message,
                        },
                        {
                            {
                                actions,
                                widget = wibox.container.background,
                            },
                            visible = n.actions and #n.actions > 0,
                            widget = wibox.container.place,
                        },
                        spacing = 20,
                        layout = wibox.layout.fixed.vertical,
                    },
                    margins = beautiful.notification_margin,
                    widget = wibox.container.margin,
                },
                strategy = 'max',
                width = beautiful.notification_max_width or dpi(350),
                height = beautiful.notification_max_height or dpi(180),
                widget = wibox.container.constraint,
            },
            shape = gears.shape.rectangle,
            shape_border_width = beautiful.notification_border_width,
            shape_border_color = beautiful.notification_border_color,
            -- bg = notification_bg,
            bgimage = os.getenv('HOME') .. '/.config/awesome/img/witchy/notification.svg',
            widget = wibox.container.background,
            forced_width = 428,
            forced_height = 306,
        },
    })
end)
