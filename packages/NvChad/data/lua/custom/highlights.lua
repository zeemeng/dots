-- To find any highlight groups: "<cmd> Telescope highlights"
-- Each highlight group can take a table with variables fg, bg, bold, italic, etc
-- base30 variable names can also be used as colors

local M = {}

---@type Base46HLGroupsList
M.override = {
  Comment = {
    italic = true,
  },
}

---@type HLTable
M.add = {
  -- Signs and gutter elements
  GitSignsAdd = { fg = "green" },
  GitSignsChange = { fg = "yellow" },
  GitSignsDelete = { fg = "red" },

  -- Buffer line colors
  GitSignsAddLn = {
    fg = "NONE",
    bg = { "green", -45 },
  },
  GitSignsChangeLn = {
    fg = "NONE",
    bg = { "green", -45 },
  },
  GitSignsDeleteVirtLn = {
    fg = "white",
    bg = { "red", -30 },
  },

  -- Preview window line colors
  GitSignsAddPreview = {
    fg = "green",
  },
  GitSignsDeletePreview = {
    fg = "red",
  },

  -- Other
  GitSignsAddInline = {
    link = "GitSignsAddLn"
  },
  GitSignsChangeInline = {
    link = "GitSignsChangeLn"
  },
  GitSignsDeleteInline = {
    link = "GitSignsDeleteVirtLn"
  }
}

return M

