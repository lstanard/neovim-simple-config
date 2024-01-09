-----------------------------------------------------------
-- Simple, barebones neovim config
-----------------------------------------------------------

-- remap leader key to space key (must be set before plugins are loaded)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.termguicolors = true

-----------------------------------------------------------
-- Imports
-----------------------------------------------------------

require('plugins')

-----------------------------------------------------------
-- Configuration settings
-- https://neovim.io/doc/user/options.html
-----------------------------------------------------------

-- Color scheme
-- Additional configuration options https://github.com/catppuccin/nvim
vim.cmd.colorscheme('catppuccin-frappe')

-- General options
vim.opt.cursorline = true     -- highlight current cursorline
vim.opt.errorbells = false    -- disable bell sound for error messages
vim.opt.number = true         -- always show line numbers
vim.opt.relativenumber = true -- use relative line numbers
vim.opt.scrolloff = 3         -- minimum number of screen lines to keep above and below the cursor
vim.opt.showmatch = true      -- highlight matching brackets
vim.opt.signcolumn = 'yes'    -- always show the sign column
vim.opt.syntax = 'on'         -- enable syntax highlighting
vim.opt.updatetime = 500      -- time in milliseconds to trigger CursorHold event

-- Search options
vim.opt.hlsearch = true   -- highlight results of previous search
vim.opt.ignorecase = true -- ignore uppercase letters when executing search
vim.opt.incsearch = true  -- highlight pattern matches while typing search
vim.opt.smartcase = true  -- make search ignore uppercase letters unless the search term has uppercase

-- Whitespace and indentation
vim.opt.autoindent = true -- copy indent from current line when starting a new line
vim.opt.breakindent = true -- preserve indentation of virtual lines
vim.opt.expandtab = true -- converts tabs to white space
vim.opt.list = false -- show whitespace characters
vim.opt.listchars = 'space:·,tab: →' -- characters to use for whitespace
vim.opt.shiftwidth = 2 -- width for autoindent
vim.opt.smartindent = true -- do smart autoindent when starting a new line
vim.opt.softtabstop = 2 -- number of spaces that a <Tab> counts for
vim.opt.tabstop = 2 -- number of columns occupied by a tab
vim.opt.wrap = true -- wrap long lines

-- Whitespace fixing
vim.g.better_whitespace_enabled = 1
vim.g.strip_whitespace_on_save = 1

------------------------------------------
-- Misc configuration
---------------------------------------

-- Icons in sign column for diagnostics
local signs = {
  Error = "",
  Warn = "",
  Hint = "󰆈",
  Information = "󰋼"
}

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Command to toggle inline diagnostics
vim.api.nvim_create_user_command(
  'DiagnosticsToggleVirtualText',
  function()
    local current_value = vim.diagnostic.config().virtual_text
    if current_value then
      vim.diagnostic.config({ virtual_text = false })
    else
      vim.diagnostic.config({ virtual_text = true })
    end
  end,
  {}
)

-- Prevent opening file in insert mode
-- HACK: This is a fix for a bug with Telescope + nvim-cmp that causes files to open in insert mode
vim.api.nvim_create_autocmd('WinLeave', {
  callback = function()
    if vim.bo.ft == "TelescopePrompt" and vim.fn.mode() == "i" then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
    end
  end,
})

-- NOTE: Disabling for now, causing some weird issues
-- Automatically format on save
-- vim.api.nvim_create_autocmd('BufWritePre', {
--   callback = function()
--     vim.lsp.buf.format { async = false }
--   end
-- })

-----------------------------------------------------------
-- Key mappings
-----------------------------------------------------------

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Disable arrow keys
map('', '<up>', '<nop>')
map('', '<down>', '<nop>')
map('', '<left>', '<nop>')
map('', '<right>', '<nop>')

-- Move around splits using Ctrl + {h,j,k,l}
map('n', '<C-h>', '<C-w>h', { desc = 'Focus window left' })
map('n', '<C-j>', '<C-w>j', { desc = 'Focus window down' })
map('n', '<C-k>', '<C-w>k', { desc = 'Focus window up' })
map('n', '<C-l>', '<C-w>l', { desc = 'Focus window right' })

-- Map 'esc' to kk
map('i', 'kk', '<Esc>', { desc = 'Escape' })
-- Quit
map('n', '<leader>qq', ':qa!<cr>', { desc = 'Quit' })
-- Write buffer
map('n', '<leader>w', ':w<cr>', { desc = 'Write buffer' })
-- Write all buffers
map('n', '<leader>ww', ':wa<cr>', { desc = 'Write all buffers' })
-- Close (destroy) buffer
map('n', '<leader>bd', ':bd<cr>')
-- Select all text in current buffer
map('n', '<leader>a', ':keepjumps normal! ggVG<cr>')
-- Toggle show whitespace
map('n', '<leader>ws', ':set list!<cr>', { desc = 'Toggle show whitespace' })
-- Toggle search highlight
map('n', '<leader>hl', ':set hlsearch! hlsearch?<cr>')
-- Toggle inline diagnostics messages
map('n', '<leader>dh', ':DiagnosticsToggleVirtualText<cr>', { desc = 'Toggle inline diagnostics' })
-- Toggle relative/absolute line numbers
map('n', '<leader>ln', ':set relativenumber!<cr>', { desc = 'Toggle relative line numbers' })

-----------------------------------------------------------
-- Key mappings: Plugins
-----------------------------------------------------------

-- Telescope
map('n', '<leader>ff', '<cmd>:Telescope find_files<cr>')
map('n', '<leader>fg', ':lua require("telescope").extensions.live_grep_args.live_grep_args()<cr>')
map('n', '<leader>fu', '<cmd>:Telescope buffers<cr>')
map('n', '<leader>gf', '<cmd>:Telescope git_files<cr>')
map('n', '<leader>fb', '<cmd>:Telescope file_browser<cr>')

-- gitsigns
map('n', '<leader>gs', '<cmd>:Gitsigns<cr>')
map('n', '<leader>hs', '<cmd>:Gitsigns stage_hunk<cr>')
map('n', '<leader>hr', '<cmd>:Gitsigns reset_hunk<cr>')
map('n', '<leader>hp', '<cmd>:Gitsigns preview_hunk<cr>')
map('n', '<leader>tb', '<cmd>:Gitsigns toggle_current_line_blame<cr>')
map('n', '<leader>bl', '<cmd>:Gitsigns blame_line<cr>')

-- Trouble
map('n', '<leader>xx', '<cmd>TroubleToggle<cr>')
map('n', '<leader>xw', '<cmd>TroubleToggle workspace_diagnostics<cr>')
map('n', '<leader>xd', '<cmd>TroubleToggle document_diagnostics<cr>')
map('n', '<leader>xl', '<cmd>TroubleToggle loclist<cr>')
map('n', '<leader>xq', '<cmd>TroubleToggle quickfix<cr>')
map('n', 'gR', '<cmd>TroubleToggle lsp_references<cr>')
map('n', 'gY', '<cmd>TroubleToggle lsp_type_definitions<cr>')
map('n', 'gD', '<cmd>TroubleToggle lsp_definitions<cr>')

-- LazyGit
map('n', 'Lg', '<cmd>LazyGit<cr>')

-- indent-blankline
map('n', '<leader>it', '<cmd>IBLToggle<cr>')

-- Oil
map('n', '<leader>o', '<cmd>Oil<cr>')

-- local-highlight
map('n', '<leader>lh', '<cmd>:LocalHighlightToggle<cr>', { desc = 'Toggle local highlighting of word under cursor' })
