local gears = require('gears')
local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local helpers = require('main.helpers')

awful.screen.connect_for_each_screen(function(s)
    -- Imagebox widget which will contain an icon indicating current layout per screen
    s.layoutbox = awful.widget.layoutbox({
        screen = s,
        buttons = {
            awful.button({}, 1, function()
                awful.layout.inc(1)
            end),
            awful.button({}, 2, function()
                awful.layout.inc(-1)
            end),
            awful.button({}, 3, function()
                awful.layout.inc(-1)
            end),
            awful.button({}, 4, function()
                awful.layout.inc(1)
            end),
        },
    })
    s.layoutbox.forced_width = dpi(24)
    s.layoutbox.forced_height = dpi(24)

    -- Create a taglist for each screen
    s.mytaglist = awful.widget.taglist({
        screen = s,
        filter = awful.widget.taglist.filter.all,
        layout = {
            spacing = 11,
            layout = wibox.layout.fixed.horizontal,
        },
        widget_template = {
            {
                {
                    id = 'tag_circle',
                    bg = '#00000000', -- color of the circle
                    shape = gears.shape.circle,
                    widget = wibox.container.background,
                    forced_width = 18,
                    border_width = 3,
                    border_color = '#f6e3c9',
                },
                margins = 9,
                widget = wibox.container.margin,
            },
            widget = wibox.container.background,
            -- Add support for hover colors and an index label
            create_callback = function(self, tag, _, _)
                self:connect_signal('mouse::enter', function()
                    if self.bg ~= '#f6e3c940' then
                        self.backup = self.bg
                        self.has_backup = true
                    end
                    self.bg = '#f6e3c940'
                end)
                self:connect_signal('mouse::leave', function()
                    if self.has_backup then
                        self.bg = self.backup
                    end
                end)
                if tag.selected then
                    self:get_children_by_id('tag_circle')[1].bg = '#f6e3c9'
                elseif #tag:clients() > 0 then
                    self:get_children_by_id('tag_circle')[1].bg = '#f6e3c980'
                else
                    self:get_children_by_id('tag_circle')[1].bg = '#00000000'
                end
            end,
            update_callback = function(self, tag, _, _)
                if tag.selected then
                    self:get_children_by_id('tag_circle')[1].bg = '#f6e3c9'
                elseif #tag:clients() > 0 then
                    self:get_children_by_id('tag_circle')[1].bg = '#f6e3c980'
                else
                    self:get_children_by_id('tag_circle')[1].bg = '#00000000'
                end
            end,
        },
        buttons = {
            awful.button({}, 1, function(t)
                t:view_only()
            end),
            awful.button({}, 3, function(t)
                awful.tag.viewtoggle(t)
            end),
            awful.button({}, 4, function(t)
                awful.tag.viewprev(t.screen)
            end),
            awful.button({}, 5, function(t)
                awful.tag.viewnext(t.screen)
            end),
        },
    })

    local function decorate_cell(widget, flag, _)
        return wibox.widget({
            {
                widget,
                margins = flag == 'header' and dpi(6) or 0,
                widget = wibox.container.margin,
            },
            fg = '#f6e3c9',
            widget = wibox.container.background,
        })
    end

    s.calendar = wibox.widget({
        start_sunday = true,
        spacing = dpi(10),
        date = os.date('*t'),
        font = 'sans 14',
        fn_embed = decorate_cell,
        widget = wibox.widget.calendar.month,
    })

    s.calendarbox = awful.popup({
        screen = s,
        bg = '#00000000',
        visible = false,
        ontop = true,
        widget = {
            {
                s.calendar,
                widget = wibox.container.place,
            },
            forced_width = 325,
            forced_height = 430,
            bgimage = os.getenv('HOME') .. '/.config/awesome/img/witchy/calendar.svg',
            widget = wibox.container.background,
            buttons = {
                awful.button({}, 5, nil, function()
                    local date = s.calendar.date
                    if date.month >= 12 then
                        date.month = 1
                        date.year = date.year + 1
                    else
                        date.month = date.month + 1
                    end
                    s.calendar = wibox.widget({
                        start_sunday = true,
                        spacing = dpi(10),
                        date = date,
                        font = 'sans 14',
                        fn_embed = decorate_cell,
                        widget = wibox.widget.calendar.year,
                    })
                end),
            },
        },
    })

    awful.placement.top_left(s.calendarbox, { margins = { left = dpi(20), top = dpi(100) } })

    -- Create the full statusbar
    s.statusbar = awful.wibar({
        screen = s,
        visible = false,
        ontop = true,
        type = 'dock',
        height = dpi(60),
        bg = '#00000000',
        restrict_workarea = false,
    })

    s.mic_button = wibox.widget({
        widget = wibox.widget.textbox,
        font = 'icomoon-feather 14',
        markup = helpers.colorize_text('', '#f6e3c9'),
        buttons = {
            awful.button({}, 1, nil, function()
                awful.spawn.with_shell('pactl set-source-mute @DEFAULT_SOURCE@ toggle')
            end),
        },
    })

    awesome.connect_signal('sig::microphone', function(_, muted)
        if muted then
            s.mic_button.markup = helpers.colorize_text('', '#f6e3c9')
        else
            s.mic_button.markup = helpers.colorize_text('', '#f6e3c9')
        end
    end)

    local statusbar_options = {
        {
            {
                { -- Left
                    {
                        image = os.getenv('HOME') .. '/.config/awesome/img/witchy/left-corner.svg',
                        widget = wibox.widget.imagebox,
                    },
                    {
                        widget = wibox.widget.textclock,
                        font = 'serif 11',
                        format = helpers.colorize_text('%a, %b %d, %Y, %I:%M %P', '#f6e3c9'),
                        buttons = {
                            awful.button({}, 1, nil, function()
                                s.calendarbox.visible = not s.calendarbox.visible
                            end),
                        },
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                { -- Middle
                    s.mytaglist,
                    widget = wibox.container.place,
                    content_fill_vertical = true,
                },
                { -- Right
                    {
                        {
                            nil,
                            s.layoutbox,
                            expand = 'outside',
                            layout = wibox.layout.align.vertical,
                        },
                        margins = { right = dpi(30) },
                        widget = wibox.container.margin,
                    },
                    s.mic_button,
                    {
                        image = os.getenv('HOME') .. '/.config/awesome/img/witchy/right-corner.svg',
                        widget = wibox.widget.imagebox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                layout = wibox.layout.align.horizontal,
            },
            widget = wibox.container.background,
            border_width = dpi(1),
            border_color = '#f6e3c9',
            bg = '#171717',
        },
        widget = wibox.container.margin,
        left = 30,
        right = 30,
    }

    -- Systray (can only exist on one screen at a time)
    if s.index == 1 then
        s.systray = wibox.widget.systray()
        s.systray.horizontal = false
        s.systray.base_size = dpi(24)
        s.traybox = awful.popup({
            screen = s,
            height = dpi(150),
            width = dpi(52),
            bg = '#00000000',
            visible = false,
            ontop = true,
            widget = {
                {
                    s.systray,
                    widget = wibox.container.margin,
                    margins = dpi(15),
                },
                widget = wibox.container.background,
                bg = '#171717',
                border_color = '#f6e3c9',
                border_width = dpi(1),
            },
        })

        awful.placement.top_right(s.traybox, { margins = { top = dpi(90), left = 0, right = dpi(45), bottom = 0 } })

        local systray_button = wibox.widget({
            widget = wibox.widget.textbox,
            font = 'icomoon-feather 18',
            markup = helpers.colorize_text('', '#f6e3c9'),
            buttons = {
                awful.button({}, 1, nil, function()
                    s.traybox.visible = not s.traybox.visible
                end),
            },
        })

        s.traybox:connect_signal('property::visible', function(self)
            if self.visible then
                systray_button.markup = helpers.colorize_text('', '#f6e3c9')
            else
                systray_button.markup = helpers.colorize_text('', '#f6e3c9')
            end
        end)

        statusbar_options[1][1][3][2] = {
            {
                s.mic_button,
                systray_button,
                layout = wibox.layout.fixed.horizontal,
                spacing = dpi(28),
            },
            widget = wibox.container.margin,
            margins = { right = dpi(2) },
        }
    end

    s.statusbar:setup(statusbar_options)
    awful.placement.top(s.statusbar, { margins = 20 })

    -- Autohide/edge detection
    s.mouse_in = false

    s.detect = gears.timer({
        timeout = 0.35,
        callback = function()
            if (mouse.screen ~= s) or (mouse.coords().y < s.geometry.y + s.geometry.height - dpi(60)) then
                s.statusbar.visible = false
                s.traybox.visible = false
                s.calendarbox.visible = false
                s.detect:stop()
            end
        end,
    })

    s.enable_wibar = function()
        s.statusbar.visible = true
        if s.detect.started then
            s.detect:stop()
        end
    end

    s.disable_wibar = function()
        s.statusbar.visible = false
        if s.detect.started then
            s.detect:stop()
        end
    end

    s.autohide = function()
        if not s.detect.started and #s.clients > 0 then
            s.detect:start()
        end
    end

    s.activation_zone = wibox({
        screen = s,
        height = 1,
        bg = '#00000000',
        visible = true,
        ontop = true,
        type = 'dock',
        width = s.geometry.width,
    })

    for _, tag in ipairs(s.tags) do
        tag:connect_signal('tagged', function(_)
            if not s.mouse_in and #s.clients > 0 then
                s.disable_wibar()
            elseif not s.statusbar.visible then
                s.enable_wibar()
            end
        end)
        tag:connect_signal('untagged', function(_)
            if not s.mouse_in and #s.clients > 0 then
                s.disable_wibar()
            elseif not s.statusbar.visible then
                s.enable_wibar()
            end
        end)
    end

    s:connect_signal('tag::history::update', function()
        if #s.clients == 0 then
            s.enable_wibar()
        else
            if not s.mouse_in then
                s.disable_wibar()
            end
        end
    end)

    s.activation_zone:connect_signal('mouse::enter', function()
        s.mouse_in = true
        s.enable_wibar()
    end)
    s.activation_zone:connect_signal('mouse::leave', function()
        s.mouse_in = false
        s.autohide()
    end)
    s.statusbar:connect_signal('mouse::enter', function()
        s.mouse_in = true
        s.enable_wibar()
    end)
    s.statusbar:connect_signal('mouse::leave', function()
        s.mouse_in = false
        s.autohide()
    end)
    s.calendarbox:connect_signal('mouse::enter', function()
        s.mouse_in = true
        s.enable_wibar()
    end)
    s.calendarbox:connect_signal('mouse::leave', function()
        s.mouse_in = false
        s.autohide()
    end)
    if s.traybox then
        s.traybox:connect_signal('mouse::enter', function()
            s.mouse_in = true
            s.enable_wibar()
        end)
        s.traybox:connect_signal('mouse::leave', function()
            s.mouse_in = false
            s.autohide()
        end)
    end
end)
