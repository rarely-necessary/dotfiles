-- local icons = require('icons')
local notifications = require('notifications')

local notif
local timeout = 1.5
local init = false
local n = 'volume'
awesome.connect_signal('sig::volume', function(percentage, muted)
    if not init then
        init = true
    else
        if client.focus and client.focus.class == 'Pavucontrol' then
            if notif then
                notif:destroy()
            end
        else
            local message
            if muted then
                message = 'muted'
                n = 'muted'
            else
                message = tostring(percentage)
                n = 'volume'
            end

            notif = notifications.notify_dwim({
                title = 'Volume',
                message = message,
                app_name = n,
                timeout = timeout,
            }, notif)
        end
    end
end)
