" ============================================================================
" File:        smartdict.vim
" Description: Vim plugin to translate words
" Author:      Sergey Potapov (aka Blake) <blake131313 AT gmail DOT com>
" Version:     0.1
" Homepage:    http://smartdict.net
" License:     GPLv2+ -- look it up.
" Copyright:   Copyright (C) 2012 Sergey Potapov (aka Blake)
"
"              This program is free software; you can redistribute it and/or
"              modify it under the terms of the GNU General Public License as
"              published by the Free Software Foundation; either version 2 of
"              the License, or (at your option) any later version.
"
"              This program is distributed in the hope that it will be useful,
"              but WITHOUT ANY WARRANTY; without even the implied warranty of
"              MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
"              General Public License for more details.
"
"              You should have received a copy of the GNU General Public License
"              along with this program; if not, write to the Free Software
"              Foundation, Inc., 59 Temple Place, Suite 330, Boston,
"              MA 02111-1307 USA
" ============================================================================
"
" To keep the plugin from being loaded more than once
if exists("loaded_smartdict")
    finish
endif
let loaded_smartdict = 1


function s:PreviewVerifyRuby()
    if has('ruby')
        return 1
    else
        echo 'To use Preview plugin you should compile vim with --enable-rubyinterp option'
        return 0
    endif
endfunction


function! s:SmartdictTranslate()
    if(s:PreviewVerifyRuby())
        call smartdict#translate()
    endif
endfunction


if(!exists('g:SmartdictFromLang'))
    let g:SmartdictFromLang = 'en'
endif
if(!exists('g:SmartdictToLang'))
    let g:SmartdictToLang = 'ru'
endif
if(!exists('g:SmartdictDriver'))
    let g:SmartdictDriver = 'google_translate'
endif
if(!exists('g:SmartdictLog'))
    let g:SmartdictLog = 1
endif
if(!exists('g:SmartdictDefaultMapping'))
    let g:SmartdictDefaultMapping = 1
endif


command! SmartdictTranslate call s:SmartdictTranslate()

if g:SmartdictDefaultMapping
    :nmap <Leader>T :SmartdictTranslate<CR>
endif
