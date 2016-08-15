" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" auto-reload .vimrc
autocmd! bufwritepost ~/Dropbox/.vimrc source ~/Dropbox/.vimrc

" set full 256 color support for colorscheme
if &term =~ '256color'
  set t_Co=256
  " http://sunaku.github.io/vim-256color-bce.html
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=

  " fix ctrl-left ctr-right ctrl-home ctrl-end
  " temporary solution
  :map <esc>[1;5D <C-Left>
  :map <esc>[1;5C <C-Right>
  :map <esc>[1;5H <C-Home>
  :map <esc>[1;5F <C-End>
  :imap <esc>[1;5D <C-Left>
  :imap <esc>[1;5C <C-Right>
  :imap <esc>[1;5H <C-Home>
  :imap <esc>[1;5F <C-End>
endif

" Backup / Swap / Undo config
set backup                      " delete old backup
set writebackup                 " backup current file
set directory=~/.vim/tmp        " dir for swap files
set backupdir=~/.vim/tmp

set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
  " Set this to the name of your terminal that supports mouse codes.
  " Must be one of: xterm, xterm2, netterm, dec, jsbterm, pterm
  set ttymouse=xterm2
endif

" support russian layout hotkeys
" :help Russian
"
" alternative solution: http://habrahabr.ru/post/98393/
set langmap=ёйцукенгшщзхъфывапролджэячсмитьбюЁЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;`qwertyuiop[]asdfghjkl\\;'zxcvbnm\\,.~QWERTYUIOP{}ASDFGHJKL:\\"ZXCVBNM<>

nmap Ж :
" yank
nmap Н Y
nmap з p
nmap ф a
nmap щ o
nmap г u
nmap З P

set wildmenu
set wcm=<Tab>
" <F10> Exit menu
"menu Exit.quit     :quit<CR>
"menu Exit.quit!    :quit!<CR>
"menu Exit.save     :exit<CR>
"map <F10> :emenu Exit.<Tab>

" <F4> Open current dir in new tab
imap <F4> <Esc>Te<CR> 
map <F4> <Esc>Te<CR>

" show whitespaces
"set list

" Command line history size
set history=200

" Command-Line mode tab auto-complete 'like bash' behavior
set wildmode=longest,list

" Disable arrows for Normal mode (force myself using 'hjkl'-navigations)
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" http://vim.wikia.com/wiki/VimTip84
" allow the . to execute once for each line of a visual selection
vnoremap . :normal .<CR>
" make ` execute the contents of the a register
nnoremap ` @a
vnoremap ` :normal @a<CR>

" show status-line
set laststatus=2 " 0: never
		 " 1: only if there are at least two windows
		 " 2: always

" http://vim.wikia.com/wiki/Show_fileencoding_and_bomb_in_the_status_line
if has("statusline")
 set statusline=%<%f\ %h%m%r%=%{\"[\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"]\ \"}%k\ %-14.(%l,%c%V%)\ %P
endif

" vundle specific options
" http://habrahabr.ru/post/148549/
filetype off		" required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Plugin 'gmarik/vundle'
Plugin 'Lokaltog/vim-distinguished'
Plugin 'klen/python-mode'
Plugin 'morhetz/gruvbox'
Plugin 'mattn/emmet-vim'
Plugin 'elzr/vim-json'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}
Plugin 'jszakmeister/vim-togglecursor'
" clojure plugins
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'guns/vim-clojure-static'
Plugin 'guns/vim-clojure-highlight'
Plugin 'tpope/vim-fireplace'

" distinguished colorscheme
syntax enable
silent! colorscheme gruvbox
set bg=dark		" Setting dark mode

filetype plugin indent on	" required!

"
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed.
"
" EOF vundle specific options

" autoformat xml (gg=G)
au FileType xml setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null
" auto-load formated
au FileType xml exe ":silent 1,$!xmllint --format --recover - 2>/dev/null"

" enable zen-coding just for html/css/tpl
let g:user_emmet_install_global = 0
autocmd FileType html,css,tpl EmmetInstall

" JSON section
" When you want to format a JSON file type \j
" echo -e - handle UTF-8 characters (convert \uXXXX)
map <leader>j <Esc>:%!echo -en "$(python -m json.tool)"<CR>
" If you have a file with separate JSON-strings you need another approach to format (type \js):
" NOTE: not tested
map <leader>js <Esc>:%!echo -en "$(python -c 'import json, sys; print("\n".join([json.dumps(json.loads(_.strip()), indent=4) for _ in sys.stdin.readlines()]))')"<CR>
"
" Syntax highlighting:
" Install https://github.com/elzr/vim-json
" Put this line in your  ~/.vimrc
au BufRead,BufNewFile *.json set filetype=json

" Enable Rainbow Parentesis
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces
