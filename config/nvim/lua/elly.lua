local hilda = {}

local function value_or_none(str)
    if str == nil or str == '' then
        return 'NONE'
    end
    return str
end

local function hi (group_name, spec)
    local next = next -- Apparently more efficient, since it won't have to index global values, just local ones

    local translator = { 'foreground', 'background', 'style', 'special' }
    local definition = {}

    for key, val in pairs(translator) do
        if val ~= 'style' then
            definition[val] = value_or_none(spec[key])
        end
    end

    if type(spec[3]) == 'table' then
        for _,key in pairs(spec[3]) do
            definition[key] = true
        end
    end
    if type(spec[3]) == 'string' and #spec[3] > 0 then
        definition[spec[3]] = true
    end

    if next(definition) ~= nil then
        vim.api.nvim_set_hl(0, group_name, definition)
    end
end

local p = {
    c00       = '#171717',
    c01       = '#8D7856',
    c02       = '#5e664d',
    c03       = '#9B9257',
    c04       = '#63768A',
    c05       = '#738C9C',
    c06       = '#c9913a',
    c07       = '#f6e3c9',
    c08       = '#868b8d',
    bk00      = '#323232',
    bk01      = '#1e1e1e',
    bk02      = '#040404',
    bk03      = '#2d2d2d',
    comment   = '#5A5A5A',
    error     = '#b30003',
    warning   = '#b7ae66',
    selection = '#272727',
    diffg     = '#012800',
    diffr     = '#340001',
    cdiffg    = '#037500',
    cdiffy    = '#817E00',
    cdiffr    = '#810002',
    none      = 'NONE',
}

local function set_terminal_colors()
    local c = {
        ['0'] = p.c00,
        ['1'] = p.c01,
        ['2'] = p.c02,
        ['3'] = p.c03,
        ['4'] = p.c04,
        ['5'] = p.c05,
        ['6'] = p.c06,
        ['7'] = p.c07,
        ['8'] = p.c08,
        ['9'] = p.bk00,
        ['10'] = p.bk01,
        ['11'] = p.bk02,
        ['12'] = p.bk03,
        ['13'] = p.comment,
        ['14'] = p.error,
        ['15'] = p.selection
    }
    for i, color in pairs(c) do
        vim.g['terminal_color_' .. i] = color
    end
    vim.g.terminal_color_background = p.c00
    vim.g.terminal_color_foreground = p.c07
end

local function generate_colors()
    -- { fg, bg, style, sp }
    local groups = {
        --- Base ---
        -- Editor
        ColorColumn     = { p.none,     p.bk01 },
        Conceal         = { p.comment,  p.none },
        CursorColumn    = { p.none,     p.bk01 },
        CursorIM        = {},
        CursorLine      = { p.none,     p.bk01 },
        CursorLineNr    = { p.c03,      p.none },
        DiffAdd         = { p.none,     p.diffg },
        DiffChange      = { p.none,     p.diffg },
        DiffDelete      = { p.diffr,    p.diffr },
        DiffText        = { p.none,     p.diffg },
        Directory       = { p.bk00,     p.none },
        EndOfBuffer     = { p.c00,      p.none },
        Error           = { p.c07,      p.error },
        ErrorMsg        = { p.error,    p.none },
        FloatBorder     = {},
        FoldColumn      = { p.none,     p.bk02 },
        Folded          = { p.bk00,     p.bk02 },
        healthError     = { p.none,     p.error },
        healthSuccess   = { p.none,     p.c01 },
        healthWarning   = { p.warning,    p.none },
        IncSearch       = { p.c00,      p.c01 },
        LineNr          = { p.bk03,     p.none },
        MatchParen      = { p.c07,      p.c00 },
        ModeMsg         = { p.c02,      p.none },
        MoreMsg         = {},
        NonText         = { p.bk03,     p.none },
        Normal          = { p.c07,      p.none },
        NormalFloat     = { p.c07,      p.bk01 },
        Pmenu           = { p.c07,      p.selection },
        PmenuSel        = { p.c07,      p.selection, 'reverse' },
        PmenuSbar       = { p.none,     p.selection },
        PmenuThumb      = { p.none,     p.bk00 },
        Question        = { p.c02,      p.none },
        QuickFixLine    = {},
        qfLineNr        = {},
        Search          = { p.c00,      p.c03 },
        SignColumn      = { p.none,     p.c00 },
        SpecialKey      = {},
        SpellBad        = { p.error,    p.none },
        SpellCap        = { p.c01,      p.none },
        SpellLocal      = { p.c01,      p.none },
        SpellRare       = { p.c06,      p.none },
        StatusLine      = { p.bk01,     p.bk01 },
        StatusLineNC    = { p.bk01,     p.bk01 },
        StatusLineTerm  = { p.c00,      p.c00 },
        StatusLineTermNC= { p.c00,      p.c00 },
        TabLine         = { p.c08,      p.bk03 },
        TabLineFill     = { p.c00,      p.c00 },
        TabLineSel      = { p.c00,      p.c03 },
        ToolbarButton   = {},
        ToolbarLine     = {},
        Title           = { p.c04,      p.none },
        VertSplit       = { p.bk01,  p.bk01 },
        Visual          = { p.none,     p.selection },
        VisualNOS       = {},
        Warnings        = {},
        WarningMsg      = { p.warning,    p.none },
        WildMenu        = { p.c00,      p.c01 },

        NormalMode      = {},
        InsertMode      = {},
        ReplaceMode     = {},
        VisualMode      = {},
        CommandMode     = {},

        -- Common
        Boolean         = { p.c03,      p.none },
        Character       = {},
        Conditional     = { p.c01,      p.none },
        Constant        = { p.c03,      p.none },
        Comment         = { p.comment,  p.none },
        Define          = {},
        Delimiter       = {},
        Exception       = {},
        Float           = { p.c03,      p.none },
        Function        = { p.c01,      p.none },
        helpExample     = {},
        Identifier      = { p.c01,      p.none },
        Keyword         = { p.c05,      p.none },
        Include         = { p.c05,      p.none },
        Label           = {},
        Number          = { p.c03,      p.none },
        Operator        = { p.c07,      p.none },
        PreProc         = { p.c03,      p.none },
        Repeat          = {},
        Special         = { p.c05,      p.none },
        SpecialChar     = {},
        Statement       = {},
        StorageClass    = {},
        String          = { p.c02,      p.none },
        Structure       = { p.c03,      p.none },
        Tag             = {},
        Todo            = { p.c01,      p.none },
        Type            = { p.c03,      p.none },
        Typedef         = {},

        -- HTML
        -- htmlBold                = { fg = colors.wood, style = 'bold' },
        -- htmlItalic              = { fg = colors.shirt, style = 'italic' },
        -- htmlEndTag              = { fg = colors.paper },
        -- htmlTag                 = { fg = colors.paper },
        -- htmlH1                  = { style = 'bold' },
        -- htmlH2                  = { style = 'bold' },
        -- htmlH3                  = { style = 'bold' },
        -- htmlH4                  = { style = 'bold' },
        -- htmlH5                  = { style = 'bold' },
        -- htmlArg                 = {},
        -- htmlstyle               = {},
        -- htmlLink                = {},
        -- htmlSpecialChar         = {},
        -- htmlSpecialTagName      = {},
        -- htmlTagN                = {},
        -- htmlTagName             = {},
        -- htmlTitle               = {},

        -- Markdown
        -- markdownCode                    = { fg = colors.scarf },
        -- markdownError                   = { fg = colors.paper, bg = colors.outline },
        -- markdownCodeBlock               = { fg = colors.scarf },
        -- markdownHeadingDelimiter        = { fg = colors.david },
        -- markdownH1                      = { style = 'bold' },
        -- markdownH2                      = { style = 'bold' },
        -- markdownH3                      = { style = 'bold' },
        -- markdownH4                      = { style = 'bold' },
        -- markdownH5                      = { style = 'bold' },
        -- markdownH6                      = { style = 'bold' },
        -- markdownBold                    = { style = 'bold' },
        -- markdownHeadingRule             = {},
        -- markdownId                      = {},
        -- markdownIdDeclaration           = {},
        -- markdownIdDelimiter             = {},
        -- markdownstyle                   = {},
        -- markdownLinkDelimiter           = {},
        -- markdownLinkText                = {},
        -- markdownListMarker              = {},
        -- markdownOrderedListMarker       = {},
        -- markdownRule                    = {},
        -- markdownUrl                     = {},
        -- markdownBlockquote              = {},
        -- markdownCodeDelimiter           = {},

        -- Dashboard
        DashboardShortCut       = {},
        DashboardHeader         = {},
        DashboardCenter         = {},
        DashboardFooter         = {},

        -- Telescope
        TelescopeBorder         = { p.comment, p.c00 },
        TelescopePreviewBorder  = { p.comment, p.c00 },
        TelescopeTitle          = { p.c07, p.none },

        -- TreeSitter
        TSAnnotation            = {},
        TSAttribute             = {},
        TSBoolean               = { p.c03,      p.none },
        TSCharacter             = {},
        TSComment               = { p.comment,  p.none },
        TSConditional           = { p.c01,      p.none },
        TSConstant              = { p.c03,      p.none },
        TSConstMacro            = {},
        TSConstructor           = { p.c06 },
        TSEmphasis              = { p.none,     p.none, 'bold' },
        TSError                 = { p.c07,      p.none, 'undercurl', p.error },
        TSException             = {},
        TSField                 = {},
        TSFloat                 = { p.c03,      p.none },
        TSFuncBuiltin           = { p.c01,      p.none },
        TSFuncMacro             = { p.c01,      p.none },
        TSFunction              = { p.c01,      p.none },
        TSInclude               = { p.c05,      p.none },
        TSKeyword               = { p.c05,      p.none },
        TSKeywordFunction       = { p.c05,      p.none },
        TSLabel                 = {},
        TSLiteral               = {},
        TSMethod                = { p.c01,      p.none },
        TSNamespace             = {},
        TSNumber                = { p.none,     p.none },
        TSOperator              = { p.c07,      p.none },
        TSParameter             = {},
        TSParameterReference    = {},
        TSProperty              = {},
        TSPunctBracket          = { p.c08,      p.none },
        TSPunctDelimiter        = { p.c08,      p.none },
        TSPunctSpecial          = { p.c08,      p.none },
        TSRepeat                = {},
        TSStrike                = {},
        TSString                = { p.c02,      p.none },
        TSStringEscape          = { p.c02,      p.none},
        TSStringRegex           = { p.c02,      p.none },
        TSSymbol                = {},
        TSTag                   = { p.c06 },
        TSTagAttribute          = {},
        TSTagDelimiter          = {},
        TSText                  = { p.c07,      p.none },
        TSTextReference         = {},
        TSTitle                 = { p.c04,      p.none },
        TSType                  = { p.c03,      p.none },
        TSTypeBuiltin           = {},
        TSUnderline             = { p.none,     p.none, 'underline' },
        TSURI                   = { p.none,     p.none, 'undercurl' },
        TSVariable              = {},
        TSVariableBuiltin       = {},

        -- LSP
        LspDiagnosticsDefaultError              = { p.none,  p.none, 'undercurl', p.error },
        LspDiagnosticsSignError                 = { p.none,  p.error },
        LspDiagnosticsFloatingError             = { p.none,  p.error },
        LspDiagnosticsVirtualTextError          = { p.error, p.none },
        LspDiagnosticsUnderlineError            = { p.none,  p.none, 'undercurl', p.error },

        LspDiagnosticsDefaultWarning            = { p.none,  p.none, 'undercurl', p.error },
        LspDiagnosticsSignWarning               = { p.none,  p.warning },
        LspDiagnosticsFloatingWarning           = { p.none,  p.warning },
        LspDiagnosticsVirtualTextWarning        = { p.warning, p.none },
        LspDiagnosticsUnderlineWarning          = { p.none,  p.none, 'undercurl', p.warning },

        LspDiagnosticsDefaultInformation        = { p.none, p.none, 'undercurl', p.c06 },
        LspDiagnosticsSignInformation           = { p.none, p.c06 },
        LspDiagnosticsFloatingInformation       = { p.none, p.c06 },
        LspDiagnosticsVirtualTextInformation    = { p.c06,  p.none },
        LspDiagnosticsUnderlineInformation      = { p.none, p.none, 'undercurl', p.c06 },

        LspDiagnosticsDefaultHint               = { p.none, p.none, 'undercurl', p.c06 },
        LspDiagnosticsSignHint                  = { p.none, p.c06 },
        LspDiagnosticsFloatingHint              = { p.none, p.c06 },
        LspDiagnosticsVirtualTextHint           = { p.c06,  p.none },
        LspDiagnosticsUnderlineHint             = { p.none, p.none, 'undercurl', p.c06 },

        --- Plugin/Custom ---
        -- Tabline
        TabWinNum       = { p.c04,  p.bk03 },
        TabWinNumSel    = { p.bk00,  p.c03 },
        TabModified     = { p.c08,  p.bk03, 'bold' },
        TabModifiedSel  = { p.c00, p.c03, 'bold' },

        -- nvim-tree.lua
        NvimTreeNormal           = { p.c07, p.bk01 },
        NvimTreeEndOfBuffer      = { p.bk01, p.bk01 },
        NvimTreeWinSeperator     = { p.bk01, p.bk01 },
        NvimTreeStatusLine       = { p.bk01, p.bk01 },
        NvimTreeStatusLineNC     = { p.bk01, p.bk01 },
        NvimTreeFolderName       = { p.comment, p.none },
        NvimTreeOpenedFolderName = { p.c03, p.none },
        NvimTreeEmptyFolderName  = { p.c01, p.none },
        NvimTreeRootFolder       = { p.bk00, p.none },

        -- Indent Blankline
        IndentBlanklineChar         = { p.bk00,  p.none, 'nocombine' },
        IndentBlanklineContextChar  = { p.bk03,     p.none, 'nocombine' },
    }

    for group, parameters in pairs(groups) do
      hi(group, parameters)
    end
end

function hilda.colorscheme()
    vim.o.background = 'dark'
    vim.cmd 'hi clear'
    if vim.fn.exists('syntax_on') then
        vim.cmd 'syntax reset'
    end

    vim.g.colors_name = 'elly-lua'

    set_terminal_colors()
    generate_colors()
end

return hilda
