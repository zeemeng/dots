local opt = vim.opt

-- Open nvim-tree on startup
local open_nvim_tree = function(data)
  -- buffer is a real file on the disk
  local real_file = vim.fn.filereadable(data.file) == 1

  if real_file then
    -- open the tree, find the file but don't focus it
    require("nvim-tree.api").tree.toggle({ focus = false, find_file = true, })
  end

  -- buffer is a [No Name]
  -- local no_name = data.file == "" and vim.bo[data.buf].buftype == ""
end

-- Toggle markers for whitespaces and EOL
local list_chars_toggle = function ()
  if vim.o.listchars == "" or vim.o.list == false then
    opt.listchars = { space = "_", tab = ">~", eol = "$" }
    opt.list = true
  else
    opt.listchars = ""
    opt.list = false
  end
end

-- AUTOCOMMANDS
-- Open nvim-tree on startup
vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

-- USER COMMANDS
-- Toggle visual markers for whitespaces and EOL
vim.api.nvim_create_user_command("Ws", list_chars_toggle, { desc = "Toggle visual markers for whitespaces and EOL" })

-- Ergonomic help page access
vim.api.nvim_create_user_command('H', 'vertical help <args>', { bar = true, nargs = '*', complete = 'help' })
vim.api.nvim_create_user_command('Ho', 'help <args> | only', { bar = true, nargs = '*', complete = 'help' })
vim.api.nvim_create_user_command('Ht', 'tab help <args>', { bar = true, nargs = '*', complete = 'help' })
vim.api.nvim_create_user_command('Hi', 'vertical help index', {})
vim.api.nvim_create_user_command('Hoi', 'help index | only', {})
vim.api.nvim_create_user_command('Hti', 'tab help index', {})
vim.api.nvim_create_user_command('Hcl', 'helpclose', {})
vim.api.nvim_create_user_command('Hq', 'helpclose', {})

-- Tab management
vim.api.nvim_create_user_command('T', 'tabedit <args>', { bar = true, nargs = '*', complete = 'file' })
vim.api.nvim_create_user_command('Tcl', 'tabclose<bang> <args>', { bang = true, nargs = '?' })
vim.api.nvim_create_user_command('To', 'tabonly<bang> <args>', { bang = true, nargs = '?' })
vim.api.nvim_create_user_command('Tm', 'tabmove <args>', { nargs = '?' })
vim.api.nvim_create_user_command('Tf', 'tabfirst', {})
vim.api.nvim_create_user_command('Tl', 'tablast', {})

-- Close all buffers except the current one. (1. close all buffers; 2. edit the last
-- opened buffer; 3. close the unnamed buffer created after step 1)
vim.api.nvim_create_user_command('Bdo', '%bd | e# | bd#', {})

-- Write file and reedit to refresh syntax highlighting
vim.api.nvim_create_user_command('W', 'w | e', {})

