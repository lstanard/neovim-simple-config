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
vim.opt.cursorline = true       -- highlight current cursorline
vim.opt.errorbells = false      -- disable bell sound for error messages
vim.opt.number = true           -- always show line numbers
vim.opt.relativenumber = true   -- use relative line numbers
vim.opt.scrolloff = 3           -- minimum number of screen lines to keep above and below the cursor
vim.opt.showmatch = true        -- highlight matching brackets
vim.opt.signcolumn = 'yes'      -- always show the sign column
vim.opt.syntax = 'on'           -- enable syntax highlighting

-- Search options
vim.opt.hlsearch = false    -- highlight results of previous search
vim.opt.ignorecase = true   -- ignore uppercase letters when executing search
vim.opt.incsearch = true    -- highlight pattern matches while typing search
vim.opt.smartcase = true    -- make search ignore uppercase letters unless the search term has uppercase

-- Whitespace and indentation
vim.opt.autoindent = true             -- copy indent from current line when starting a new line
vim.opt.breakindent = true            -- preserve indentation of virtual lines
vim.opt.expandtab = true              -- converts tabs to white space
vim.opt.list = false                  -- show whitespace characters
vim.opt.listchars = 'space:·,tab:-→'  -- characters to use for whitespace
vim.opt.shiftwidth = 2                -- width for autoindent
vim.opt.smartindent = true            -- do smart autoindent when starting a new line
vim.opt.softtabstop = 2               -- number of spaces that a <Tab> counts for
vim.opt.tabstop = 2                   -- number of columns occupied by a tab
vim.opt.wrap = true                   -- wrap long lines

-----------------------------------------------------------
-- Key mappings
-----------------------------------------------------------

local function map(mode, lhs, rhs, opts)
  local options = { noremap=true, silent=true }
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
map('n', '<C-h>', '<C-w>h', {desc = 'Focus window left'})
map('n', '<C-j>', '<C-w>j', {desc = 'Focus window down'})
map('n', '<C-k>', '<C-w>k', {desc = 'Focus window up'})
map('n', '<C-l>', '<C-w>l', {desc = 'Focus window right'})

-- Map 'esc' to kk
map('i', 'kk', '<Esc>', {desc = 'Escape'})
-- Quit
map('n', '<leader>qq', ':qa!<cr>', {desc = 'Quit'})
-- Write buffer
map('n', '<leader>w', ':w<cr>', {desc = 'Write buffer'})
-- Write all buffers
map('n', '<leader>ww', ':wa<cr>', {desc = 'Write all buffers'})
-- Toggle show whitespace
map('n', '<leader>ws', ':set list!<cr>', {desc = 'Toggle show whitespace'})

-----------------------------------------------------------
-- Plugin key mappings
-----------------------------------------------------------

-- Telescope
map('n', '<leader>ff', '<cmd>:Telescope find_files<cr>')
map('n', '<leader>fg', '<cmd>:Telescope live_grep<cr>')
map('n', '<leader>fu', '<cmd>:Telescope buffers<cr>')
map('n', '<leader>gf', '<cmd>:Telescope git_files<cr>')
map('n', '<leader>fb', '<cmd>:Telescope file_browser<cr>')

-- gitsigns
map('n', '<leader>hs', '<cmd>:Gitsigns stage_hunk<cr>')
map('n', '<leader>hr', '<cmd>:Gitsigns reset_hunk<cr>')
map('n', '<leader>hp', '<cmd>:Gitsigns preview_hunk<cr>')
map('n', '<leader>tb', '<cmd>:Gitsigns toggle_current_line_blame<cr>')
