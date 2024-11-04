---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require "custom.highlights"

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
      table.insert(modules, "| L %-2l | C %-2c ")
    end,
  },
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require "custom.mappings"

return M

