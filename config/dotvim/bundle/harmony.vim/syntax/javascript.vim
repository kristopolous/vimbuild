" Language:   JavaScript
" Maintainer: Jussi Kalliokoski <jussi.kalliokoski@gmail.com>
" URL:        https://github.com/jussi-kalliokoski/harmony.vim
" License:    MIT

" Bail if already loaded
if exists('b:current_syntax') && b:current_syntax == 'javascript'
	finish
endif

" Enable dollar signs in identifiers
setlocal isident+=$

" Interpret anything that starts with an uppercase letter as a class.
"let g:javascript_enable_camelcase_classes = 1

" Optional warnings

if exists('g:javascript_warning_all')
	" Warn about trailing semicolons
	let g:javascript_warning_trailing_semicolon = 1
	" Warn about leading semicolons
	let g:javascript_warning_leading_semicolon = 1
	" Warn about trailing spaces
	let g:javascript_warning_trailing_space = 1
	" Warn about leading opening parens, brackets or braces
	let g:javascript_warning_leading_opening_parens = 1
	" Warn about leading commas
	let g:javascript_warning_leading_comma = 1
	" Warn about trailing increments/decrements and leading plus/minus
	let g:javascript_warning_plus_minus = 1
	" Warn about leading dots
	let g:javascript_warning_leading_dot = 1
	" Warn about trailing dots
	let g:javascript_warning_trailing_dot = 1
endif

hi def link javascriptTrailingSemicolonWarning javascriptWarning
hi def link javascriptLeadingSemicolonWarning javascriptWarning
hi def link javascriptTrailingDotWarning javascriptWarning
hi def link javascriptLeadingDotWarning javascriptWarning
hi def link javascriptTrailingSpaceWarning javascriptWarning
hi def link javascriptLeadingParensWarning javascriptWarning
hi def link javascriptLeadingPlusMinusWarning javascriptWarning
hi def link javascriptTrailingDecrementWarning javascriptWarning
hi def link javascriptTrailingIncrementWarning javascriptWarning
hi def link javascriptLeadingCommaWarning javascriptWarning
hi def link javascriptWarning Error

" Operators
syn match javascriptLogical /\%([!=]\?==\|[<>=!]=\|[<>]\)/
syn match javascriptBinary /\%([&|^]\|>>>\|>>\|<<\|\~\)/
syn match javascriptBinary /\%([+\-*\/%]\)/
syn match javascriptAssign /\%([+\-*\/%&|^]\|>>>\|>>\|<<\)\?=/
syn match javascriptUnary /[\?:]/
syn match javascriptDelimiter /[\.;,]/

hi def link javascriptLogical Operator
hi def link javascriptBinary Operator
hi def link javascriptAssign Operator
hi def link javascriptAlgebraic Operator
hi def link javascriptUnary Delimiter
hi def link javascriptDelimiter Delimiter

" Specials
syn match javascriptSpecial "\\\d\d\d\|\\."
syn match javascriptSpecialCharacter "'\\.'"

hi def link javascriptSpecialCharacter javascriptSpecial
hi def link javascriptSpecial Special

" Strings
syn region javascriptStringD start=+"+ skip=+\\\\\|\\"+ end=+"\|$+ contains=javascriptSpecial,@htmlPreproc
syn region javascriptStringS start=+'+ skip=+\\\\\|\\'+ end=+'\|$+ contains=javascriptSpecial,@htmlPreproc

hi def link javascriptStringS String
hi def link javascriptStringD String

" Quasi-literals
syn match javascriptQuasiVariableName "\w\w*" contained
syn match javascriptQuasiVariable "\${\w\w*}" contained contains=javascriptQuasiVariableName
syn region javascriptQuasiLiteral start=+\w\w*`+ skip=+\\\\\|\\`+ end=+'\|$+ contains=javascriptSpecial,@htmlPreproc,javascriptQuasiVariable

hi def link javascriptQuasiVariableName Variable
hi def link javascriptQuasiVariable Delimiter
hi def link javascriptQuasiLiteral String

" Identifiers, classnames, constants

if exists('g:javascript_enable_camelcase_classes')
	syn match javascriptClassName /\<\u\w*\>/
endif
if exists('g:javascript_enable_caps_constants')
	syn match javascriptConstant /\<\u[A-Z0-9_]\+\>/
endif

hi def link javascriptClassName Structure
hi def link javascriptConstant Constant

syn cluster javascriptIdentifier contains=javascriptClassName,javascriptConstant

" Property access, ignore keywords
syn match javascriptDotAccess /\.\@<!\.\s*\I\i*/he=s+1 contains=@javascriptIdentifier
hi def link javascriptDotAccess javascriptDelimiter

" Labels
syn match javascriptLabelDefine /\I\i*\s*\ze::\@!/ contains=@javascriptIdentifier
hi def link javascriptLabelDefine Identifier

" Numbers
syn match javascriptNumber /\i\@<![-+]\?\d\+\.\?\%([eE][+-]\?\d\+\)\?/
syn match javascriptNumber /\<0[xX]\x\+\>/
syn match javascriptNumber /\<0[bB][01]\+\>/
syn match javascriptNumber /\<0[oO][0-7]\+\>/
syn match javascriptFloat /\i\@<![-+]\?\d*\.\@<!\.\d\+\%([eE][+-]\?\d\+\)\?/

hi def link javascriptNumber Number
hi def link javascriptFloat Number

" Regexes
syn region javascriptRegexpString start=+/[^/*]+me=e-1 skip=+\\\\\|\\/+ end=+/[gi]\{0,2\}\s*$+ end=+/[gi]\{0,2\}\s*[;.,)\]}]+me=e-1 contains=@htmlPreproc oneline

hi def link javascriptRegexpString String

" Comments
syn keyword javascriptCommentTodo TODO FIXME XXX TBD contained
syn match javascriptLineComment "\/\/.*" contains=@Spell,javascriptCommentSkip
syn match javascriptCommentSkip "^[ \t]*\*\($\|[ \t]\+\)"
syn region javascriptComment start="/\*" end="\*/" contains=@Spell,javascriptCommentTodo

hi def link javascriptComment Comment
hi def link javascriptLineComment Comment
hi def link javascriptCommentTodo Todo

" Built-in keywords
syn keyword javascriptConditional if else switch
syn keyword javascriptRepeat while for do in of
syn keyword javascriptBranch break continue
syn keyword javascriptOperator new delete void instanceof typeof is isnt
syn keyword javascriptStatement return with yield debugger
syn keyword javascriptBoolean true false
syn keyword javascriptNull null undefined
syn keyword javascriptInvalidNumber Infinity NaN
syn keyword javascriptDefine arguments this var let const class super module
syn keyword javascriptLabel case default
syn keyword javascriptException try catch finally throw
syn keyword javascriptModule import from as export
syn keyword javascriptFutureReserved enum extends
syn keyword javascriptStrictReserved implements private public interface package protected static
syn keyword javascriptFunction function

hi def link javascriptConditional Conditional
hi def link javascriptRepeat Repeat
hi def link javascriptBranch Conditional
hi def link javascriptOperator Operator
hi def link javascriptStatement Statement
hi def link javascriptBoolean Boolean
hi def link javascriptNull Keyword
hi def link javascriptInvalidNumber Number
hi def link javascriptDefine Statement
hi def link javascriptLabel Label
hi def link javascriptException Exception
hi def link javascriptModule Keyword
hi def link javascriptFutureReserved Keyword
hi def link javascriptStrictReserved Keyword
hi def link javascriptFunction Function

" Globals
syn keyword javascriptGlobal self window top parent global
syn keyword javascriptGlobalModule Math JSON
syn keyword javascriptGlobalFunction eval parseInt parseFloat isNaN isFinite decodeURI decodeURIComponent encodeURI encodeURIComponent require
syn keyword javascriptMember document event location console navigator
syn keyword javascriptMessage alert confirm prompt status

hi def link javascriptGlobal Constant
hi def link javascriptGlobalModule Constant
hi def link javascriptGlobalFunction Constant
hi def link javascriptMember Constant
hi def link javascriptMessage Constant

" Types, classes, modules and built-ins
syn keyword javascriptType Boolean Date Function Number Object String RegExp Proxy
syn keyword javascriptErrorType Error EvalError RangeError ReferenceError SyntaxError TypeError URIError
syn keyword javascriptCollection Array Map WeakMap Set WeakSet Dict
syn keyword javascriptTypedArray Uint8Array Uint16Array Uint32Array Uint8ClampedArray Int8Array Int16Array Int32Array Float32Array Float64Array ArrayBuffer DataView

hi def link javascriptType Type
hi def link javascriptErrorType Type
hi def link javascriptCollection Type
hi def link javascriptTypedArray Type

" Syntactic elements
syn match javascriptBraces "[{}\[\]]"
syn match javascriptParens "[()]"
syn match javascriptSpread "\.\.\."
syn match javascriptFatArrowFunction "=>"

hi def link javascriptBraces Delimiter
hi def link javascriptParens Delimiter
hi def link javascriptSpread Delimiter
hi def link javascriptFatArrowFunction Function

" jsdoc or similar documentation syntax
syn region javascriptDocumentation start="/\*\*" end="\*/" contains=@Spell,javascriptDocParam
" syn match javascriptDocTypeType /\<\u\w*\>/ contained containedin=javascriptDocType
syn match javascriptDocParam "@.*$" contained containedin=javascriptDocumentation contains=javascriptDocInstruction
syn match javascriptDocPArgument "@\(param\|arg\|opt\)\( \({[^}]\+}\)\)\? [^ ]*" contained containedin=javascriptDocumentation
syn match javascriptDocPReturn "@returns\?\( \({[^}]\+}\)\)\?" contained containedin=javascriptDocumentation
syn match javascriptDocPDefine "@\(method\|class\|namespace\|inherits\|extends\)\( \(\I\i*\.\)*\I\i*\)\?" contained containedin=javascriptDocumentation
syn match javascriptDocInstruction "@\w\+" contained containedin=javascriptDocParam,javascriptDocPArgument,javascriptDocPReturn,javascriptDocPDefine

syn match javascriptDocType "{[^}]\+}" contained containedin=javascriptDocPArgument,javascriptDocPReturn
syn match javascriptDocType " \(\I\i*\.\)*\I\i*" contained containedin=javascriptDocPDefine
syn match javascriptDocTypeType "\<\I\i*\>" contained containedin=javascriptDocType,javascriptDocType

hi def link javascriptDocumentation Comment
hi def link javascriptDocInstruction Keyword
hi def link javascriptDocType Delimiter
hi def link javascriptDocTypeType Type

" Define optional warnings; they have to be at the end-ish to make a difference
if exists('g:javascript_warning_trailing_space')
	syn match javascriptTrailingSpaceWarning "\s\s*$"
endif
if exists('g:javascript_warning_trailing_semicolon')
	syn match javascriptTrailingSemicolonWarning ";$"
endif
if exists('g:javascript_warning_leading_semicolon')
	syn match javascriptLeadingSemicolonWarning ";" contained
	syn match javascriptLeadingSemicolonLine "^\s*;" contains=javascriptLeadingSemicolonWarning
endif
if exists('g:javascript_warning_plus_minus')
	syn match javascriptLeadingPlusMinusWarning "[-+]*" contained
	syn match javascriptLeadingPlusMinusLine "^\s*[+-][+-]*" contains=javascriptLeadingPlusMinusWarning
	syn match javascriptTrailingDecrementWarning "---*$"
	syn match javascriptTrailingIncrementWarning "+++*$"
endif
if exists('g:javascript_warning_leading_comma')
	syn match javascriptLeadingCommaWarning "," contained
	syn match javascriptLeadingCommaLine "^\s*," contains=javascriptLeadingCommaWarning
endif
if exists('g:javascript_warning_leading_opening_parens')
	syn match javascriptLeadingParensWarning "[\[{(]" contained
	syn match javascriptLeadingParensLine "^\s*[\[{(]" contains=javascriptLeadingParensWarning
endif
if exists('g:javascript_warning_leading_dot')
	syn match javascriptLeadingDotWarning "\." contained
	syn match javascriptLeadingDotLine "^\s*\." contains=javascriptLeadingDotWarning
endif
if exists('g:javascript_warning_trailing_dot')
	syn match javascriptTrailingDotWarning /\.$/
endif

" Pragmas
syn match javascriptUseStrict +^\s*"use strict";\?$+

hi def link javascriptUseStrict PreProc

" Easier embedding
syn cluster javascriptAll contains=javascriptWarning,
\	javascriptWarning,
\	javascriptLogical,
\	javascriptBinary,
\	javascriptBinary,
\	javascriptAssign,
\	javascriptUnary,
\	javascriptDelimiter,
\	javascriptStringD,
\	javascriptStringS,
\	javascriptQuasiVariableName,
\	javascriptQuasiVariable,
\	javascriptQuasiLiteral,
\	javascriptClassName,
\	javascriptConstant,
\	javascriptDotAccess,
\	javascriptLabelDefine,
\	javascriptNumber,
\	javascriptFloat,
\	javascriptRegexpString,
\	javascriptComment,
\	javascriptLineComment,
\	javascriptCommentTodo,
\	javascriptConditional,
\	javascriptRepeat,
\	javascriptBranch,
\	javascriptOperator,
\	javascriptStatement,
\	javascriptBoolean,
\	javascriptNull,
\	javascriptInvalidNumber,
\	javascriptDefine,
\	javascriptLabel,
\	javascriptException,
\	javascriptModule,
\	javascriptFutureReserved,
\	javascriptStrictReserved,
\	javascriptFunction,
\	javascriptGlobal,
\	javascriptGlobalModule,
\	javascriptGlobalFunction,
\	javascriptMember,
\	javascriptMessage,
\	javascriptType,
\	javascriptErrorType,
\	javascriptCollection,
\	javascriptTypedArray,
\	javascriptBraces,
\	javascriptParens,
\	javascriptSpread,
\	javascriptFatArrowFunction,
\	javascriptDocumentation

" Limits
syn sync fromstart
syn sync maxlines=100

if !exists('b:current_syntax')
  let b:current_syntax = 'javascript'
endif
