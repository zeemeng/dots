local M = {}
local opt = vim.opt

-- Open nvim-tree on startup
M.open_nvim_tree = function(data)
  -- buffer is a real file on the disk
  local real_file = vim.fn.filereadable(data.file) == 1

  -- buffer is a [No Name]
  local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

  if not real_file and not no_name then
    return
  end

  -- open the tree, find the file but don't focus it
  require("nvim-tree.api").tree.toggle({ focus = false, find_file = true, })
end

-- Toggle markers for whitespaces and EOL
M.list_chars_toggle = function ()
  if vim.o.listchars == "" or vim.o.list == false then
    opt.listchars = { space = "_", tab = ">~", eol = "$" }
    opt.list = true
  else
    opt.listchars = ""
    opt.list = false
  end
end

return M

