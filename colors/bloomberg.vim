" Vim colorscheme template file
" Author: Sammy Al Hashemi <salhashemi2@bloomberg.net>
" Maintainer: Sammy Al Hashemi <salhashemi2@bloomberg.net>
" Notes: This is very much WIP

set background=dark

highlight clear
if exists("syntax_on")
        syntax reset
endif

"----------------------------------------------------------------
" General settings                                              |
"----------------------------------------------------------------
"----------------------------------------------------------------
" Syntax group   | Foreground    | Background    | Style        |
"----------------------------------------------------------------

" --------------------------------
" Editor settings
" --------------------------------
hi Normal          ctermfg=12   ctermbg=0    cterm=none guifg=#f49f31
hi Cursor          ctermfg=1    ctermbg=0    cterm=none guifg=#4dc7f9
hi iCursor          ctermfg=1    ctermbg=0    cterm=none guifg=#4dc7f9
hi CursorLine      ctermfg=none    ctermbg=none    cterm=underline 
hi LineNr          ctermfg=none    ctermbg=none    cterm=none guifg=#d7d7d7
hi CursorLineNR    ctermfg=none    ctermbg=none    cterm=none

" -----------------
" - Number column -
" -----------------
hi CursorColumn    ctermfg=Red    ctermbg=none    cterm=none
hi FoldColumn      ctermfg=none    ctermbg=none    cterm=none
hi SignColumn      ctermfg=none    ctermbg=none    cterm=none
hi Folded          ctermfg=none    ctermbg=none    cterm=none

" -------------------------
" - Window/Tab delimiters - 
" -------------------------
hi VertSplit       ctermfg=none    ctermbg=none    cterm=none
hi ColorColumn     ctermfg=none    ctermbg=none    cterm=none guibg=#b36200
hi TabLine         ctermfg=none    ctermbg=none    cterm=none
hi TabLineFill     ctermfg=none    ctermbg=none    cterm=none
hi TabLineSel      ctermfg=none    ctermbg=none    cterm=none

" -------------------------------
" - File Navigation / Searching -
" -------------------------------
hi Directory       ctermfg=none    ctermbg=none    cterm=none
hi Search          ctermfg=none    ctermbg=none    cterm=none
hi IncSearch       ctermfg=none    ctermbg=none    cterm=none

" -----------------
" - Prompt/Status -
" -----------------
hi MyStatusLineText guifg=#000000
hi StatusLine      ctermfg=0    ctermbg=0    cterm=none
hi StatusLineNC    ctermfg=none    ctermbg=none    cterm=none
hi WildMenu        ctermfg=none    ctermbg=none    cterm=none
hi Question        ctermfg=none    ctermbg=none    cterm=none
hi Title           ctermfg=none    ctermbg=none    cterm=none
hi ModeMsg         ctermfg=none    ctermbg=none    cterm=none
hi MoreMsg         ctermfg=none    ctermbg=none    cterm=none

" --------------
" - Visual aid -
" --------------
hi MatchParen      ctermfg=none    ctermbg=none    cterm=none
hi Visual          ctermfg=none    ctermbg=none    cterm=none
hi VisualNOS       ctermfg=none    ctermbg=none    cterm=none
hi NonText         ctermfg=none    ctermbg=none    cterm=none guifg=#838383

hi Todo            ctermfg=none    ctermbg=none    cterm=none
hi Underlined      ctermfg=none    ctermbg=none    cterm=none
hi Error           ctermfg=none    ctermbg=none    cterm=none guifg=#60C487
hi ErrorMsg        ctermfg=none    ctermbg=none    cterm=none
hi WarningMsg      ctermfg=none    ctermbg=none    cterm=none
hi Ignore          ctermfg=none    ctermbg=none    cterm=none
hi SpecialKey      ctermfg=none    ctermbg=none    cterm=none

" --------------------------------
" Variable types
" --------------------------------
hi Constant        ctermfg=12    ctermbg=0    cterm=underline guifg=#b5cea8
hi String          ctermfg=none    ctermbg=none    cterm=none guifg=#D16969 
hi StringDelimiter ctermfg=none    ctermbg=none    cterm=none guifg=#D16969
hi Character       ctermfg=none    ctermbg=none    cterm=none guifg=#569cd6
hi Number          ctermfg=none    ctermbg=none    cterm=none guifg=#b5cea8
hi Boolean         ctermfg=none    ctermbg=none    cterm=none guifg=#acacae
hi Float           ctermfg=none    ctermbg=none    cterm=none guifg=#acacae

hi Identifier      ctermfg=none    ctermbg=none    cterm=none guifg=#f49f31
hi Function        ctermfg=none    ctermbg=none    cterm=none guifg=#b180d7

" --------------------------------
" Language constructs
" --------------------------------
hi Statement       ctermfg=none    ctermbg=none    cterm=none guifg=#f49f31
hi Conditional     ctermfg=none    ctermbg=none    cterm=none guifg=#4dc7f9
hi Repeat          ctermfg=none    ctermbg=none    cterm=none
hi Label           ctermfg=none    ctermbg=none    cterm=none guifg=#75beff
hi Operator        ctermfg=none    ctermbg=none    cterm=none guifg=#acacae
hi Keyword         ctermfg=none    ctermbg=none    cterm=none guifg=#acacae
hi Exception       ctermfg=none    ctermbg=none    cterm=none guifg=#acacae
hi Comment         ctermfg=none    ctermbg=none    cterm=none guifg=#d54135

hi Special         ctermfg=none    ctermbg=none    cterm=none guifg=#f49f31
hi SpecialChar     ctermfg=none    ctermbg=none    cterm=none
hi Tag             ctermfg=none    ctermbg=none    cterm=none guifg=#d7ba7d
hi Delimiter       ctermfg=none    ctermbg=none    cterm=none
hi SpecialComment  ctermfg=none    ctermbg=none    cterm=none
hi Debug           ctermfg=none    ctermbg=none    cterm=none guifg=#acacae

" ----------
" - C like -
" ----------
hi PreProc         ctermfg=none    ctermbg=none    cterm=none
hi Include         ctermfg=none    ctermbg=none    cterm=none guifg=#D16969
hi Define          ctermfg=none    ctermbg=none    cterm=none guifg=#569cd6
hi Macro           ctermfg=none    ctermbg=none    cterm=none guifg=#f49f31
hi PreCondit       ctermfg=none    ctermbg=none    cterm=none

hi Type            ctermfg=none    ctermbg=none    cterm=none guifg=#60C487
hi StorageClass    ctermfg=none    ctermbg=none    cterm=none guifg=#f49f31
hi Structure       ctermfg=none    ctermbg=none    cterm=none guifg=#acacae
hi Typedef         ctermfg=none    ctermbg=none    cterm=none guifg=#f49f31

" --------------------------------
" Diff
" --------------------------------
hi DiffAdd         ctermfg=none    ctermbg=none    cterm=none
hi DiffChange      ctermfg=none    ctermbg=none    cterm=none
hi DiffDelete      ctermfg=none    ctermbg=none    cterm=none
hi DiffText        ctermfg=none    ctermbg=none    cterm=none

" --------------------------------
" Completion menu
" --------------------------------
hi Pmenu           ctermfg=none    ctermbg=none    cterm=none guifg=#d7d7d7 guibg=#464646
hi PmenuSel        ctermfg=none    ctermbg=none    cterm=none guifg=#d7d7d7 guibg=none
hi PmenuSbar       ctermfg=none    ctermbg=none    cterm=none
hi PmenuThumb      ctermfg=none    ctermbg=none    cterm=none

" --------------------------------
" Spelling
" --------------------------------
hi SpellBad        ctermfg=none    ctermbg=none    cterm=none
hi SpellCap        ctermfg=none    ctermbg=none    cterm=none
hi SpellLocal      ctermfg=none    ctermbg=none    cterm=none
hi SpellRare       ctermfg=none    ctermbg=none    cterm=none

"--------------------------------------------------------------------
" Specific settings                                                 |
"--------------------------------------------------------------------
