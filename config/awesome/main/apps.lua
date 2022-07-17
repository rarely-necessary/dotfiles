local awful = require('awful')
local naughty = require('naughty')
local icons = require('deco.icons')
local helpers = require('main.helpers')
local config = require('main.config')
local notifications = require('notifications')
local apps = {}

function apps.browser()
    awful.spawn(config.browser, { switchtotag = true })
end

function apps.file_manager()
    awful.spawn(config.file_manager, { floating = true })
end

function apps.file_manager_gui()
    awful.spawn(config.file_manager_gui, { floating = true })
end

function apps.discord() -- FIXME ?
    helpers.run_or_raise(
        { insance = 'discordapp.com__channels_@me' },
        false,
        'chromium --app="https://discordapp.com/channels/@me"'
    )
end

function apps.gimp()
    helpers.run_or_raise({ class = 'Gimp' }, false, 'gimp')
end

function apps.steam()
    helpers.run_or_raise({ class = 'Steam' }, false, 'steam')
end

function apps.lutris()
    helpers.run_or_raise({ class = 'Lutris' }, false, 'lutris')
end

function apps.volume_control()
    helpers.run_or_raise({ class = 'Pavucontrol' }, false, 'pavucontrol')
end

function apps.editor()
    helpers.run_or_raise({ instance = 'editor' }, false, config.editor, { switchtotag = true })
end

function apps.compositor()
    awful.spawn.with_shell(
        "sh -c 'pgrep picom > /dev/null && kill picom || "
            .. "picom  --experimental-backends --config $HOME/.config/picom/picom.conf & disown'"
    )
end

function apps.process_monitor()
    helpers.run_or_raise(
        { instance = 'btop' },
        false,
        config.terminal .. '--class btop -e btop',
        { switchtotag = true }
    )
end

function apps.temperature_monitor()
    helpers.run_or_raise(
        { instance = 'sensors' },
        false,
        config.terminal .. '--class sensors -e watch sensors',
        { switchtotag = true, tag = awful.mouse.screen.tags[5] }
    )
end

-- Screenshots
local capture_notif = nil
local screenshot_notification_app_name = 'screenshot'
function apps.screenshot(action, delay)
    -- Read-only actions
    if action == 'browse' then
        awful.spawn.with_shell('cd ' .. config.dirs.screenshots .. ' && imv $(ls -t)')
        return
    elseif action == 'gimp' then
        awful.spawn.with_shell('cd ' .. config.dirs.screenshots .. ' && gimp $(ls -t | head -n1)')
        return
    end

    -- Screenshot capturing actions
    local cmd
    local timestamp = os.date('%Y.%m.%d-%H.%M.%S')
    local filename = config.dirs.screenshots .. '/' .. timestamp .. '.screenshot.png'
    local maim_args = '-u -b 3 -m 5'
    local icon = icons.screenshot

    local prefix
    if delay then
        prefix = 'sleep ' .. tostring(delay) .. ' && '
    else
        prefix = ''
    end

    -- Configure action buttons for the notification
    local screenshot_open = naughty.action({ name = 'Open' })
    local screenshot_copy = naughty.action({ name = 'Copy' })
    local screenshot_edit = naughty.action({ name = 'Edit' })
    local screenshot_delete = naughty.action({ name = 'Delete' })

    screenshot_open:connect_signal('invoked', function()
        awful.spawn.with_shell('cd ' .. config.dirs.screenshots .. ' && imv $(ls -t)')
    end)
    screenshot_copy:connect_signal('invoked', function()
        awful.spawn.with_shell('xclip -selection clipboard -t image/png ' .. filename .. '&>/dev/null')
    end)
    screenshot_edit:connect_signal('invoked', function()
        awful.spawn.with_shell('gimp ' .. filename .. ' >/dev/null')
    end)
    screenshot_delete:connect_signal('invoked', function()
        awful.spawn.with_shell('rm ' .. filename)
    end)

    if action == 'full' then
        cmd = prefix .. 'maim ' .. maim_args .. ' ' .. filename
        awful.spawn.easy_async_with_shell(cmd, function()
            naughty.notification({
                title = 'Screenshot',
                message = 'Screenshot taken',
                icon = icon,
                actions = { screenshot_open, screenshot_copy, screenshot_edit, screenshot_delete },
                app_name = screenshot_notification_app_name,
            })
        end)
    elseif action == 'selection' then
        cmd = 'maim ' .. maim_args .. ' -s ' .. filename
        capture_notif = naughty.notification({
            title = 'Screenshot',
            message = 'Select area to capture.',
            icon = icon,
            timeout = 1,
            app_name = screenshot_notification_app_name,
        })
        awful.spawn.easy_async_with_shell(cmd, function()
            naughty.notification({
                title = 'Screenshot',
                message = 'Screenshot taken',
                icon = icon,
                actions = { screenshot_open, screenshot_copy, screenshot_edit, screenshot_delete },
                app_name = screenshot_notification_app_name,
            })
        end)
    elseif action == 'clipboard' then
        capture_notif = naughty.notification({
            title = 'Screenshot',
            message = 'Select area to copy to clipboard',
            icon = icon,
        })
        cmd = 'maim '
            .. maim_args
            .. ' -s /tmp/maim_clipboard && xclip -selection clipboard -t image/png /tmp/maim_clipboard &>/dev/null && '
            .. 'rm /tmp/maim_clipboard'
        awful.spawn.easy_async_with_shell(cmd, function(_, _, _, exit_code)
            if exit_code == 0 then
                capture_notif = notifications.notify_dwim({
                    title = 'Screenshot',
                    message = 'Copied selection to clipboard',
                    icon = icon,
                    app_name = screenshot_notification_app_name,
                }, capture_notif)
            else
                naughty.destroy(capture_notif)
            end
        end)
    end
end

return apps
