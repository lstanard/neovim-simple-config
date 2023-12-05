-----------------------------------------------------------
-- Plugins
-----------------------------------------------------------

-- Init lazy.nvim plugin manager

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- Catppuccin color scheme
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000
  },
  -- Icons (for Telescope and other plugins)
  {
    'nvim-tree/nvim-web-devicons',
  },
  -- Toggle comments
  {
    'numToStr/Comment.nvim',
    lazy = false,
    config = function() require('Comment').setup() end,
  },
  -- Highlight and automatically remove trailing whitespace
  {
    'ntpeters/vim-better-whitespace',
  },
  -- Show indentation guide lines
  {
		'lukas-reineke/indent-blankline.nvim',
		main = 'ibl',
		opts = {},
    config = function ()
      local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      }
      local hooks = require "ibl.hooks"
      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      end)

      vim.g.rainbow_delimiters = { highlight = highlight }
      require("ibl").setup { scope = { highlight = highlight } }

      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
	},
  -- Move lines and selections up/down/left/right
  {
    'echasnovski/mini.move',
    version = '*',
    config = function()
      require('mini.move').setup({
        mappings = {
          -- Alt key on mac requires specifying the character generated by the key combination pressed,
          -- see https://stackoverflow.com/a/5382863/1183876.

          -- Move visual selection in Visual mode
          left = '˙',     -- <Alt-h>
          right = '¬',    -- <Alt-l>
          down = '∆',     -- <Alt-j>
          up = '˚',       -- <Alt-k>
          -- Move current line in Normal mode
          line_left = '˙',  -- <Alt-h>
          line_right = '¬', -- <Alt-l>
          line_down = '∆',  -- <Alt-j>
          line_up = '˚',    -- <Alt-k>
        },
      })
    end,
  },
  -- Tabline
  {
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {
      auto_hide = true
    },
    version = '^1.0.0',
  },
  -- Floating notification messages
  {
    'rcarriga/nvim-notify',
    config = function()
      vim.notify = require('notify')
    end,
  },
  -- Display popup with possible keybindings
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    config = function() require('which-key').setup({}) end,
  },
  -- Show marks in sign column
  {
    'chentoast/marks.nvim',
    config = function() require('marks').setup() end,
  },
  -- Open lazygit from within neovim
  {
    'kdheepak/lazygit.nvim'
  },
  -- Git indicators in the sign column
  {
    'lewis6991/gitsigns.nvim',
    config = function() require('gitsigns').setup({
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, {expr=true})

        map('n', '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, {expr=true})
      end,
    }) end,
  },
  -- Pairs of handy bracket mappings
  {
    'tpope/vim-unimpaired',
  },
  -- Telescope (and extensions)
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.4',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  {
    'nvim-telescope/telescope-file-browser.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
  },
  -- GitHub Copilot
  {
    'github/copilot.vim'
  },
  -- Syntax parser
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = {
          'lua',
          'vim',
          'python',
          'jsdoc',
          'javascript',
          'typescript',
          'css',
          'scss',
          'tsx',
          'json',
          'yaml',
          'html',
          'graphql',
          'markdown',
          'markdown_inline',
        },
        sync_install = false,
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = { enable = true },
        ignore_install = {},
        modules = {},
      })
    end
  },
  -- Better quickfix window
  -- NOTE: Haven't used this yet, but adding here so I don't forget about it
  {
    'kevinhwang91/nvim-bqf'
  },
  -- Diagnostics tools
  {
    'folke/trouble.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('trouble').setup()
    end,
  },
  -- LSP and auto-complete
  'neovim/nvim-lspconfig',                -- Configurations for the neovim LSP client
  'williamboman/mason.nvim',              -- Package manager for Neovim LSPs (and linters)
  'williamboman/mason-lspconfig.nvim',    -- Mason extension for better integration with nvim-lspconfig
  'folke/neodev.nvim',                    -- Neovim setup for lua development
  {                                       -- LSP loading status indicator
    'j-hui/fidget.nvim',
    tag = 'legacy',
    config = function()
      require('fidget').setup({})
    end,
  },
})

require('telescope').load_extension('file_browser')

-----------------------------------------------------------
-- LSP Config: Mason
-----------------------------------------------------------

local servers = {
  pyright= {},
  eslint = {},
  tsserver = {},
  graphql = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
  automatic_installation = true,
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      -- on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

-----------------------------------------------------------
-- LSP Config: nvim-lspconfig
--
-- NOTE: This config was taken directly from the README and
-- may require some tweaking.
-----------------------------------------------------------

-- Setup language servers.
local lspconfig = require('lspconfig')
lspconfig.pyright.setup {}
lspconfig.tsserver.setup {}

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
