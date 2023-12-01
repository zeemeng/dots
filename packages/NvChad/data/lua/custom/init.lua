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

