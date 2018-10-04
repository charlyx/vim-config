set nocompatible

call plug#begin("~/.config/nvim/bundle")
    Plug 'ncm2/ncm2'
    " ncm2 requires nvim-yarp
    Plug 'roxma/nvim-yarp'

    autocmd BufEnter * call ncm2#enable_for_buffer()
    set completeopt=noinsert,menuone,noselect
    set shortmess+=c

    au TextChangedI * call ncm2#auto_trigger()

    inoremap <c-c> <ESC>

    inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
    inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

    Plug 'ncm2/ncm2-bufword'
    Plug 'ncm2/ncm2-jedi'

    Plug 'ncm2/ncm2-match-highlight'
    Plug 'ncm2/ncm2-cssomni'

    Plug 'autozimu/LanguageClient-neovim'
    let g:LanguageClient_serverCommands = {
                \ 'javascript': ['javascript-typescript-stdio'],
                \ 'css': ['css-languageserver', '--stdio'],
                \ }
    let g:LanguageClient_completionPreferTextEdit = 1

    Plug 'airblade/vim-gitgutter'
    Plug 'iCyMind/NeoSolarized'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'tpope/vim-fugitive'
    Plug 'jeffkreeftmeijer/vim-numbertoggle'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    Plug 'editorconfig/editorconfig-vim'
    Plug 'w0rp/ale'
    Plug 'mattn/emmet-vim'
    Plug 'tpope/vim-surround'
    Plug 'junegunn/goyo.vim'
    Plug 'junegunn/limelight.vim'
    Plug 'ap/vim-css-color'
call plug#end()

colorscheme NeoSolarized

filetype plugin indent on
syntax on

set encoding=utf8
set fileencoding=utf8
set fileformat=unix
set autoindent
set ts=2

set scrolloff=5

set ruler
set number relativenumber
set cursorline
set colorcolumn=80

set backspace=indent,eol,start

set softtabstop=2
set shiftwidth=2
set tabstop=2
set expandtab

set showmatch  "show matching brackets/parenthesis
set incsearch  "find as you type search
set hlsearch   "highlight search terms

set nofoldenable          "no auto fold code

set listchars=tab:>.,trail:.,extends:#,nbsp:. " Highlight problematic whitespace

set termguicolors
set background=light
set signcolumn=yes
set number relativenumber
set cursorline

let g:gitgutter_enabled = 1
let g:gitgutter_override_sign_column_highlight = 0

let mapleader = ","

let g:fzf_nvim_statusline = 0 " disable statusline overwriting

nnoremap <silent> <leader><space> :Files<CR>

"emmet
au BufRead,BufNewFile *.html,*.css,*.jsx,*.svg map <buffer> <leader>e <c-y>,

"goyo integration for limelight
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

"escape terminal
tnoremap <Esc> <C-\><C-n>
