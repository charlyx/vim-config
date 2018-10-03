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

    Plug 'autozimu/LanguageClient-neovim'
    let g:LanguageClient_serverCommands = {
                \ 'javascript': ['javascript-typescript-stdio'],
                \ }
    let g:LanguageClient_completionPreferTextEdit = 1

    Plug 'airblade/vim-gitgutter'
call plug#end()

set signcolumn=yes

let g:gitgutter_enabled = 1
let g:gitgutter_override_sign_column_highlight = 0
