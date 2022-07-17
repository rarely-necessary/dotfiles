" Define highlight groups
let tabwinnum_style='guifg=' . g:terminal_color_14 . ' guibg=' . g:terminal_color_15
exec "highlight TabWinNum " . tabwinnum_style

let tabwinnumsel_style='guifg=' . g:terminal_color_14 . ' guibg=' . g:terminal_color_background
exec "highlight TabWinNumSel " . tabwinnumsel_style

let tabmodified_style='guifg=' . g:terminal_color_10 . ' guibg=' . g:terminal_color_15 . ' gui=italic'
exec "highlight TabModified " . tabmodified_style

highlight link TabModifiedSel Italic

" Initialize the lua file
lua require('tabline').setup()
