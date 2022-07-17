local groups = {
    terminal = '',
    image_viewer = '',
    firefox = '',
    chrome = '',
    editor = '',
    fonts = 'ﯔ',
    calc = '',
    pdf = '',
    games = '',
    messaging = '',
    music_player = 'ﱘ',
    file_browser = '',
}

local icons = {
    ['screenshot'] = '',
    by_class = {
        ['_'] = '',

        -- Terminals
        kitty = groups.terminal,
        Alacritty = groups.terminal,
        Termite = groups.terminal,
        URxvt = groups.terminal,
        st = groups.terminal,
        ['st-256color'] = groups.terminal,

        -- Image viewers
        feh = groups.image_viewer,
        Sxiv = groups.image_viewer,
        imv = groups.image_viewer,

        -- General
        Lxappearance = '漣',
        Oomox = '',
        ['Nm-connection-editor'] = '',
        ['TelegramDesktop'] = '切',
        Firefox = groups.firefox,
        firefox = groups.firefox,
        Nightly = groups.firefox,
        Chromium = groups.chrome,
        ['Chromium-browser'] = groups.chrome,
        Slack = '',
        Steam = '戮',
        Lutris = groups.game,
        editor = groups.editor,
        L3afpad = '',
        Emacs = '',
        ['Font-manager'] = groups.fonts,
        email = '',
        KeePassXC = '',
        Gucharmap = groups.fonts,
        htop = 'ﳊ',
        Screenruler = '塞',
        Galculator = groups.calc,
        ['Qalculate-gtk'] = groups.calc,
        Zathura = groups.pdf,
        ['Qemu-system-x86_64'] = groups.game,
        Virtualbox = '',
        Wine = '',
        ['markdown_input'] = '',
        scratchpad = groups.editor,
        weechat = groups.messaging,
        Hexchat = groups.messaging,
        discord = "<span font='Fira Code Nerd Font'>ﭮ</span>",
        ['6cord'] = "<span font='Fira Code Nerd Font'>ﭮ</span>",
        ['libreoffice-writer'] = '',
        ['libreoffice-calc'] = '',
        ['libreoffice-impress'] = '',
        Xournalpp = '淋',
        zoom = '',
        Zotero = 'ﴬ',

        -- Audio and Media
        Audacious = groups.music_player,
        cava = '',
        Cadence = '',
        Carla2 = '﴾',
        Catia = '﴾',
        Claudia = '﴾',
        Guitarix = '',
        mpv = '奈',
        MuseScore3 = '',
        music = groups.music_player,
        Pavucontrol = '墳',
        Pulseeffects = '墳',
        Spotify = "阮",
        vlc = '嗢',

        -- File managers
        Thunar = groups.file_browser,
        Nemo = groups.file_browser,
        files = groups.file_browser,
        Xarchiver = '遲',

        -- Image Editors
        Gimp = '',
        Inkscape = 'ﰟ',
        Gpick = '',
    },
}

return icons
