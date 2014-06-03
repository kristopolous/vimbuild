" local syntax file - set colors on a per-machine basis:
" vim: tw=0 ts=4 sw=4
" Vim color file
" Maintainer:	Ron Aaron <ron@ronware.org>
" Last Change:	2006 Dec 10
" Forked by kristopolous

set background=dark
if version > 580
  hi clear
  if exists("syntax_on")
    syntax reset
  endif
endif

set t_Co=256
let g:colors_name = "kristopolous"

highlight DiffAdd       term=reverse    cterm=none              ctermfg=white       ctermbg=darkmagenta
highlight DiffChange    term=reverse                            ctermfg=white       ctermbg=darkgrey 
highlight DiffText      term=underline  cterm=bold,underline    ctermfg=white       ctermbg=darkgrey 
highlight DiffDelete    term=reverse    cterm=bold              ctermfg=darkmagenta ctermbg=none

hi SpecialKey	  term=bold        	    cterm=bold      		ctermfg=darkred  
hi NonText		  term=bold        	    cterm=bold      		ctermfg=240
hi Directory	  term=bold        	    cterm=none      		ctermfg=253
hi TreeOpenable	  term=bold        	    cterm=none      		ctermfg=253
hi Search		  term=reverse                       		    ctermfg=white       ctermbg=red      
hi MoreMsg		  term=bold        	    cterm=bold      		ctermfg=darkgreen	
hi ModeMsg		  term=bold        	    cterm=bold  
hi LineNr		  term=underline   	    cterm=bold      		ctermfg=darkgrey	
hi Question		  term=standout    	    cterm=bold      		ctermfg=darkgreen	
hi StatusLine	  term=reverse     	    cterm=undercurl 		ctermfg=252        ctermbg=236
hi StatusLineNC   term=bold,reverse	    cterm=underline 		ctermfg=244    ctermbg=none
hi VertSplit	  term=underline        cterm=none     		    ctermfg=248    ctermbg=none
hi Title		  term=bold        	    cterm=bold      		ctermfg=004
hi Visual		  term=reverse	   	    cterm=none              ctermfg=255   ctermbg=018
hi WarningMsg	  term=standout    	    cterm=bold      		ctermfg=darkred 
hi Comment		  term=bold        	    cterm=none      		ctermfg=75
hi Constant		  term=underline   	    cterm=none      		ctermfg=151
hi Special		  term=bold        	    cterm=none      		ctermfg=114
hi Scope		  term=underline                    		    ctermfg=88
hi Identifier	  term=underline                    		    ctermfg=007
hi Statement	  term=bold         	cterm=none     		    ctermfg=225
hi PreProc		  term=underline        cterm=none     		    ctermfg=255
hi Type			  term=underline    	cterm=none     		    ctermfg=195
hi Term           term=none             cterm=bold              ctermfg=216
hi ErrorMsg		  term=standout    	    cterm=bold      		ctermfg=red         ctermbg=none
hi Error		  term=reverse	                    		    ctermfg=darkcyan    ctermbg=black  
hi Todo			  term=standout                     		    ctermfg=120	    ctermbg=none
hi Folded                               cterm=none              ctermfg=242        ctermbg=none
hi FoldColumn                           cterm=none              ctermfg=grey        ctermbg=none
hi Paren	                                                    ctermfg=brown	
hi CursorLine	  term=bold         	cterm=bold
hi CursorColumn	  term=bold         	cterm=bold
hi MatchParen	  term=reverse                      		    ctermfg=blue 
hi TabLine		  term=bold,reverse 	cterm=underline,bold	ctermfg=32   ctermbg=none
hi TabLineFill	  term=bold,reverse 	cterm=underline 		ctermfg=24   ctermbg=none
hi TabLineSel	  term=reverse	                    		    ctermfg=white       ctermbg=24

hi Cursor		  guifg=bg	guibg=Green

hi link IncSearch		Visual
hi link String			Constant
hi link Character		Constant
hi link Number			Constant
hi link Boolean			Constant
hi link Float			Number
hi link Function		Identifier
hi link Conditional		Statement
hi link Repeat			Statement
hi link Label			Statement
hi link Operator		Statement
hi link Keyword			Statement
hi link Exception		Statement
hi link Include			PreProc
hi link Define			PreProc
hi link Macro			PreProc
hi link PreCondit		PreProc
hi link StorageClass	Type
hi link Structure		Type
hi link Typedef			Type
hi link Tag				Special
hi link SpecialChar		Special
hi link Delimiter		Special
hi link SpecialComment	Special
hi link Debug			Special
