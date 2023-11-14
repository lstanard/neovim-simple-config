-------------------------------------
-- Simple, barebones neovim config --
-------------------------------------

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

-- Load plugins
require('lazy').setup(
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 }
)

-- Color scheme
-- Additional configuration options https://github.com/catppuccin/nvim
vim.cmd.colorscheme('catppuccin-macchiato')

-- General options
vim.opt.number = true           -- always show line numbers
vim.opt.scrolloff = 3           -- minimum number of screen lines to keep above and below the cursor
vim.opt.showmatch = true        -- highlight matching brackets
vim.opt.signcolumn = 'yes'      -- always show the sign column
vim.opt.syntax = 'on'           -- enable syntax highlighting

-- Search options
vim.opt.hlsearch = false    -- highlight results of previous search
vim.opt.ignorecase = true   -- ignore uppercase letters when executing search
vim.opt.incsearch = true    -- highlight pattern matches while typing search
vim.opt.smartcase = true    -- make search ignore uppercase letters unless the search term has uppercase
