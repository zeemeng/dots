local file_info = function()
  local config = require("core.utils").load_config().ui.statusline
  local sep_style = config.separator_style

  local default_sep_icons = {
    default = { left = "", right = "" },
    round = { left = "", right = "" },
    block = { left = "█", right = "█" },
    arrow = { left = "", right = "" },
  }

  local separators = (type(sep_style) == "table" and sep_style) or default_sep_icons[sep_style]
  local sep_l = separators["left"]
  local sep_r = separators["right"]

  local path = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(vim.g.statusline_winid))
  local rel_path = vim.fn.expand("%:.")

  local segments = {}
  local seg_last
  for seg in rel_path:gmatch("([^/\\]+)/?") do
    seg_last = seg
    table.insert(segments, seg:sub(1, math.min(#seg, 3)))
  end
  table.remove(segments)
  table.insert(segments, seg_last)

  local trimmed_path = table.concat(segments, "/")
  local label = path == "" and "Empty" or trimmed_path

  local icon = " 󰈚 "
  if label ~= "Empty" then
    local devicons_present, devicons = pcall(require, "nvim-web-devicons")

    if devicons_present then
      local ft_icon = devicons.get_icon(label)
      icon = (ft_icon ~= nil and " " .. ft_icon .. " ") or icon
    end
  end

  label = " " .. label .. " "
  return "%#St_file_info#" .. icon .. label .. "%#St_file_sep#" .. sep_r
end

local file_type = function ()
  local ft = vim.bo.filetype
  -- local label = "%#St_file_info# [" .. vim.bo.filetype:upper() .. "]" -- insert at pos 2
  -- local label = "%#St_LspStatus# [" .. vim.bo.filetype:upper() .. "]%#St_no_exists#" -- insert at pos 3
  local label = "%#St_gitIcons# " .. vim.bo.filetype:upper() .. " %#St_no_exists#" -- insert at pos 3
  return ft == "" and ft or label
end

-- Path to overriding theme and highlights files
local highlights = require "custom.highlights"

---@type ChadrcConfig
local M = {}

M.ui = {
  theme = "nightfox",
  theme_toggle = { "nightfox", "one_light" },

  lsp_semantic_tokens = true,

  hl_override = highlights.override,
  hl_add = highlights.add,

  nvdash = {
    load_on_startup = true
  },

  statusline = {
    -- modules arg here is the default table of modules
    overriden_modules = function(modules)
      -- replace the default file info of only file name with relative path
      modules[2] = file_info()

      local ft_label = file_type()
      local git_label = modules[3]
      -- add file type indicator
      table.insert(modules, 3, (git_label == '' or ft_label == '') and file_type() or file_type() .. '|')

      -- add current line and column numbers
      table.insert(modules, "| L %-2l | C %-2c ")
    end,
  },
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require "custom.mappings"

return M

