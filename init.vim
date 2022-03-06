" This is an example on how rust-analyzer can be configure using rust-tools

" Prerequisites:
" - neovim >= 0.5
" - rust-analyzer: https://rust-analyzer.github.io/manual.html#rust-analyzer-language-server-binary

" Steps:
" - :PlugInstall
" - Restart

call plug#begin('~/.vim/plugged')

" Collection of common configurations for the Nvim LSP client
Plug 'neovim/nvim-lspconfig'
Plug 'tami5/lspsaga.nvim'

" Autocompletion framework
Plug 'hrsh7th/nvim-cmp'
" cmp LSP completion
Plug 'hrsh7th/cmp-nvim-lsp'
" cmp Snippet completion
Plug 'hrsh7th/cmp-vsnip'
" cmp Path completion
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'
" See hrsh7th other plugins for more great completion sources!

" Adds extra functionality over rust analyzer
Plug 'simrat39/rust-tools.nvim'

" Snippet engine
Plug 'hrsh7th/vim-vsnip'

" Optional
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'ojroques/nvim-hardline'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'tpope/vim-surround'
Plug 'folke/trouble.nvim'

" If you want to display icons, then use one of these plugins:
Plug 'kyazdani42/nvim-web-devicons' " lua

" Some color scheme other then default
Plug 'iCyMind/NeoSolarized'

call plug#end()

set termguicolors
set background=light
colorscheme NeoSolarized

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Avoid showing extra messages when using completion
set shortmess+=c

" Configure LSP through rust-tools.nvim plugin.
" rust-tools will configure and enable certain LSP features for us.
" See https://github.com/simrat39/rust-tools.nvim#configuration
lua <<EOF
-- setup rust-tools
local lsp_status = require('lsp-status')
lsp_status.register_progress()

local lspconfig = require('lspconfig')

lspconfig.rust_analyzer.setup({
  on_attach = lsp_status.on_attach,
  capabilities = lsp_status.capabilities
})


local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}
capabilities = vim.tbl_extend('keep', capabilities or {}, lsp_status.capabilities)

capabilities.experimental = {}
capabilities.experimental.hoverActions = true

local opts = {
  tools = {
    autoSetHints = true,
    hover_with_actions = true,
    runnables = {
      use_telescope = true
    },
    debuggables = {
      use_telescope = true
    },
    inlay_hints = {
      show_parameter_hints = true,
      parameter_hints_prefix = "↢ ",
      other_hints_prefix  = "↣ ",
      highlight = "RustInlayHint",
    },
    hover_actions = {
      border = {
        {"╭", "FloatBorder"}, {"─", "FloatBorder"},
        {"╮", "FloatBorder"}, {"│", "FloatBorder"},
        {"╯", "FloatBorder"}, {"─", "FloatBorder"},
        {"╰", "FloatBorder"}, {"│", "FloatBorder"}
      },
      -- whether the hover action window gets automatically focused
      auto_focus = true
    },
    crate_graph = {
      -- Backend used for displaying the graph
      -- see: https://graphviz.org/docs/outputs/
      -- default: x11
      backend = "png",
      -- where to store the output, nil for no output stored (relative
      -- path from pwd)
      -- default: nil
      output = nil,
      -- true for all crates.io and external crates, false only the local
      -- crates
      -- default: true
      full = true,
      -- enabled_graphviz_backends = {
      --   "bmp", "cgimage", "canon", "dot", "gv", "xdot", "xdot1.2", "xdot1.4",
      --   "eps", "exr", "fig", "gd", "gd2", "gif", "gtk", "ico", "cmap", "ismap",
      --   "imap", "cmapx", "imap_np", "cmapx_np", "jpg", "jpeg", "jpe", "jp2",
      --   "json", "json0", "dot_json", "xdot_json", "pdf", "pic", "pct", "pict",
      --   "plain", "plain-ext", "png", "pov", "ps", "ps2", "psd", "sgi", "svg",
      --   "svgz", "tga", "tiff", "tif", "tk", "vml", "vmlz", "wbmp", "webp", "xlib",
      --   "x11"
      -- }
    }
  },
  server = { -- setup rust_analyzer
    on_attach = lsp_on_attach,
    capabilities = capabilities,
    -- to enable rust-analyzer settings visit:
    -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
    ["rust-analyzer"] = {
      -- enable clippy on save
      checkOnSave = {
        command = "clippy"
      },
    }
  },
}

require('rust-tools').setup(opts)
-- setup rust-tools end
EOF

let mapleader = ','

" Code navigation shortcuts
" as found in :help lsp
"nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
"nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
"nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
"nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
"nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
"nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
"nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
"nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
"nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
"nnoremap <silent><leader>n    <cmd>lua vim.lsp.buf.rename()<CR>

" Quick-fix
nnoremap <silent> ga    <cmd>lua vim.lsp.buf.code_action()<CR>

" Setup Completion
" See https://github.com/hrsh7th/nvim-cmp#basic-configuration
lua <<EOF
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },

  -- Installed sources
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'path' },
    { name = 'buffer' },
  },
})
EOF

" have a fixed column for the diagnostics to appear in
" this removes the jitter when warnings/errors flow in
set signcolumn=yes

" Set updatetime for CursorHold
" 300ms of no cursor movement to trigger CursorHold
set updatetime=300
" Show diagnostic popup on cursor hover
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })

" Goto previous/next diagnostic warning/error
nnoremap <silent> g[ <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent> g] <cmd>lua vim.diagnostic.goto_next()<CR>

nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

lua require('gitsigns').setup()

set statusline+=%{get(b:,'gitsigns_status','')}

lua require('hardline').setup {}
lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

require'nvim-web-devicons'.setup {
 -- globally enable default icons (default to false)
 -- will get overriden by `get_icons` option
 default = true;
}

local saga = require 'lspsaga'
saga.init_lsp_saga()

require("trouble").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }

EOF

nnoremap <silent>gh <cmd>lua require'lspsaga.provider'.lsp_finder()<CR>

nnoremap <silent><leader>ca <cmd>lua require('lspsaga.codeaction').code_action()<CR>
vnoremap <silent><leader>ca :<C-U>lua require('lspsaga.codeaction').range_code_action()<CR>

nnoremap <silent>K <cmd>lua require('lspsaga.hover').render_hover_doc()<CR>

nnoremap <silent>gs <cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>

nnoremap <silent>gr <cmd>lua require('lspsaga.rename').rename()<CR>

nnoremap <silent>gd <cmd>lua require'lspsaga.provider'.preview_definition()<CR>

nnoremap <silent><leader>cd <cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>

nnoremap <silent><leader>cc <cmd>lua require'lspsaga.diagnostic'.show_cursor_diagnostics()<CR>

nnoremap <silent> [e <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>
nnoremap <silent> ]e <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>
