" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

let mapleader=","

" Toggle [i]nvisible characters
nnoremap <leader>i :set list!<cr>
" Toggle [p]aste mode
nnoremap <leader>p :set paste!<cr>

" auto-reload .vimrc
autocmd! bufwritepost ~/Dropbox/.vimrc source ~/Dropbox/.vimrc
autocmd! bufwritepost ~/.vimrc source ~/.vimrc

" extended matching with %
packadd! matchit

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

set ruler               " show the cursor position all the time
set showcmd             " display incomplete commands
set incsearch           " do incremental searching
set nohlsearch

" allows incsearch highlighting for range commands
" https://www.reddit.com/r/vim/comments/1yfzg2/does_anyone_actually_use_easymotion/
cnoremap $t <CR>:t''<CR>
cnoremap $T <CR>:T''<CR>
cnoremap $m <CR>:m''<CR>
cnoremap $M <CR>:M''<CR>
cnoremap $d <CR>:d<CR>``

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

" <F4> Open current dir in new tab
imap <F4> <Esc>Te<CR>
map <F4> <Esc>Te<CR>

" Copy and paste with system clipboard
set clipboard=unnamedplus

" Command line history size
set history=200

" Command-Line mode tab auto-complete 'like bash' behavior
set wildmode=longest,list
set wildmenu
set wcm=<Tab>

" http://vim.wikia.com/wiki/VimTip84
" allow the . to execute once for each line of a visual selection
vnoremap . :normal .<CR>
" make ` execute the contents of the a register
nnoremap ` @a
vnoremap ` :normal @a<CR>

" clear hls
nnoremap <silent> <C-l> :let @/=""<CR>

" make Y behave like other capitals 
map Y y$

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

" vundle specific options
" http://habrahabr.ru/post/148549/
filetype off            " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" PLUGINS
" let Vundle manage Vundle
" required!
Plugin 'gmarik/vundle'
" original repos on github
Plugin 'Lokaltog/vim-distinguished'
Plugin 'klen/python-mode'
Plugin 'morhetz/gruvbox'
Plugin 'mattn/emmet-vim'
Plugin 'elzr/vim-json'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'jszakmeister/vim-togglecursor'
Plugin 'jpalardy/vim-slime'
Plugin 'pearofducks/ansible-vim'
Plugin 'kien/ctrlp.vim'
Plugin 'zweifisch/pipe2eval'
Plugin 'chrisbra/csv.vim'
Plugin 'mhinz/vim-startify'             " Nice start screen
Plugin 'junegunn/goyo.vim'
Plugin 'neomake/neomake'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'lpenz/vimcommander'
Plugin 'lumiliet/vim-twig'
Plugin 'fidian/hexmode'
Plugin 'easymotion/vim-easymotion'
Plugin 'wikitopian/hardmode'
"Plugin 'justinmk/vim-sneak'  " lightweith alternative to EasyMotion
" clojure plugins
Plugin 'guns/vim-clojure-static'
Plugin 'tpope/vim-fireplace'
Plugin 'dgrnbrg/vim-redl'
Plugin 'raymond-w-ko/vim-niji'
Plugin 'vim-scripts/paredit.vim'
" LaTeX plugins
Plugin 'lervag/vimtex'
" vue plugins
Plugin 'posva/vim-vue'

filetype plugin indent on       " required!

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

silent! colorscheme gruvbox
set bg=dark             " Setting dark mode

syntax enable

" autoformat xml (gg=G)
au FileType xml,xsd setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null
" auto-load formated
au FileType xml,xsd exe ":silent 1,$!xmllint --format --recover - 2>/dev/null"

" vim-toglecursor
let g:togglecursor_insert = 'blinking_line'

" Turn on the run code script
let g:pymode_run = 1
" Binds keys to run python code
let g:pymode_run_bind = '<leader>r'

" ropevim autocomplition
"imap <buffer><Tab> <M-/>

"" Neomake config
"let g:neomake_open_list = 2
"" When writing a buffer.
"call neomake#configure#automake('w')
"" When writing a buffer, and on normal mode changes (after 750ms).
"call neomake#configure#automake('nw', 750)
"" When reading a buffer (after 1s), and when writing.
"call neomake#configure#automake('rw', 1000)

" vim-slime
let g:slime_target = "tmux"
let g:slime_python_ipython = 1

" Emmet config
" enable zen-coding just for html/css/tpl
let g:user_emmet_install_global = 0
autocmd FileType html,css,smarty EmmetInstall

" JSON section
" When you want to format a JSON file type \j
" echo -e - handle UTF-8 characters (convert \uXXXX)
" map <leader>j <Esc>:%!echo -en "$(python -m json.tool)"<CR>
map <leader>j <Esc>:%!jq -M .<CR>
" If you have a file with separate JSON-strings you need another approach to format (type \js):
" NOTE: not tested
map <leader>js <Esc>:%!echo -en "$(python -c 'import json, sys; print("\n".join([json.dumps(json.loads(_.strip()), indent=4) for _ in sys.stdin.readlines()]))')"<CR>
" Syntax highlighting:
" Install https://github.com/elzr/vim-json
" Put this line in your  ~/.vimrc
au BufRead,BufNewFile *.json set filetype=json

" Enable Rainbow Parentesis
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" vim-repl history
imap <silent> <C-up> <Plug>clj_repl_uphist.
imap <silent> <C-down> <Plug>clj_repl_downhist.

" filetype indentation configuration
set expandtab
autocmd FileType php setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth=120
autocmd FileType coffee,javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=120
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth=120
autocmd FileType html,htmldjango,xhtml,haml,tpl setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=0
autocmd FileType sass,scss,css setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth=120
autocmd FileType lua setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=0

" Powerline config
set laststatus=2
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup

" EasyMotion hotkeys
" https://www.reddit.com/r/vim/comments/1yfzg2/does_anyone_actually_use_easymotion/
nmap / <Plug>(easymotion-sn)
xmap / <Esc><Plug>(easymotion-sn)\v%V
omap / <Plug>(easymotion-tn)
nnoremap g/ /
" These `n` & `N` mappings are options. You do not have to map `n` & `N` to
" EasyMotion.
" " Without these mappings, `n` & `N` works fine. (These mappings just provide
" " different highlight method and have some other features )
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)
map <Space> <Plug>(easymotion-s2)

" python-mode config
let g:pymode_lint_ignore = "W0611"  " ignore import errors

" VimCommander
noremap <silent> <F11> :cal VimCommanderToggle()<CR>

" Hard Mode
autocmd VimEnter,BufNewFile,BufReadPost * silent! call HardMode()
nnoremap <leader>h <Esc>:call ToggleHardMode()<CR>

" Startify
let g:startify_bookmarks = ['~/.vimrc',]
" https://habr.com/post/239579/
let g:startify_custom_header = 
    \ map(split(system('fortune ~/.vim/fortunes | cowsay -f satanic -W 60'), '\n'), '" ". v:val') + ['','']
let g:startify_change_to_vcs_root = 1
