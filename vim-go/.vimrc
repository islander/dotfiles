""""""""""""""""""""
"  Basic settings  "
""""""""""""""""""""

" sane defaults
set nocompatible
set mouse=a
set clipboard=unnamedplus
let mapleader = "\ "
let maplocalleader = "\\"

" case insensitive search
set smartcase
set ignorecase

" splits areas
set splitbelow
set splitright

set t_Co=256

" highlight non-printable characters
set list listchars=tab:\|.,trail:_,extends:>,precedes:<,nbsp:~
set showbreak=\\ " [bonus]
highlight SpecialKey ctermfg=DarkGray

" Cyrillic support
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
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
" theme
Plug 'dguo/blood-moon', {'rtp': 'applications/vim'}
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'vim-scripts/Zenburn'
Plug 'NLKNguyen/papercolor-theme'
" golang
Plug 'fatih/vim-go'
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

call plug#end()

silent! colors zenburn

" CSS auto-completion M-x M-o
filetype plugin on
set omnifunc=syntaxcomplete#Complete
" also M-n - to complete names from all buffers

""""""""""""""""""""
"  Plugins config  "
""""""""""""""""""""

" NERDTree
nnoremap <C-g> :NERDTreeToggle<CR>

" ALE
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
highlight ALEErrorSign ctermbg=NONE ctermfg=red
highlight ALEWarningSign ctermbg=NONE ctermfg=yellow
let g:ale_lint_on_enter = 1 " Less distracting when opening a new file
let g:ale_linters = {'go': ['golangci-lint']}
let g:ale_go_golangci_lint_options = ''  " default: --enable-all
let g:ale_linters_explicit = 1
let g:ale_go_golangci_lint_package = 1
let g:ale_fixers = {}
let g:ale_fixers['*'] = ['remove_trailing_lines', 'trim_whitespace']
let g:ale_fix_on_save = 1

" vim-xkbswitch
let g:XkbSwitchEnabled = 1
let g:XkbSwitchIMappings = ['ru']

" vim-go
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_fmt_command = "goimports"    " Run goimports along gofmt on each save
let g:go_auto_type_info = 1           " Automatically get signature/type info for object under cursor
let g:go_debug_windows = {
      \ 'vars':       'rightbelow 60vnew',
      \ 'stack':      'rightbelow 10new',
\ }
au filetype go inoremap <buffer> .<Tab> .<C-x><C-o>
au filetype go nnoremap <F5> :GoRun<CR>
:nnoremap <leader>b :GoDebugBreakpoint<CR>
:nnoremap <leader>n :GoDebugContinue<CR>

" Goyo & LimeLight
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240
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
" fzf
nnoremap <silent> <leader>f :ProjectFiles<CR>
nnoremap <silent> <leader><space> :Buffers<CR>
nnoremap <silent> <leader>A :Windows<CR>
nnoremap <silent> <leader>l :BLines<CR>
nnoremap <silent> <leader>o :BTags<CR>
nnoremap <silent> <leader>t :Tags<CR>
nnoremap <silent> <leader>? :History<CR>
nnoremap <silent> <leader>s :Rg<CR>

" Similarly, we can apply it to fzf#vim#grep. To use ripgrep instead of ag:
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

" Search project root
function! s:find_git_root()
  return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

command! ProjectFiles execute 'Files' s:find_git_root()

" ripgrep
set grepprg=rg\ --vimgrep
