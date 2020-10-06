""""""""""""""""""""
"  Basic settings  "
""""""""""""""""""""

" sane defaults
set nocompatible
set mouse=a
set clipboard=unnamedplus
let mapleader = ','

" case insensitive search
set smartcase
set ignorecase

" splits areas
set splitbelow
set splitright

" highlight non-printable characters
set list listchars=tab:\|.,trail:_,extends:>,precedes:<,nbsp:~
set showbreak=\\ " [bonus]
highlight SpecialKey ctermfg=DarkGray

" cyrillic support
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0

" save read-only files
cmap w!! %!sudo tee > /dev/null %

" config live reload
if has ('autocmd') " Remain compatible with earlier versions
 augroup vimrc     " Source vim configuration upon save
    autocmd! BufWritePost $MYVIMRC source % | echom "Reloaded " . $MYVIMRC | redraw
    autocmd! BufWritePost $MYGVIMRC if has('gui_running') | so % | echom "Reloaded " . $MYGVIMRC | endif | redraw
  augroup END
endif " has autocmd

"""""""""""""""""""""""""""
"  Auto-install vim-plug  "
"""""""""""""""""""""""""""

if empty(glob('~/.vim/autoload/plug.vim')) " install vim-plug
  silent !mkdir -p ~/.vim/plugged
  silent !mkdir -p ~/.vim/autoload
  silent !wget -q -c -nc -O ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"""""""""""""""""""""
"  Plugins install  "
"""""""""""""""""""""

call plug#begin('~/.vim/plugged')

" utility
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-fugitive'
" theme
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'vim-scripts/Zenburn'
Plug 'NLKNguyen/papercolor-theme'
" golang
Plug 'fatih/vim-go'
" webdev (frontend)
Plug 'mattn/emmet-vim', { 'for': ['javascript', 'jsx', 'html', 'css'] }
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'ternjs/tern_for_vim' , { 'do': 'npm install' }
" zen
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
" misc
Plug 'scrooloose/nerdtree'
Plug 'w0rp/ale'
Plug 'skywind3000/asyncrun.vim'
Plug 'lyokha/vim-xkbswitch'
" snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'andrewstuart/vim-kubernetes'
" latex
Plug 'lervag/vimtex'

call plug#end()

silent! colors Zenburn

" CSS auto-completion M-x M-o
filetype plugin on
set omnifunc=syntaxcomplete#Complete
" also M-n - to complete names from all buffers

""""""""""""""""""""
"  Plugins config  "
""""""""""""""""""""

" NERDTree
nnoremap <C-g> :NERDTreeToggle<CR>

" Emmet
let g:user_emmet_leader_key='<Tab>'
let g:user_emmet_install_global = 0
let g:user_emmet_settings = {
\  'javascript.jsx' : {
\      'extends' : 'jsx',
\  },
\}
autocmd FileType html,css,javascript,jsx EmmetInstall

" ALE
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
highlight ALEErrorSign ctermbg=NONE ctermfg=red
highlight ALEWarningSign ctermbg=NONE ctermfg=yellow
let g:ale_lint_on_enter = 0 " Less distracting when opening a new file
let g:ale_linters = { 'javascript': ['eslint'], 'sh': ['shellcheck'] }
let g:ale_linters_explicit = 1
let g:ale_fixers = {}
let g:ale_fixers['*'] = ['remove_trailing_lines', 'trim_whitespace']
let g:ale_fixers['javascript'] = ['prettier']
let g:ale_fixers['css'] = ['prettier']
let g:ale_fix_on_save = 1

" vim-xkbswitch
let g:XkbSwitchEnabled = 1
let g:XkbSwitchIMappings = ['ru']

" vim-go
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_fmt_command = "goimports"    " Run goimports along gofmt on each save
let g:go_auto_type_info = 1           " Automatically get signature/type info for object under cursor
au filetype go inoremap <buffer> .<Tab> .<C-x><C-o>
au filetype go nnoremap <F5> :GoRun<CR>

" LaTeX
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'

" Goyo & LimeLight
nnoremap <Leader>gy :Goyo<CR>
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

" UltiSnips
let g:UltiSnipsListSnippets="<c-l>"
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
let g:UltiSnipsEditSplit = 'horizontal'
let g:UltiSnipsSnippetsDir = '~/.vim/UltiSnips'
let g:UltiSnipsSnippetDirectories = ['~/.vim/UltiSnips', 'UltiSnips']

""""""""""""""""""
"   Indentation  "
""""""""""""""""""

autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype go setlocal tabstop=4 shiftwidth=4 softtabstop=4
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

""""""""""""
"  Custom  "
""""""""""""

" Prose mode
function! ProseMode()
  call goyo#execute(0, [])
  set spell noci nosi noai nolist noshowmode noshowcmd
  set spell spelllang=ru_yo,en_us
  set complete+=s
  colors PaperColor
  " toggle background
  let &background = ( &background == "dark"? "light" : "dark" )
  inoremap <Tab> <C-X>s
endfunction

command! ProseMode call ProseMode()
nmap <F11> :ProseMode<CR>
