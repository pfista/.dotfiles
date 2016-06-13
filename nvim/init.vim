call plug#begin('~/.config/nvim/plugged')

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/syntastic'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'Lokaltog/vim-easymotion'
Plug 'chriskempson/base16-vim'
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'fatih/vim-go'
Plug 'majutsushi/tagbar'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'

" Add plugins to &runtimepath
call plug#end()

" Plugin configurations
let g:airline_powerline_fonts = 1
let g:airline_theme='powerlineish'

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlPLastMode'
let g:ctrlp_extensions = ['buffertag', 'tag', 'line', 'dir']
let g:syntastic_javascript_checkers = ['eslint']
let g:javascript_enable_domhtmlcss = 1

au FileType go nmap <leader>k <Plug>(go-doc)
au FileType go nmap <leader>rt <Plug>(go-run-tab)

set modelines=0
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set scrolloff=3
set autoindent
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
set cursorline
set ruler
set backspace=indent,eol,start
set laststatus=2
set number

"set undofile -creates a file when you edit that allows undoing after closing the file <FILENAME>.un~
set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch
set noswapfile
set nobackup

" Disable arrow keys :)
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

"this clears out a search to get rid of highlighting once you have found what you are looking for
nnoremap <leader><space> :noh<cr> 

" handle long lines correctly
set wrap
set textwidth=80
"set formatoptions=qrn1
set colorcolumn=81


" autosave when window loses focus au FocusLost * :wa
set nu
set backupdir=~/.config/nvim/backup

"Colorscheme
syntax on
syntax enable
colorscheme molokai 

" Toggle between dark and light backgrounds

function! ToggleDayNight()
    if &background=="dark"
				colorscheme solarized
				let &background="light"
    else
				colorscheme molokai
				let &background="dark"
    endif
endfunction

nnoremap <leader>x :call ToggleDayNight()<CR>

" Make NERDTree close when vim when its the only window open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" make ; map to : so its quicker to save files
nnoremap ; :
inoremap <C-a> <Esc>
vnoremap <C-a> <Esc>

"Map window movement
map <C-j> <C-W>j
" In iterm2 edit -> preferences -> keys. add ctrl+h as keyboard shortcut mapped
" to Escape sequence: [104;5u
map <C-h> <C-W>h 
map <C-k> <C-W>k
map <C-l> <C-W>l
map <C-n> <Esc>:NERDTreeToggle<CR>
nmap <C-m> :TagbarToggle<CR>

"Map tab movement
map <C-U> gT 
map <C-I> gt 

" Set up searching
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif
