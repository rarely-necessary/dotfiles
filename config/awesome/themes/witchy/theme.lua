local gears = require('gears')
local gfs = require('gears.filesystem')
local xresources = require('beautiful.xresources')
local dpi = xresources.apply_dpi

local themes_path = gfs.get_themes_dir() .. 'zenburn/layouts/'

local theme = {
    font = 'sans 11',
    wallpaper = os.getenv('HOME') .. '/Pictures/wallpapers/hands.jpg',
    icon_theme = os.getenv('HOME') .. '/.local/share/icons/Quogir-dark',
    bg_systray = '#171717',
    systray_icon_spacing = dpi(15),

    -- Gaps
    useless_gap = dpi(5),
    screen_margin = dpi(5),

    -- Borders
    border_width = dpi(4),
    border_radius = dpi(3),

    -- Titlebars
    titlebars_enabled = false,

    -- Notifications
    notification_position = 'bottom_left',
    notification_margin = dpi(16),
    notification_opacity = 1,
    notification_title_font = 'serif 11',
    notification_font = 'sans 11',
    notification_padding = dpi(5) * 2,
    notification_spacing = dpi(5) * 4,
    notification_default_timeout = 5,
    notification_low_timeout = 2,
    notification_critical_timeout = 12,
    notification_bg = '#171717',
    notification_fg = '#f6e9c9',
    notification_action_fg_normal = '#171717',
    notification_action_bg_normal = '#f6e3c9',
    notification_action_fg_selected = '#17171780',
    notification_action_bg_selected = '#f6e3c980',

    -- Edge snap
    snap_shape = gears.shape.rectangle,
    snap_border_width = dpi(3),

    -- Tags
    tagnames = {
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
        '9',
        '0',
    },

    -- Wibar(s) handled in deco/statusbar
    layout_fairh = themes_path .. 'fairh.png',
    layout_fairv = themes_path .. 'fairv.png',
    layout_floating = themes_path .. 'floating.png',
    layout_magnifier = themes_path .. 'magnifier.png',
    layout_max = themes_path .. 'max.png',
    layout_fullscreen = themes_path .. 'fullscreen.png',
    layout_tilebottom = themes_path .. 'tilebottom.png',
    layout_tileleft = themes_path .. 'tileleft.png',
    layout_tile = themes_path .. 'tile.png',
    layout_tiletop = themes_path .. 'tiletop.png',
    layout_spiral = themes_path .. 'spiral.png',
    layout_dwindle = themes_path .. 'dwindle.png',
    layout_cornernw = themes_path .. 'cornernww.png',
    layout_cornerne = themes_path .. 'cornernew.png',
    layout_cornersw = themes_path .. 'cornersww.png',
    layout_cornerse = themes_path .. 'cornersew.png',

    -- Exit screen
    -- exit_screen_bg =
    -- exit_screen_fg =
    -- exit_screen_font =
    -- exit_screen_icon_size = dpi(180),

    -- Lock screen
    -- lock_screen_bg =
    -- lock_screen_fg =
    tasklist_bg_normal = '#171717',
    tasklist_border_color = '#f6e3c9',
    tasklist_border_width = 1,
    tasklist_fg_normal = '#5a5a5a',
    tasklist_fg_focus = '#f6e3c9',
}

return theme
