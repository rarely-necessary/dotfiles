set background=dark
hi clear

if exists("syntax_on")
    syntax reset
endif

let colors_name = "hilda"

" GUI color definitions
let outline         = "000000"  " Background                        Outlines
let shirt         = "df5f50"  " Keyword, Conditional, Repeat      Hilda's shirt
let wood         = "bc7f63"  " Tag, Type                         Wood(man)
let scarf         = "ffc78a"  " Function                          Hilda's scarf
let night_grass         = "566389"  " Boolean, Numbers                  Night grass
let frida         = "b7a5cd"  " Search                            Frida's shirt
let david         = "ef724a"  " Status line, Search               David's shirt
let paper         = "fbf0ea"  " Plain text                        Paper
let library_light         = "4d2231"  " Comments                          Secret library light wall
let mom         = "a44155"  " Error message, Error fg, this     Mom's shirt
let crow         = "776261"  " Delimiter                         Crow
let troll         = "ccad99"  " Statement (Useful for LaTeX)      Daytime troll
let night_sky         = "354d75"  " String                            Night sky
let night_grass         = "566389"  " Js regex, Special                 Nighttime grass
let hair         = "56858c"  " Identifier                        Hilda's hair (dark)
let s:gui0F         = "2e1121"  " Visual selection, Separators      Secret library dark wall

" #000000 Outlines
" #56858c Hilda's hair (dark) -- #68a3a9 for light
" #2e1121 Secret library dark wall
" #4d2231 Secret library light wall
" #ef724a David's shirt
" #f9f7f2 Paper
" #ccad99 Daytime troll
" #b7a5cd Frida's shirt
" #a44155 Mom's shirt
" #566389 Night grass
" #bc7f63 Wood(man)
" #354d75 Night sky
" #566389 Night grass
" #ffc78a Hilda's scarf
" #df5f50 Hilda's shirt
" #776261 Crow

" Terminal color definitions
let s:cterm00        = "00"
let s:cterm03        = "08"
let s:cterm05        = "07"
let s:cterm07        = "15"
let s:cterm08        = "01"
let s:cterm0A        = "03"
let s:cterm0B        = "02"
let s:cterm0C        = "06"
let s:cterm0D        = "04"
let s:cterm0E        = "05"

if exists("base16colorspace") && base16colorspace == "256"
  let s:cterm01        = "18"
  let s:cterm02        = "19"
  let s:cterm04        = "20"
  let s:cterm06        = "21"
  let s:cterm09        = "16"
  let s:cterm0F        = "17"
else
  let s:cterm01        = "10"
  let s:cterm02        = "11"
  let s:cterm04        = "12"
  let s:cterm06        = "13"
  let s:cterm09        = "09"
  let s:cterm0F        = "14"
endif

" Neovim terminal colours
if has("nvim")
  let g:terminal_color_0  = "#000000"
  let g:terminal_color_1  = "#df5f50"
  let g:terminal_color_2  = "#bc7f63"
  let g:terminal_color_3  = "#ffc78a"
  let g:terminal_color_4  = "#566389"
  let g:terminal_color_5  = "#b7a5cd"
  let g:terminal_color_6  = "#ef724a"
  let g:terminal_color_7  = "#fbf0ea"
  let g:terminal_color_8  = "#4d2231"
  let g:terminal_color_9  = "#a44155"
  let g:terminal_color_10  = "#776261"
  let g:terminal_color_11  = "#ccad99"
  let g:terminal_color_12  = "#354d75"
  let g:terminal_color_13  = "#566389"
  let g:terminal_color_14  = "#56858c"
  let g:terminal_color_15  = "#2e1121"
  let g:terminal_color_background = g:terminal_color_0
  let g:terminal_color_foreground = g:terminal_color_7
endif

" Highlighting function
" Optional variables are attributes and guisp
function! g:Base16hi(group, guifg, guibg, ctermfg, ctermbg, ...)
  let l:attr = get(a:, 1, "")
  let l:guisp = get(a:, 2, "")

  if a:guifg != ""
    exec "hi " . a:group . " guifg=#" . a:guifg
  endif
  if a:guibg != ""
    exec "hi " . a:group . " guibg=#" . a:guibg
  endif
  if a:ctermfg != ""
    exec "hi " . a:group . " ctermfg=" . a:ctermfg
  endif
  if a:ctermbg != ""
    exec "hi " . a:group . " ctermbg=" . a:ctermbg
  endif
  if l:attr != ""
    exec "hi " . a:group . " gui=" . l:attr . " cterm=" . l:attr
  endif
  if l:guisp != ""
    exec "hi " . a:group . " guisp=#" . l:guisp
  endif
endfunction


fun <sid>hi(group, guifg, guibg, ctermfg, ctermbg, attr, guisp)
  call g:Base16hi(a:group, a:guifg, a:guibg, a:ctermfg, a:ctermbg, a:attr, a:guisp)
endfun

" Vim editor colors
"            Group                      guifg       guibg       ctermfg     ctermbg     gui         guisp
call <sid>hi("Normal",                  paper,    outline,    s:cterm05,  s:cterm00,  "",         "")
call <sid>hi("Bold",                    "",         "",         "",         "",         "bold",     "")
call <sid>hi("Debug",                   mom,    "",         s:cterm08,  "",         "",         "")
call <sid>hi("Directory",               scarf,    "",         s:cterm0D,  "",         "",         "")
call <sid>hi("Error",                   outline,    mom,    s:cterm00,  s:cterm08,  "",         "")
call <sid>hi("ErrorMsg",                mom,    outline,    s:cterm08,  s:cterm00,  "",         "")
call <sid>hi("Exception",               mom,    "",         s:cterm08,  "",         "",         "")
call <sid>hi("FoldColumn",              night_grass,    hair,    s:cterm0C,  s:cterm01,  "",         "")
call <sid>hi("Folded",                  library_light,    outline,    s:cterm03,  s:cterm01,  "",         "")
call <sid>hi("IncSearch",               david,    library_light,    s:cterm01,  s:cterm09,  "none",     "")
call <sid>hi("Italic",                  "",         "",         "",         "",         "italic",   "")
call <sid>hi("Macro",                   mom,    "",         s:cterm08,  "",         "",         "")
call <sid>hi("MatchParen",              "",         s:gui0F,    "",         s:cterm03,  "underline","")
call <sid>hi("ModeMsg",                 night_sky,    "",         s:cterm0B,  "",         "",         "")
call <sid>hi("MoreMsg",                 night_sky,    "",         s:cterm0B,  "",         "",         "")
call <sid>hi("Question",                scarf,    "",         s:cterm0D,  "",         "",         "")
call <sid>hi("Search",                  frida,    library_light,    s:cterm01,  s:cterm0A,  "",         "")
call <sid>hi("Substitute",              hair,    wood,    s:cterm01,  s:cterm0A,  "none",     "")
call <sid>hi("SpecialKey",              library_light,    "",         s:cterm03,  "",         "",         "")
call <sid>hi("TooLong",                 mom,    "",         s:cterm08,  "",         "",         "")
call <sid>hi("Underlined",              mom,    "",         s:cterm08,  "",         "underline","")
call <sid>hi("Visual",                  "",         s:gui0F,    "",         s:cterm02,  "",         "")
call <sid>hi("VisualNOS",               mom,    "",         s:cterm08,  "",         "",         "")
call <sid>hi("WarningMsg",              scarf,    "",         s:cterm08,  "",         "",         "")
call <sid>hi("WildMenu",                mom,    wood,    s:cterm08,  "",         "",         "")
call <sid>hi("Title",                   scarf,    "",         s:cterm0D,  "",         "none",     "")
call <sid>hi("Conceal",                 scarf,    outline,    s:cterm0D,  s:cterm00,  "",         "")
call <sid>hi("Cursor",                  outline,    paper,    s:cterm00,  s:cterm05,  "",         "")
call <sid>hi("NonText",                 library_light,    "",         s:cterm03,  "",         "",         "")
call <sid>hi("LineNr",                  library_light,    outline,    s:cterm03,  s:cterm00,  "",         "")
call <sid>hi("SignColumn",              library_light,    outline,    s:cterm03,  s:cterm00,  "",         "")
call <sid>hi("StatusLine",              david,    s:gui0F,    s:cterm04,  s:cterm02,  "none",     "")
call <sid>hi("StatusLineNC",            library_light,    hair,    s:cterm03,  s:cterm01,  "none",     "")
call <sid>hi("VertSplit",               s:gui0F,    s:gui0F,    s:cterm02,  s:cterm02,  "none",     "")
call <sid>hi("ColorColumn",             "",         hair,    "",         s:cterm01,  "none",     "")
call <sid>hi("CursorColumn",            "",         hair,    "",         s:cterm01,  "none",     "")
call <sid>hi("CursorLine",              "",         s:gui0F,    "",         s:cterm01,  "none",     "")
call <sid>hi("CursorLineNr",            night_grass,    outline,    s:cterm04,  s:cterm03,  "",         "")
call <sid>hi("QuickFixLine",            "",         hair,    "",         s:cterm01,  "none",     "")
call <sid>hi("FloatBorder",             scarf,    "",         s:cterm05,  s:cterm01,  "none",     "")
call <sid>hi("NormalFloat",             paper,    outline,    s:cterm01,  s:cterm05,  "bold",     "")
call <sid>hi("PMenu",                   paper,    mom,    s:cterm05,  s:cterm01,  "none",     "")
call <sid>hi("PMenuSel",                paper,    mom,    s:cterm01,  s:cterm05,  "bold",     "")
call <sid>hi("TabLine",                 crow,    s:gui0F,    s:cterm03,  s:cterm01,  "none",     "")
call <sid>hi("TabLineFill",             s:gui0F,    s:gui0F,    s:cterm03,  s:cterm01,  "",         "")
call <sid>hi("TabLineSel",              shirt,    outline,    s:cterm0B,  s:cterm01,  "bold",     "")

" Standard syntax highlighting
call <sid>hi("Boolean",                 night_grass,    "",         s:cterm09,  "",         "",         "")
call <sid>hi("Character",               mom,    "",         s:cterm08,  "",         "",         "")
call <sid>hi("Comment",                 library_light,    "",         s:cterm03,  "",         "",         "")
call <sid>hi("Conditional",             shirt,    "",         s:cterm0E,  "",         "",         "")
call <sid>hi("Constant",                night_grass,    "",         s:cterm09,  "",         "",         "")
call <sid>hi("Define",                  shirt,    "",         s:cterm0E,  "",         "none",     "")
call <sid>hi("Delimiter",               crow,    "",         s:cterm0F,  "",         "",         "")
call <sid>hi("Float",                   night_grass,    "",         s:cterm09,  "",         "",         "")
call <sid>hi("Function",                scarf,    "",         s:cterm0D,  "",         "",         "")
call <sid>hi("Identifier",              hair,    "",         s:cterm08,  "",         "none",     "")
call <sid>hi("Include",                 scarf,    "",         s:cterm0D,  "",         "",         "")
call <sid>hi("Keyword",                 shirt,    "",         s:cterm0E,  "",         "",         "")
call <sid>hi("Label",                   wood,    "",         s:cterm0A,  "",         "",         "")
call <sid>hi("Number",                  night_grass,    "",         s:cterm09,  "",         "",         "")
call <sid>hi("Operator",                paper,    "",         s:cterm05,  "",         "none",     "")
call <sid>hi("PreProc",                 wood,    "",         s:cterm0A,  "",         "",         "")
call <sid>hi("Repeat",                  shirt,    "",         s:cterm0A,  "",         "",         "")
call <sid>hi("Special",                 night_grass,    "",         s:cterm0C,  "",         "",         "")
call <sid>hi("SpecialChar",             crow,    "",         s:cterm0F,  "",         "",         "")
call <sid>hi("Statement",               troll,    "",         s:cterm08,  "",         "none",     "")
call <sid>hi("StorageClass",            wood,    "",         s:cterm0A,  "",         "",         "")
call <sid>hi("String",                  night_sky,    "",         s:cterm0B,  "",         "",         "")
call <sid>hi("Structure",               shirt,    "",         s:cterm0E,  "",         "",         "")
call <sid>hi("Tag",                     wood,    "",         s:cterm0A,  "",         "",         "")
call <sid>hi("Todo",                    outline,    mom,    s:cterm0A,  s:cterm01,  "",         "")
call <sid>hi("Type",                    wood,    "",         s:cterm0A,  "",         "none",     "")
call <sid>hi("Typedef",                 wood,    "",         s:cterm0A,  "",         "",         "")

" C highlighting
call <sid>hi("cOperator",               night_grass,    "",         s:cterm0C,  "",         "",         "")
call <sid>hi("cPreCondit",              shirt,    "",         s:cterm0E,  "",         "",         "")

" C# highlighting
call <sid>hi("csClass",                 wood,    "",         s:cterm0A,  "",         "",         "")
call <sid>hi("csAttribute",             wood,    "",         s:cterm0A,  "",         "",         "")
call <sid>hi("csModifier",              shirt,    "",         s:cterm0E,  "",         "",         "")
call <sid>hi("csType",                  mom,    "",         s:cterm08,  "",         "",         "")
call <sid>hi("csUnspecifiedStatement",  scarf,    "",         s:cterm0D,  "",         "",         "")
call <sid>hi("csContextualStatement",   shirt,    "",         s:cterm0E,  "",         "",         "")
call <sid>hi("csNewDecleration",        mom,    "",         s:cterm08,  "",         "",         "")

" CSS highlighting
call <sid>hi("cssBraces",               paper,    "",         s:cterm05,  "",         "",         "")
call <sid>hi("cssClassName",            shirt,    "",         s:cterm0E,  "",         "",         "")
call <sid>hi("cssColor",                night_grass,    "",         s:cterm0C,  "",         "",         "")

" Diff highlighting
call <sid>hi("DiffAdd",                 night_sky,    hair,    s:cterm0B,  s:cterm01,  "",         "")
call <sid>hi("DiffChange",              library_light,    hair,    s:cterm03,  s:cterm01,  "",         "")
call <sid>hi("DiffDelete",              mom,    hair,    s:cterm08,  s:cterm01,  "",         "")
call <sid>hi("DiffText",                scarf,    hair,    s:cterm0D,  s:cterm01,  "",         "")
call <sid>hi("DiffAdded",               night_sky,    outline,    s:cterm0B,  s:cterm00,  "",         "")
call <sid>hi("DiffFile",                mom,    outline,    s:cterm08,  s:cterm00,  "",         "")
call <sid>hi("DiffNewFile",             night_sky,    outline,    s:cterm0B,  s:cterm00,  "",         "")
call <sid>hi("DiffLine",                scarf,    outline,    s:cterm0D,  s:cterm00,  "",         "")
call <sid>hi("DiffRemoved",             mom,    outline,    s:cterm08,  s:cterm00,  "",         "")

" Git highlighting
call <sid>hi("gitcommitOverflow",       mom,    "",         s:cterm08,  "",         "",         "")
call <sid>hi("gitcommitSummary",        night_sky,    "",         s:cterm0B,  "",         "",         "")
call <sid>hi("gitcommitComment",        library_light,    "",         s:cterm03,  "",         "",         "")
call <sid>hi("gitcommitUntracked",      library_light,    "",         s:cterm03,  "",         "",         "")
call <sid>hi("gitcommitDiscarded",      library_light,    "",         s:cterm03,  "",         "",         "")
call <sid>hi("gitcommitSelected",       library_light,    "",         s:cterm03,  "",         "",         "")
call <sid>hi("gitcommitHeader",         shirt,    "",         s:cterm0E,  "",         "",         "")
call <sid>hi("gitcommitSelectedType",   scarf,    "",         s:cterm0D,  "",         "",         "")
call <sid>hi("gitcommitUnmergedType",   scarf,    "",         s:cterm0D,  "",         "",         "")
call <sid>hi("gitcommitDiscardedType",  scarf,    "",         s:cterm0D,  "",         "",         "")
call <sid>hi("gitcommitBranch",         night_grass,    "",         s:cterm09,  "",         "bold",     "")
call <sid>hi("gitcommitUntrackedFile",  wood,    "",         s:cterm0A,  "",         "",         "")
call <sid>hi("gitcommitUnmergedFile",   mom,    "",         s:cterm08,  "",         "bold",     "")
call <sid>hi("gitcommitDiscardedFile",  mom,    "",         s:cterm08,  "",         "bold",     "")
call <sid>hi("gitcommitSelectedFile",   night_sky,    "",         s:cterm0B,  "",         "bold",     "")

" GitGutter highlighting
call <sid>hi("GitGutterAdd",            night_sky,    hair,    s:cterm0B,  s:cterm01,  "",         "")
call <sid>hi("GitGutterChange",         scarf,    hair,    s:cterm0D,  s:cterm01,  "",         "")
call <sid>hi("GitGutterDelete",         mom,    hair,    s:cterm08,  s:cterm01,  "",         "")
call <sid>hi("GitGutterChangeDelete",   shirt,    hair,    s:cterm0E,  s:cterm01,  "",         "")

" HTML highlighting
call <sid>hi("htmlBold",                wood,    "",         s:cterm0A,  "",         "bold",     "")
call <sid>hi("htmlItalic",              shirt,    "",         s:cterm0E,  "",         "italic",   "")
call <sid>hi("htmlEndTag",              paper,    "",         s:cterm05,  "",         "",         "")
call <sid>hi("htmlTag",                 paper,    "",         s:cterm05,  "",         "",         "")

" JavaScript highlighting
call <sid>hi("javaScript",              paper,    "",         s:cterm05,  "",         "",         "")
call <sid>hi("javaScriptBraces",        paper,    "",         s:cterm05,  "",         "",         "")
call <sid>hi("javaScriptNumber",        night_grass,    "",         s:cterm09,  "",         "",         "")
" pangloss/vim-javascript               highlighting
call <sid>hi("jsOperator",              scarf,    "",         s:cterm0D,  "",         "",         "")
call <sid>hi("jsStatement",             shirt,    "",         s:cterm0E,  "",         "",         "")
call <sid>hi("jsReturn",                shirt,    "",         s:cterm0E,  "",         "",         "")
call <sid>hi("jsThis",                  mom,    "",         s:cterm08,  "",         "",         "")
call <sid>hi("jsClassDefinition",       wood,    "",         s:cterm0A,  "",         "",         "")
call <sid>hi("jsFunction",              shirt,    "",         s:cterm0E,  "",         "",         "")
call <sid>hi("jsFuncName",              scarf,    "",         s:cterm0D,  "",         "",         "")
call <sid>hi("jsFuncCall",              scarf,    "",         s:cterm0D,  "",         "",         "")
call <sid>hi("jsClassFuncName",         scarf,    "",         s:cterm0D,  "",         "",         "")
call <sid>hi("jsClassMethodType",       shirt,    "",         s:cterm0E,  "",         "",         "")
call <sid>hi("jsRegexpString",          night_grass,    "",         s:cterm0C,  "",         "",         "")
call <sid>hi("jsGlobalObjects",         wood,    "",         s:cterm0A,  "",         "",         "")
call <sid>hi("jsGlobalNodeObjects",     wood,    "",         s:cterm0A,  "",         "",         "")
call <sid>hi("jsExceptions",            wood,    "",         s:cterm0A,  "",         "",         "")
call <sid>hi("jsBuiltins",              wood,    "",         s:cterm0A,  "",         "",         "")

" Mail highlighting
call <sid>hi("mailQuoted1",             wood,    "",         s:cterm0A,  "",         "",         "")
call <sid>hi("mailQuoted2",             night_sky,    "",         s:cterm0B,  "",         "",         "")
call <sid>hi("mailQuoted3",             shirt,    "",         s:cterm0E,  "",         "",         "")
call <sid>hi("mailQuoted4",             night_grass,    "",         s:cterm0C,  "",         "",         "")
call <sid>hi("mailQuoted5",             scarf,    "",         s:cterm0D,  "",         "",         "")
call <sid>hi("mailQuoted6",             wood,    "",         s:cterm0A,  "",         "",         "")
call <sid>hi("mailURL",                 scarf,    "",         s:cterm0D,  "",         "",         "")
call <sid>hi("mailEmail",               scarf,    "",         s:cterm0D,  "",         "",         "")

" Markdown highlighting
call <sid>hi("markdownCode",            night_sky,    "",         s:cterm0B,  "",         "",         "")
call <sid>hi("markdownError",           paper,    outline,    s:cterm05,  s:cterm00,  "",         "")
call <sid>hi("markdownCodeBlock",       night_sky,    "",         s:cterm0B,  "",         "",         "")
call <sid>hi("markdownHeadingDelimiter",scarf,    "",         s:cterm0D,  "",         "",         "")

" NERDTree highlighting
call <sid>hi("NERDTreeDirSlash",        scarf,    "",         s:cterm0D,  "",         "",         "")
call <sid>hi("NERDTreeExecFile",        paper,    "",         s:cterm05,  "",         "",         "")

" PHP highlighting
call <sid>hi("phpMemberSelector",       paper,    "",         s:cterm05,  "",         "",         "")
call <sid>hi("phpComparison",           paper,    "",         s:cterm05,  "",         "",         "")
call <sid>hi("phpParent",               paper,    "",         s:cterm05,  "",         "",         "")
call <sid>hi("phpMethodsVar",           night_grass,    "",         s:cterm0C,  "",         "",         "")

" Python highlighting
call <sid>hi("pythonOperator",          shirt,    "",         s:cterm0E, "",          "",         "")
call <sid>hi("pythonRepeat",            shirt,    "",         s:cterm0E, "",          "",         "")
call <sid>hi("pythonInclude",           shirt,    "",         s:cterm0E, "",          "",         "")
call <sid>hi("pythonStatement",         shirt,    "",         s:cterm0E, "",          "",         "")

" Ruby highlighting
call <sid>hi("rubyAttribute",           scarf,    "",         s:cterm0D, "",          "",         "")
call <sid>hi("rubyConstant",            wood,    "",         s:cterm0A, "",          "",         "")
call <sid>hi("rubyInterpolationDelimiter", crow, "",         s:cterm0F, "",          "",         "")
call <sid>hi("rubyRegexp",              night_grass,    "",         s:cterm0C, "",          "",         "")
call <sid>hi("rubySymbol",              night_sky,    "",         s:cterm0B, "",          "",         "")
call <sid>hi("rubyStringDelimiter",     night_sky,    "",         s:cterm0B, "",          "",         "")

" SASS highlighting
call <sid>hi("sassidChar",              mom,    "",         s:cterm08,  "",         "",         "")
call <sid>hi("sassClassChar",           night_grass,    "",         s:cterm09,  "",         "",         "")
call <sid>hi("sassInclude",             shirt,    "",         s:cterm0E,  "",         "",         "")
call <sid>hi("sassMixing",              shirt,    "",         s:cterm0E,  "",         "",         "")
call <sid>hi("sassMixinName",           scarf,    "",         s:cterm0D,  "",         "",         "")

" Signify highlighting
call <sid>hi("SignifySignAdd",          night_sky,    hair,    s:cterm0B,  s:cterm01,  "",         "")
call <sid>hi("SignifySignChange",       scarf,    hair,    s:cterm0D,  s:cterm01,  "",         "")
call <sid>hi("SignifySignDelete",       mom,    hair,    s:cterm08,  s:cterm01,  "",         "")

" Spelling highlighting
call <sid>hi("SpellBad",                "",        "",          "",         "",         "undercurl", mom)
call <sid>hi("SpellLocal",              "",        "",          "",         "",         "undercurl", night_grass)
call <sid>hi("SpellCap",                "",        "",          "",         "",         "undercurl", scarf)
call <sid>hi("SpellRare",               "",        "",          "",         "",         "undercurl", shirt)

" Startify highlighting
call <sid>hi("StartifyBracket",         library_light,        "",     s:cterm03,  "",         "",         "")
call <sid>hi("StartifyFile",            frida,        "",     s:cterm07,  "",         "",         "")
call <sid>hi("StartifyFooter",          library_light,        "",     s:cterm03,  "",         "",         "")
call <sid>hi("StartifyHeader",          night_sky,        "",     s:cterm0B,  "",         "",         "")
call <sid>hi("StartifyNumber",          night_grass,        "",     s:cterm09,  "",         "",         "")
call <sid>hi("StartifyPath",            library_light,        "",     s:cterm03,  "",         "",         "")
call <sid>hi("StartifySection",         shirt,        "",     s:cterm0E,  "",         "",         "")
call <sid>hi("StartifySelect",          night_grass,        "",     s:cterm0C,  "",         "",         "")
call <sid>hi("StartifySlash",           library_light,        "",     s:cterm03,  "",         "",         "")
call <sid>hi("StartifySpecial",         library_light,        "",     s:cterm03,  "",         "",         "")

" Java highlighting
call <sid>hi("javaOperator",            scarf,        "",     s:cterm0D,  "",         "",         "")

" LSP Highlighting
call <sid>hi("DiagnosticError           ", mom,     "",     s:cterm08,  "",         "",         "")
call <sid>hi("DiagnosticSignError       ", mom,     "",     s:cterm08,  "",         "",         "")
call <sid>hi("DiagnosticFloatingError   ", library_light,     "",     s:cterm08,  "",         "",         "")
call <sid>hi("DiagnosticVirtualTextError", mom,     "",     s:cterm08,  "",         "",         "")
call <sid>hi("DiagnosticWarn            ", scarf,     "",     s:cterm08,  "",         "",         "")
call <sid>hi("DiagnosticSignWarn        ", scarf,     "",     s:cterm08,  "",         "",         "")
call <sid>hi("DiagnosticFloatingWarn    ", paper,     "",     s:cterm08,  "",         "",         "")
call <sid>hi("DiagnosticVirtualTextWarn ", scarf,     "",     s:cterm08,  "",         "",         "")

" Latex highlighting (vimtex)
highlight link texMathEnvArgName    texEnvArgName
highlight link texMathDelim         texMathEnvArgName
highlight link texMathZone          String
highlight link texMathOper          texMathZone
highlight link texMathCmd           texMathEnvArgName

" Remove functions
delf <sid>hi

" Remove color variables
unlet outline hair s:gui0F library_light  david  paper  troll  frida  mom  night_grass wood  night_sky  night_grass  scarf  shirt  crow
unlet s:cterm00 s:cterm01 s:cterm02 s:cterm03 s:cterm04 s:cterm05 s:cterm06 s:cterm07 s:cterm08 s:cterm09 s:cterm0A s:cterm0B s:cterm0C s:cterm0D s:cterm0E s:cterm0F
