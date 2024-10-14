require "custom.fold_settings"
local utils = require "custom.init_utils"

-- NEOVIM OPTIONS
local opt = vim.opt
opt.relativenumber = true

-- VIM GLOBAL VARIABLES
-- Set the default `sh.vim` syntax to be POSIX-compliant instead of being Bourne shell syntax
vim.g.is_posix = 1

-- AUTOCOMMANDS
-- Open nvim-tree on startup
vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = utils.open_nvim_tree })

-- USER COMMANDS
vim.api.nvim_create_user_command("ListCharsToggle", utils.list_chars_toggle, {
  desc = "Toggle on markers for whitespaces and EOL",
})
-- Ergonomic help page access
vim.api.nvim_create_user_command('Help', 'vertical help <args>', { nargs = '*' })
vim.api.nvim_create_user_command('H', 'vertical help <args>', { nargs = '*' })
vim.api.nvim_create_user_command('Oh', 'help <args> | only', { nargs = '*' })
-- Close all buffers except the current one. (1. close all buffers; 2. edit the last
-- opened buffer; 3. close the unnamed buffer created after step 1)
vim.api.nvim_create_user_command('Bdo', '%bd | e# | bd#', {})

