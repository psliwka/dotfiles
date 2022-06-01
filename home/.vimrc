" Tweak behavior
set mouse=a
set clipboard=unnamedplus
set wildmode=longest:full,full
set updatetime=100
set nofixendofline
set noswapfile
set undofile
map <Space> <Leader>
set ignorecase smartcase
set hidden
set spell
set spellcapcheck=
set spelloptions=camel
set linebreak breakindent breakat=\ 
if has('nvim')
  tnoremap <Esc> <Esc><C-\><C-n>
  set laststatus=3
endif

" Tweak appearance
set termguicolors
set list listchars=tab:▏\ ,trail:•,extends:▶,precedes:◀ showbreak=↪\ 
set number
set guioptions-=T
set cursorline
set signcolumn=yes
set colorcolumn=+1
set noshowmode
set belloff=esc
set shortmess+=I
if has('nvim')
  autocmd TermOpen * setlocal nonumber norelativenumber signcolumn=no nospell
  autocmd TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=1000/3, on_visual=true}
endif
