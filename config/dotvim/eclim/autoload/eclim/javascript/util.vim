" Author:  Eric Van Dewoestine
"
" Description: {{{
"
" License:
"
" Copyright (C) 2005 - 2012  Eric Van Dewoestine
"
" This program is free software: you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation, either version 3 of the License, or
" (at your option) any later version.
"
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
"
" You should have received a copy of the GNU General Public License
" along with this program.  If not, see <http://www.gnu.org/licenses/>.
"
" }}}

" Global Variables {{{
  if !exists("g:EclimJavascriptLintEnabled")
    " enabling by default until jsdt validation is mature enough to use.
    "let g:EclimJavascriptLintEnabled = 0
    let g:EclimJavascriptLintEnabled = 1
  endif

  if !exists('g:EclimJavascriptLintConf')
    let g:EclimJavascriptLintConf = eclim#UserHome() . '/.jslrc'
  endif
" }}}

" Script Variables {{{
  let s:warnings = '\(' . join([
      \ 'imported but unused',
    \ ], '\|') . '\)'
" }}}

" UpdateSrcFile(validate) {{{
function! eclim#javascript#util#UpdateSrcFile(validate)
  " Disabled until the jsdt matures.
  "call eclim#lang#UpdateSrcFile('javascript', a:validate)

  if g:EclimJavascriptLintEnabled
    call eclim#javascript#util#Jsl()
  endif
endfunction " }}}

" Jsl() {{{
" Runs jsl (javascript lint) on the current file.
function! eclim#javascript#util#Jsl()
endfunction " }}}

" vim:ft=vim:fdm=marker
