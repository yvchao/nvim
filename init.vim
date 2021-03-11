"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  _   _                 _              _____             __ _       
" | \ | |               (_)            / ____|           / _(_)      
" |  \| | ___  _____   ___ _ __ ___   | |     ___  _ __ | |_ _  __ _ 
" | . ` |/ _ \/ _ \ \ / / | '_ ` _ \  | |    / _ \| '_ \|  _| |/ _` |
" | |\  |  __/ (_) \ V /| | | | | | | | |___| (_) | | | | | | | (_| |
" |_| \_|\___|\___/ \_/ |_|_| |_| |_|  \_____\___/|_| |_|_| |_|\__, |
"                                                               __/ |
"                                                              |___/ 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Author: @avimitin

" Header And Description
" ======================
" Install python3 pip3 nodejs npm vim-plug manually.
" And using :checkhealth command to check if your neovim are
" lack of any dependency.
"
"bThis neovim configuration is inspired by jdhao/nvim-config
" and theniceboy/nvim

" License
" =======
" License: MIT License
"
" Copyright (c) 2018-2021 avimitin
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to
" deal in the Software without restriction, including without limitation the
" rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
" sell copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
" FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
" IN THE SOFTWARE.

" get platform
let g:is_win = has('win32') || has('win64')
let g:is_linux = has('unix') && !has('macunix')
let g:is_mac = has('macunix')

if g:is_win
	let g:nvim_config_root = 'C:\Users\l602\AppData\Local\nvim'
elseif g:is_linux || g:is_mac
	let g:nvim_config_root = '~/.config/nvim'
endif

let g:nvim_config_file = g:nvim_config_root . '/init.vim'

let &t_ut='' "adjust terminal color

let g:file_list = [ 'mapping.vim',
	\ 'options.vim',
	\ 'plugins.vim'
	\ ]

for s:fname in g:file_list
	execute printf('source %s/core/%s', g:nvim_config_root, s:fname)
endfor
