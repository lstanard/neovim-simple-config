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
  -- Improved support for native neovim comments
  {
    'folke/ts-comments.nvim',
    opts = {},
    event = 'VeryLazy',
    enabled = vim.fn.has('nvim-0.10.0') == 1,
  },
  -- Session manager
  {
    'rmagatti/auto-session',
    lazy = false,
    dependencies = {
      'nvim-telescope/telescope.nvim', -- Only needed if you want to use sesssion lens
    },
    opts = {
      auto_session_suppress_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
      -- log_level = 'debug',
    },
    config = function()
      require('auto-session').setup({})
    end,
  },
  -- View and edit filesystem like a buffer
  {
    'stevearc/oil.nvim',
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require('oil').setup({
        win_options = {
          signcolumn = 'yes:2',
        },
        view_options = {
          show_hidden = true,
        }
      })
    end,
  },
  -- Git integration
  {
    'tpope/vim-fugitive',
  },
  -- Open lazygit from within neovim
  {
    'kdheepak/lazygit.nvim',
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    }
  },
  -- Git indicators in the sign column
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({
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
          end, { expr = true })

          map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, { expr = true })
        end,
      })
      require('scrollbar.handlers.gitsigns').setup()
    end,
  },
  -- Add git status to oil directory listings
  {
    'refractalize/oil-git-status.nvim',
    dependencies = {
      'stevearc/oil.nvim',
    },
    config = true,
  },
  -- Improved hlsearch
  {
    'kevinhwang91/nvim-hlslens',
    config = function()
      require('hlslens').setup()
    end,
  },
  -- Scrollbar with inline hints
  {
    'petertriho/nvim-scrollbar',
    config = function()
      require('scrollbar').setup()
    end,
  },
  -- Symbols outline
  {
    'simrat39/symbols-outline.nvim',
    config = function()
      require('symbols-outline').setup({
        symbols = {
          File = { icon = "", hl = "@text.uri" },
          Module = { icon = "", hl = "@namespace" },
          Namespace = { icon = "", hl = "@namespace" },
          Package = { icon = "", hl = "@namespace" },
          Class = { icon = "", hl = "@type" },
          Method = { icon = "ƒ", hl = "@method" },
          Property = { icon = "", hl = "@method" },
          Field = { icon = "", hl = "@field" },
          Constructor = { icon = "", hl = "@constructor" },
          Enum = { icon = "", hl = "@type" },
          Interface = { icon = "", hl = "@type" },
          Function = { icon = "", hl = "@function" },
          Variable = { icon = "", hl = "@constant" },
          Constant = { icon = "", hl = "@constant" },
          String = { icon = "", hl = "@string" },
          Number = { icon = "#", hl = "@number" },
          Boolean = { icon = "", hl = "@boolean" },
          Array = { icon = "", hl = "@constant" },
          Object = { icon = "", hl = "@type" },
          Key = { icon = "", hl = "@type" },
          Null = { icon = "", hl = "@type" },
          EnumMember = { icon = "", hl = "@field" },
          Struct = { icon = "", hl = "@type" },
          Event = { icon = "", hl = "@type" },
          Operator = { icon = "", hl = "@operator" },
          TypeParameter = { icon = "", hl = "@parameter" },
          Component = { icon = "", hl = "@function" },
          Fragment = { icon = "", hl = "@constant" },
        },
      })
    end,
  },
  {
    'kylechui/nvim-surround',
    version = "*",
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({})
    end
  },
  -- Open links from markdown files
  {
    'jghauser/follow-md-links.nvim'
  },
  -- Highlight TODO comments
  {
    'folke/todo-comments.nvim',
    config = function()
      require('todo-comments').setup({
        keywords = {
          TODO = { icon = '', color = 'info' },
          NOTE = { icon = '󰏫', color = 'hint' },
        },
        colors = {},
      })
    end,
  },
  -- Highlight instances of word under cursor
  {
    'tzachar/local-highlight.nvim',
    config = function()
      require('local-highlight').setup({
        hlgroup = 'Search',
        -- file_types = {'python', 'markdown', 'javascript', 'typescript'},
        disable_file_types = {},
      })
    end
  },
  -- Highlight and automatically remove trailing whitespace
  {
    'ntpeters/vim-better-whitespace',
  },
  -- Code folding
  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
  },
  -- Generate and insert UUIDs
  {
    'kburdett/vim-nuuid'
  },
  -- Show indentation guide lines
  -- TODO: replace with https://github.com/nvimdev/indentmini.nvim
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    config = function()
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
      require("ibl").setup {
        scope = { highlight = highlight },
        indent = {
          -- Slightly thinner line than the default
          -- NOTE: For some reason this character doesn't work with WezTerm / Nerd Font
          -- char = '🭰',
        },
      }

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
          left = '˙', -- <Alt-h>
          right = '¬', -- <Alt-l>
          down = '∆', -- <Alt-j>
          up = '˚', -- <Alt-k>
          -- Move current line in Normal mode
          line_left = '˙', -- <Alt-h>
          line_right = '¬', -- <Alt-l>
          line_down = '∆', -- <Alt-j>
          line_up = '˚', -- <Alt-k>
        },
      })
    end,
  },
  -- Statusline
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      -- catppuccin frappe
      local colors = {
        blue   = '#8caaee',
        cyan   = '#81c8be',
        black  = '#232634',
        white  = '#c6d0f5',
        red    = '#e78284',
        violet = '#ca9ee6',
        grey   = '#626880',
        orange = '#ef9f76',
        green  = '#a6d189',
      }

      local bubbles_theme = {
        normal = {
          a = { fg = colors.black, bg = colors.blue },
          b = { fg = colors.white, bg = colors.grey },
          c = { fg = colors.white },
        },
        insert = { a = { fg = colors.black, bg = colors.green } },
        visual = { a = { fg = colors.black, bg = colors.cyan } },
        command = { a = { fg = colors.black, bg = colors.orange } },
        replace = { a = { fg = colors.black, bg = colors.red } },
        inactive = {
          a = { fg = colors.white, bg = colors.black },
          b = { fg = colors.white, bg = colors.black },
          c = { fg = colors.white },
        },
      }

      local lualine_style = {
        basic = {
          sections = {
            lualine_a = {
              { 'mode', fmt = function(res) return res:sub(1,1) end }
            },
            lualine_c = {
              {
                'filename',
                path = 1 -- Show full filepath instead of just filename
              }
            },
          },
        },
        bubbles = {
          options = {
            theme = bubbles_theme,
            component_separators = '',
            section_separators = { left = '', right = '' },
          },
          sections = {
            lualine_a = { { 'mode', fmt = function(res) return res:sub(1,1) end, separator = { left = '' }, right_padding = 2 } },
            lualine_b = { 'filename', 'branch' },
            lualine_c = {
              {
                'filename',
                path = 1 -- Show full filepath instead of just filename
              },
            },
            lualine_x = {
              {
                'diagnostics', sources = { 'nvim_lsp' }, symbols = { error = ' ', warn = ' ', info = ' ' },
              },
            },
            lualine_y = { 'filetype', 'progress' },
            lualine_z = {
              { 'location', separator = { right = '' }, left_padding = 2 },
            },
          },
          inactive_sections = {
            lualine_a = { 'filename' },
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = { 'location' },
          },
          tabline = {},
          extensions = {},
        },
      }

      require('lualine').setup(lualine_style.bubbles)
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
  -- Manage terminal windows
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
      require('toggleterm').setup({
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = [[<C-t>]],
        hide_numbers = true,
        insert_mappings = true,
        direction = 'vertical',
        close_on_exit = true,
        shell = vim.o.shell,
      })
    end,
  },
  -- Floating notification messages
  {
    'rcarriga/nvim-notify',
    config = function()
      vim.notify = require('notify')
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("noice").setup({
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
          },
        },
        presets = {
          bottom_search = true,         -- use a classic bottom cmdline for search
          command_palette = true,       -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          lsp_doc_border = true,        -- add a border to hover docs and signature help
        },
        routes = {
          {
            filter = {
              event = "msg_show",
              kind = "",
              find = "more line",
            },
            opts = { skip = true },
          },
          {
            filter = {
              event = "msg_show",
              kind = "",
              find = "line less",
            },
            opts = { skip = true },
          },
          {
            filter = {
              event = "msg_show",
              kind = "",
              find = "written",
            },
            opts = { skip = true },
          },
        }
      })
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
  -- Pairs of handy bracket mappings
  {
    'tpope/vim-unimpaired',
  },
  -- Improve default neovim interfaces
  {
    'stevearc/dressing.nvim',
    opts = {},
  },
  -- Find and replace
  {
    'nvim-pack/nvim-spectre',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
  },
  -- Telescope (and extensions)
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.4',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-live-grep-args.nvim',
        version = '^1.0.0',
      }
    },
    config = function()
      require('telescope').load_extension('live_grep_args')
    end,
  },
  {
    'nvim-telescope/telescope-file-browser.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim'
    },
  },
  -- Copilot
  {
    'zbirenbaum/copilot.lua',
    config = function()
      require('copilot').setup()
    end
  },
  -- Copilot for nvim-cmp
  {
    'zbirenbaum/copilot-cmp',
    config = function()
      require('copilot_cmp').setup()
    end
  },
  -- Syntax parser
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
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
        autotag = {
          enable = true,
        },
      })
    end
  },
  -- Sticky scroll
  {
    'nvim-treesitter/nvim-treesitter-context',
    config = function()
      require('treesitter-context').setup()
    end,
  },
  -- Better quickfix window
  {
    'kevinhwang91/nvim-bqf'
  },
  -- Diagnostics tools
  {
    'folke/trouble.nvim',
    cmd = "Trouble",
    config = function()
      require('trouble').setup({})
    end,
  },
  -- Automatically close and rename HTML tags
  {
    'windwp/nvim-ts-autotag',
  },
  -- Auto pair brackets and such
  {
    'windwp/nvim-autopairs',
    config = function() require('nvim-autopairs').setup({}) end,
  },
  -- LSP
  -- Configurations for the neovim LSP client
  {
    'neovim/nvim-lspconfig',
  },
  'williamboman/mason.nvim',           -- Package manager for Neovim LSPs (and linters)
  'williamboman/mason-lspconfig.nvim', -- Mason extension for better integration with nvim-lspconfig
  'folke/neodev.nvim',                 -- Neovim setup for lua development
  {                                    -- LSP loading status indicator
    'j-hui/fidget.nvim',
    tag = 'legacy',
    config = function()
      require('fidget').setup({})
    end,
  },
  -- Auto-complete & snippets
  'rafamadriz/friendly-snippets',
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
  },
})

require('telescope').load_extension('file_browser')

-----------------------------------------------------------
-- LSP Config: Mason
-----------------------------------------------------------

local servers = {
  pyright = {},
  ruff_lsp = {},
  eslint = {},
  ts_ls = {
    -- NOTE: This isn't working, not sure I'm even doing it right
    opts = {
      inlay_hints = { enabled = true },
    },
  },
  graphql = {},
  ruby_lsp = {},
  rubocop = {},
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
lspconfig.ts_ls.setup {}
lspconfig.ruff_lsp.setup {}
lspconfig.ruby_lsp.setup {}

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
    vim.keymap.set('n', '<space-k>', vim.lsp.buf.signature_help, opts)
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

-----------------------------------------------------------
-- LSP Config: nvim-cmp
-----------------------------------------------------------

-- BUG: The issue with Telescope opening files in insert mode is coming
-- from this nvim-cmp config somewhere. If I comment this out the issue
-- goes away.

local status, cmp = pcall(require, 'cmp')
local luasnip = require('luasnip')
local cmp_autopairs = require('nvim-autopairs.completion.cmp')

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip").filetype_extend("javascript", { "javascriptreact" })

luasnip.config.setup {}

if (not status) then return end

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete({}),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true
    }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = "copilot", group_index = 2 },
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'luasnip' },
    { name = 'path' },
  }),
})

-- [Reference](https://github.com/windwp/nvim-autopairs#you-need-to-add-mapping-cr-on-nvim-cmp-setupcheck-readmemd-on-nvim-cmp-repo)
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

-- Set up lspconfig
local lspConfigCapabilities = require('cmp_nvim_lsp').default_capabilities()
require('lspconfig')['ts_ls'].setup {
  capabilities = lspConfigCapabilities
}

vim.cmd [[
  highlight! default link CmpItemKind CmpItemMenuDefault
]]

-----------------------------------------------------------
-- UFO (code folding)
-----------------------------------------------------------

vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

-- Tell the server the capability of foldingRange,
-- Neovim hasn't added foldingRange to default capabilities, users must add it manually
local ufo_capabilities = vim.lsp.protocol.make_client_capabilities()
ufo_capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true
}
local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
for _, ls in ipairs(language_servers) do
  require('lspconfig')[ls].setup({
    capabilities = capabilities
    -- you can add other fields for setting up lsp server in this table
  })
end
require('ufo').setup()
