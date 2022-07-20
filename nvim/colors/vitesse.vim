" Colorscheme generated by https://github.com/arcticlimer/djanho
highlight clear

function s:highlight(group, bg, fg, style)
  let gui = a:style == '' ? '' : 'gui=' . a:style
  let fg = a:fg == '' ? '' : 'guifg=' . a:fg
  let bg = a:bg == '' ? '' : 'guibg=' . a:bg
  exec 'hi ' . a:group . ' ' . bg . ' ' . fg  . ' ' . gui
endfunction

let s:Color11 = '#222'
let s:Color8 = '#db889a'
let s:Color14 = '#27312d'
let s:Color15 = '#342929'
let s:Color6 = '#b8a965'
let s:Color4 = '#cb7676'
let s:Color16 = '#323232'
let s:Color3 = '#4d9375'
let s:Color0 = '#697769'
let s:Color9 = '#4C9A91'
let s:Color17 = '#454543'
let s:Color2 = '#80a665'
let s:Color12 = '#bfbaaa'
let s:Color5 = '#c98a7d'
let s:Color7 = '#bf9763'
let s:Color10 = '#d1d5da'
let s:Color13 = '#cecabe'
let s:Color1 = '#c99076'
let s:Color18 = '#959da5'

call s:highlight('Comment', '', s:Color0, '')
call s:highlight('Constant', '', s:Color1, '')
call s:highlight('Function', '', s:Color2, '')
call s:highlight('Keyword', '', s:Color3, '')
call s:highlight('Type', '', s:Color4, '')
call s:highlight('String', '', s:Color5, '')
call s:highlight('TSField', '', s:Color6, '')
call s:highlight('Identifier', '', s:Color7, '')
call s:highlight('TSNamespace', '', s:Color8, '')
call s:highlight('Operator', '', s:Color4, '')
call s:highlight('Number', '', s:Color9, '')
call s:highlight('Number', '', s:Color9, '')
call s:highlight('MyTag', '', s:Color10, '')
call s:highlight('MyTag', '', s:Color10, '')
call s:highlight('MyTag', '', s:Color10, '')
call s:highlight('MyTag', '', s:Color10, '')
call s:highlight('StatusLine', s:Color12, s:Color11, '')
call s:highlight('WildMenu', s:Color11, s:Color13, '')
call s:highlight('Pmenu', s:Color11, s:Color13, '')
call s:highlight('PmenuSel', s:Color13, s:Color11, '')
call s:highlight('PmenuThumb', s:Color11, s:Color13, '')
call s:highlight('DiffAdd', s:Color14, '', '')
call s:highlight('DiffDelete', s:Color15, '', '')
call s:highlight('Normal', s:Color11, s:Color13, '')
call s:highlight('Visual', s:Color16, '', '')
call s:highlight('CursorLine', s:Color16, '', '')
call s:highlight('ColorColumn', s:Color16, '', '')
call s:highlight('SignColumn', s:Color11, '', '')
call s:highlight('LineNr', '', s:Color17, '')
call s:highlight('TabLine', s:Color11, s:Color18, '')
call s:highlight('TabLineSel', s:Color13, s:Color11, '')
call s:highlight('TabLineFill', s:Color11, s:Color18, '')
call s:highlight('TSPunctDelimiter', '', s:Color13, '')

highlight! link TSField Constant
highlight! link TSParameter Constant
highlight! link TSConditional Conditional
highlight! link Conditional Operator
highlight! link TSNumber Number
highlight! link Whitespace Comment
highlight! link Macro Function
highlight! link TSFloat Number
highlight! link TSPunctSpecial TSPunctDelimiter
highlight! link Operator Keyword
highlight! link TSRepeat Repeat
highlight! link Folded Comment
highlight! link TSFuncMacro Macro
highlight! link TSOperator Operator
highlight! link TSString String
highlight! link TSFunction Function
highlight! link TSTag MyTag
highlight! link TSParameterReference TSParameter
highlight! link Repeat Conditional
highlight! link TelescopeNormal Normal
highlight! link TSComment Comment
highlight! link TSTagDelimiter Type
highlight! link TSConstant Constant
highlight! link TSPunctBracket MyTag
highlight! link NonText Comment
highlight! link TSType Type
highlight! link TSConstBuiltin TSVariableBuiltin
highlight! link CursorLineNr Identifier
highlight! link TSProperty TSField
highlight! link TSLabel Type
highlight! link TSKeyword Keyword
highlight! link TSNamespace TSType