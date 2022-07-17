local beautiful = require('beautiful')
local naughty = require('naughty')
local menubar = require('menubar')

-- Notification settings
naughty.config.defaults['border_width'] = beautiful.notification_border_width
naughty.config.defaults.timeout = beautiful.notification_default_timeout
naughty.config.presets.low.timeout = beautiful.notification_low_timeout
naughty.config.presets.critical.timeout = beautiful.notification_critical_timeout

local _M = {}

-- >> Notify DWIM (Do What I Mean):
-- Create or update notification automagically. Requires storing the
-- notification in a variable.
-- Example usage:
--     local my_notif = notifications.notify_dwim({ title = "hello", message = "there" }, my_notif)
--     -- After a while, use this to update or recreate the notification if it is expired / dismissed
--     my_notif = notifications.notify_dwim({ title = "good", message = "bye" }, my_notif)
function _M.notify_dwim(args, notif)
    local n = notif
    if n and not n._private.is_destroyed and not n.is_expired then
        notif.title = args.title or notif.title
        notif.message = args.message or notif.message
        -- notif.text = args.text or notif.text
        notif.icon = args.icon or notif.icon
        notif.timeout = args.timeout or notif.timeout
    else
        n = naughty.notification(args)
    end
    return n
end

function _M.init(theme_name)
    -- Initialize various notification daemons
    require('notifications.volume')
    -- Load theme
    require('notifications.themes.' .. theme_name)
end

naughty.connect_signal('request::action_icon', function(a, _, hints)
    a.icon = menubar.utils.lookup_icon(hints.id)
end)

return _M
