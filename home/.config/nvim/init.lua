if pcall(require, 'packer') then require('packer').startup(function(use)

  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Better filetypes support
  use 'sheerun/vim-polyglot'
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', config = function()
    require'nvim-treesitter.configs'.setup {
      ensure_installed = { 'python', 'go', 'javascript', 'vue', 'lua' },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,  -- Needed to disable spellchecking of keywords, function names, etc.
      }
    }
  end}
  use 'psliwka/vim-redact-pass'

  -- LSP integration
  use {'neovim/nvim-lspconfig', requires = { 'hrsh7th/nvim-cmp', 'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-vsnip', 'hrsh7th/vim-vsnip' }, config = function()
    local nvim_lsp = require('lspconfig')
    local cmp = require('cmp')
      cmp.setup({
      snippet = {
        expand = function(args)
          vim.fn["vsnip#anonymous"](args.body)
        end,
      },
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
        { name = 'buffer' },
      })
    })

    local on_attach = function(client, bufnr)
      local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
      local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
      local opts = { noremap=true, silent=true }
      buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
      buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
      buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
      buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
      buf_set_keymap('n', '<leader>lr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
      buf_set_keymap('n', '<leader>lR', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
      buf_set_keymap('n', '<leader>ld', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
      buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
      buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    end

    -- Use a loop to conveniently call 'setup' on multiple servers and
    -- map buffer local keybindings when the language server attaches
    local servers = { 'pyright', 'gopls', 'sumneko_lua', 'ansiblels' }
    local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    for _, lsp in ipairs(servers) do
      nvim_lsp[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = {
          debounce_text_changes = 150,
        }
      }
    end
  end}

  -- Additional features
  use 'tpope/vim-repeat'
  use 'tpope/vim-fugitive'
  use 'wellle/targets.vim'
  use 'michaeljsmith/vim-indent-object'
  use {'machakann/vim-sandwich', config = 'vim.cmd[[runtime macros/sandwich/keymap/surround.vim]]'}
  use 'tpope/vim-eunuch'
  use {'nvim-telescope/telescope.nvim', requires = { {'nvim-lua/plenary.nvim'} }, config = function()
    require('telescope').setup{
      defaults = {
        layout_strategy = 'vertical',
        winblend = 10,
      },
    }
    vim.cmd[[
      nnoremap <leader>fd <cmd>Telescope find_files<cr>
      nnoremap <leader>rg <cmd>Telescope live_grep<cr>
      nnoremap <leader>b <cmd>Telescope buffers<cr>
    ]]
  end}
  use {'kyazdani42/nvim-tree.lua', config = function()
    require'nvim-tree'.setup{}
    vim.cmd[[nnoremap <leader>ft :NvimTreeToggle<CR>]]
  end}
  use {'akinsho/bufferline.nvim', config = function()
    require("bufferline").setup{
      options = {
        separator_style = "slant",
      }
    }
  end}
  use {'numToStr/Comment.nvim', config = function() require('Comment').setup() end}
  use 'tpope/vim-unimpaired'
  use 'psliwka/termcolors.nvim'

  -- Appearance
  use {'NTBBloodbath/doom-one.nvim', config = function()
    require("doom-one").setup{
      cursor_coloring = true,
      italic_comments = true,
      terminal_colors = true,
      plugins_integrations = {
        bufferline = true,
        gitgutter = true,
        telescope = true,
      },
      pumblend = {
          transparency_amount = 10,
      },
    }
  end}
  use 'kyazdani42/nvim-web-devicons'
  -- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#change-diagnostic-symbols-in-the-sign-column-gutter
  local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  -- Situational awareness enhancements
  use {'airblade/vim-gitgutter', config = [[ vim.g.gitgutter_sign_removed_above_and_below = '‾_' ]]}
  use {'lukas-reineke/indent-blankline.nvim', config = function()
    vim.g.indentLine_char = '▏'
    vim.g.indent_blankline_show_trailing_blankline_indent = false
    vim.cmd[[
      autocmd OptionSet list if &list | execute('IndentBlanklineEnable') | else | execute('IndentBlanklineDisable') | endif
      autocmd BufAdd * if &list | execute('IndentBlanklineEnable') | else | execute('IndentBlanklineDisable') | endif
    ]]
  end}
  use 'psliwka/vim-smoothie'
  use {'hoob3rt/lualine.nvim', config = function()
    require('lualine').setup{}
  end}
  use {'unblevable/quick-scope', config = [[ vim.g.qs_highlight_on_keys = {'f', 'F', 't', 'T'} ]]}
  use {'norcalli/nvim-colorizer.lua', config = function()
    require('colorizer').setup({'*'}, { names = false; rgb_fn = true; })
  end}
  use {'~/vim-dirtytalk', run = ':DirtytalkUpdate', config = 'vim.cmd[[set spelllang=en,programming]]'}
  use {'mbbill/undotree', config = 'vim.cmd[[nnoremap <leader>ut :UndotreeToggle<CR>]]'}

end) end

-- Basic settings are kept in a Vim-compatible vimscript file
vim.cmd('source ~/.vimrc')
