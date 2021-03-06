" Vim syntax file
" Language:	C++
" Maintainer:	Ken Shan <ccshan@post.harvard.edu>
" Last Change:	2002 Jul 15

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Read the C syntax to start with
if version < 600
  so <sfile>:p:h/c.vim
else
  runtime! syntax/c.vim
  unlet b:current_syntax
endif

" C++ extentions
syn match cppStatement	        " [A-Z_]*[; ]"
syn match cppAccess		"(\|)"
syn match cppType		"OEPointin\w* \|Ob[A-Z]\w* \|[A-Z]\w*Thing "
syn keyword cppType		YaroSneeze FeldGeomPod Windshield Slaw ObCrawl v2float32 v2float64 ObRef Str SineFloat FlatThing SineVect HandiPoint Atmosphere Gestator KeyboardGlimpser Eventer VisiFeld VertexForm ObRetort VisiDrome unt32 int32 int64 Vect inline virtual explicit export bool wchar_t float64

syn keyword cppExceptions	throw try catch OB_OK
syn keyword cppOperator		operator typeid
syn keyword cppOperator		and bitor or xor compl bitand and_eq or_eq xor_eq not not_eq
syn match cppCast		"\<\(const\|static\|dynamic\|reinterpret\)_cast\s*<"me=e-1
syn match cppCast		"\<\(const\|static\|dynamic\|reinterpret\)_cast\s*$"
syn keyword cppStorageClass	mutable
syn keyword cppStructure	class using typename template namespace
syn keyword cppNumber		NPOS
syn match cppScope            " -> \| \. "
syn match cppBoolean		"{\|}"

" The minimum and maximum operators in GNU C++
syn match cppMinMax "[<>]?"

" Default highlighting
if version >= 508 || !exists("did_cpp_syntax_inits")
  if version < 508
    let did_cpp_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink cppAccess		Paren
  HiLink cppCast		cppStatement
  HiLink cppExceptions		Exception
  HiLink cppOperator		Operator
  HiLink cppStatement		Statement
  HiLink cppType		Type
  HiLink cppStorageClass	StorageClass
  HiLink cppStructure		Structure
  HiLink cppNumber		Number
  HiLink cppScope               Scope
  HiLink cppBoolean		Boolean
  delcommand HiLink
endif

let b:current_syntax = "cpp"

" vim: ts=8
