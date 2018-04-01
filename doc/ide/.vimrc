" MY VIMRC will help three part:
"   * CONFIG FOR VUNDLE PLUGIN
"   * SETTINGS
"   * SET UP FOR GVIM
"   * SET UP FOR PLUGIN
"   * VIMTIPS

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"CONFIG FOR VUNDLE PLUGIN
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

" This is the Vundle package, which can be found on GitHub.
" Plugin 'gmarik/vundle'

" Explore files and folder
Plugin 'scrooloose/nerdtree.git'

" Fuzzy search files base on file's name in folder, in opened buffer quickly
Plugin 'kien/ctrlp.vim'

" Automatically aligning text
Plugin 'godlygeek/tabular'

" To highlight/mark multiple texts in different colors
Plugin 'inkarkat/vim-ingo-library'
Plugin 'inkarkat/vim-mark'

" Edit xml and jump between xml tags
Plugin 'mattn/emmet-vim'
Plugin 'tmhedberg/matchit'
"Plugin 'sukima/xmledit'
"Plugin 'jeetsukumaran/vim-indentwise'
"Plugin 'atom/bracket-matcher'
"Plugin 'https://github.com/vim-scripts/CountJump'
"Plugin 'othree/xml.vim'

" To find text in multiple files: (adaptation for BurntSushi/ripgrep)
"  to find "abc" in current folder :Rg "abc"
"  to find "abc" in file in current active window :Rg "abc" %
"  to find "abc" in specific folder :Rg "abc" D:\w\mydoc
Plugin 'jremmen/vim-ripgrep'

" Toggle Maximize/Minimize current window
Plugin 'szw/vim-maximizer'

"Solarize
Plugin 'lifepillar/vim-solarized8'

"working with git
Plugin 'tpope/vim-fugitive'

"working with C/C++
Plugin 'majutsushi/tagbar'

call vundle#end()
filetype plugin on

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SETTINGS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"SETTING FOR CURSOR SHAPE IN VIM FOR TERMINAL, reference: https://github.com/jszakmeister/vim-togglecursor/blob/master/plugin/togglecursor.vim
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[0 q"

"SET STATUS LINE
set laststatus=2
set statusline=%<%t
set statusline+=\ \ 
" show current function name at the cursor
" Note sometimes it will slowdown vim -> refer: https://stackoverflow.com/questions/33699049/display-current-function-in-vim-status-line
set statusline+=%{tagbar#currenttag('[%s]\ ','')}
"white space
set statusline+=\ \ 
" show current buffer revision in mecurial reposity
" -> I see this plugin not work well so I disable that
" set statusline+=[%{HGRev()}] 
"white space
set statusline+=\ 
" show current buffer revision in git reposity
" This plugin work well but I don't think this is "must need" information -> just disable this!
set statusline+=%{fugitive#statusline()}
set statusline+=%=
set statusline+=%m "modified flag
set statusline+=%r "readonly flag
set statusline+=%y "filetype
"white space
set statusline+=\ \  
set statusline+=%l
set statusline+=/
set statusline+=%L
set statusline+=(
set statusline+=%p
set statusline+=%%
set statusline+=)-
set statusline+=%c

" MAP LEADER KEY to , (Because real leader hurt my finger)
let mapleader = ","

"SETUP FOR QUICKFIX WINDOW
autocmd Filetype qf call SettingQF()
function! SettingQF()
   "setup for status line of quickfix window
   "Note: status line of quickfix window is different with another window
   "      To know information about current status line we use:
   "      :setlocal statusline<CR>
   setlocal statusline=%t%{w:quickfix_title}%=%l/%L(%p%%)-%c
   "setup default heigh of quickfix window
   7wincmd _
   "setup default position of quickfix window is the most bottom window.
   wincmd J
endfunction

"mapkey to scroll through last 10 quickfix list
"Note: for gvim we use <C-space>, for vim in terminal we use <C-@>
nmap <C-space>n :cnewer<CR>
nmap <C-space>p :colder<CR>
autocmd QuickFixCmdPost [^l]* nested copen
autocmd QuickFixCmdPost    l* nested lwindow

"BIND KEY TO MOVE BETWEEN WINDOW
" map in normal mode
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-Tab> <C-w>p
" map in insert mode
imap <C-Tab> <C-[><C-w>p

"DEFINE TAB EQUAL SOME NUMBER OF SPACE
set tabstop=3 shiftwidth=3 expandtab
set cindent
set cinoptions=(0,u0,U0

"SET FOR MOVE SLOWLY WITH C-f, C-b
"IN NORMAL MODE AND VISUAL MODE
nnoremap <C-f> 3j
vnoremap <C-f> 3j
nnoremap <C-b> 3k
vnoremap <C-b> 3k

" MAP IN INSERT MODE for CTRL-C will act as Ctrl+[ -> for modify multiple line in insert mode easily
imap <C-c> <C-[>

"MAP FOR SAVE FILE QUICKLY
nmap <silent> <Leader>s :w<CR>
"MAP FOR QUIT
nmap <silent> <Leader>q :qa<CR>
"MAP FOR CLEAR HIGHTLIGHT UNTIL NEXT SEARCH
nmap <silent> <Leader>x :noh<CR>
"MAP FOR OPEN FILES/ FOLDER
nnoremap <Leader>e :e 
" SET UP to remap key to switch to EX-Command mode from normal mode and visual mode
" reference: http://vim.wikia.com/wiki/VimTip1111
"            https://vi.stackexchange.com/questions/7494/how-to-switch-semicolon-to-colon-to-repeat-last-f-or-t-search
nnoremap <space> :
vnoremap <space> :
"MAP FOR ESCAPE FROM INSERT MODE
imap jk <Esc>

"DISABLE BEEP and FLASH with an autocmd:
set noeb vb t_vb=
au GUIEnter * set vb t_vb=

"TEXT SEARCHING
"define color for highlight search
set hlsearch
"define ignorecase feature in searching/replace
set ignorecase
"define high light in seaching feature
set hlsearch incsearch
"search for visually selected text. How to use: Select text. Then press "/" then press "/"
vnoremap // y/<C-R>"<CR>

"SET UP FOR CASE-INSENSIVE FILENAME COMPLETION
set wildignorecase

"SET UP FOR AUTOMATICALLY JUMP TO CURRENT DIRECTORY , exept /tmp
autocmd BufEnter * if expand("%:p:h") !~ '^/tmp' | silent! lcd %:p:h | endif

"ESENTIAL CONFIG
set hidden
set pastetoggle=<F2>
set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class
set title                " change the terminal's title
set nobackup
set noswapfile
set nowritebackup
set backspace=indent,eol,start
set autoindent
set formatoptions=

syntax enable

"Map key to work with tab
nmap <C-n> :tabnext<CR>
nmap <C-p> :tabprevious<CR>

"Map key to show fullpath of current file then copy it to unamed register then we can use 'p' to paste it.
"reference: https://stackoverflow.com/questions/23204110/mapping-one-key-to-multiple-commands-in-vim
"reference: https://stackoverflow.com/questions/916875/yank-file-name-path-of-current-buffer-in-vim
nmap <C-g> :echo expand('%:p') <bar> let @" = expand("%:p")<CR>

" SET UP FOR DIFFTOGGLE
nnoremap <silent> <Leader>d :call DiffToggle()<CR>
function! DiffToggle()
   if &diff
      diffoff
   else
      diffthis
   endif
:endfunction

"Make updatetime shorter
set updatetime=500

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"SET UP FOR GVIM
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" font
set guifont=consolas:h10

" remove menubar/srcrolbar
set guioptions-=m  "remove menu bar
set guioptions-=M  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"SET UP FOR PLUGIN
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"plugin: scrooloose/nerdtree.git
"Fix for nerdtree https://stackoverflow.com/questions/8753286/nerd-tree-enter-does-not-open-sub-dirs
let g:NERDTreeDirArrows=0

"plugin: kien/ctrlp.vim
"ctrlp will ignore .so .zip ...
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/sourceCodeDoxygen/*    " Linux/MacOSX
"map key for ctrlp plugin
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_map = '<Leader>p'
"nmap <silent> <Leader>d :CtrlP D:/w/mydoc<CR>
nmap <silent> <Leader>w :CtrlP D:/home/search<CR>
nmap <silent> <Leader>b :CtrlPBuffer<CR>

"plugin jremmen/vim-ripgrep'
"use --smart-case option with ripgrep command
let g:rg_command = 'rg --vimgrep -S'
"MAP for search code: How to use: Press <Leader>x then use "Ctrl-b> to move to the begining of the line and then type Rg "search_text"
" We should create soft symbolic link for the code folders to some convenients path to search easier!
nnoremap <Leader>c : D:\home\search\ D:\home\search\
"MAP for search html
nnoremap <Leader>h : D:\home\search

"Search for visually selected text. How to use: Select text. Then press "/" then press "/"
vnoremap <Leader>c y:Rg "\b<C-R>"\b" D:\home\search\ D:\home\search\ <CR>
vnoremap <Leader>h y:Rg "\b<C-R>"\b" D:\home\search\ <CR>

"plugin szw/vim-maximizer
"map for toogle maximizer window
nnoremap <silent><C-w>z :MaximizerToggle<CR>
vnoremap <silent><C-w>z :MaximizerToggle<CR>gv
inoremap <silent><C-w>z <C-o>:MaximizerToggle<CR>

"How to work with xml:
augroup XML
    autocmd!
    autocmd FileType xml setlocal foldmethod=indent foldlevelstart=999 foldminlines=0
augroup END
"Map key to move to begin/end tag of parrent of an xml tag
"reference: https://stackoverflow.com/questions/6169537/vim-movements-going-to-parent
"reference: https://github.com/mattn/emmet-vim
"Note: to select between tag we use: "vit", to select outside tag "vat"
nnoremap [t vatatov
nnoremap ]t vatatv

let g:solarized_use16 = 1
"set background=light
set background=dark
colorscheme solarized8

"plugin majutsushi/tagbar
nmap <Leader>t :TagbarToggle<CR>
let g:tagbar_sort = 0
highlight TagbarHighlight ctermfg=white ctermbg=red

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"VIMTIPS:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"<C-w>T to open current file in new tab => we have fullscreen.
"And it can apply for quickfix window as well. Note: we can type :tabnew %
