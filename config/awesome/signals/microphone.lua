local awful = require('awful')

local mic_volume_old = -1
local mic_muted_old = -1
local function emit_mic_info()
    -- Get volume info of the currently active sink
    -- The currently active sink has a star `*` in front of its index
    -- In the output of `pacmd list-sinks`, lines +7 and +11 after "* index:"
    -- contain the volume level and muted state respectively
    -- This is why we are using `awk` to print them.
    awful.spawn.easy_async_with_shell('pamixer --default-source --get-volume --get-mute', function(stdout)
        local volume = stdout:match('(%d+)')
        local muted = stdout:match('true')
        local muted_int = muted and 1 or 0
        local volume_int = tonumber(volume)
        -- Only send signal if there was a change
        -- We need this since we use `pactl subscribe` to detect
        -- volume events. These are not only triggered when the
        -- user adjusts the volume through a keybind, but also
        -- through `pavucontrol` or even without user intervention,
        -- when a media file starts playing.
        if volume_int ~= mic_volume_old or muted_int ~= mic_muted_old then
            awesome.emit_signal('sig::microphone', volume_int, muted)
            mic_volume_old = volume_int
            mic_muted_old = muted_int
        end
    end)
end

-- Run once to initialize widgets
emit_mic_info()

-- Sleeps until pactl detects an event (volume up/down/toggle mute)
local mic_script = [[
    bash -c "
    pactl subscribe 2> /dev/null | grep --line-buffered \"Event 'change' on source #\"
    "]]

-- Kill old pactl subscribe processes
awful.spawn.easy_async_with_shell(
    'ps x | grep "pactl subscribe" | grep -v grep | awk \'{print $1}\' | xargs kill',
    function()
        -- Run emit_volume_info() with each line printed
        awful.spawn.with_line_callback(mic_script, {
            stdout = function(_)
                emit_mic_info()
            end,
        })
    end
)
