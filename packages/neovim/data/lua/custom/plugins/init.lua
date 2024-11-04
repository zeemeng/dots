---@type NvPluginSpec[]
local plugins = {
  -- To make a NvChad default plugin not be loaded
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   enabled = false
  -- },

  -- All NvChad plugins are lazy-loaded by default
  -- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
  -- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
  -- {
  --   "mg979/vim-visual-multi",
  --   lazy = false,
  -- }

  -- Install a plugin
  -- {
  --   "max397574/better-escape.nvim",
  --   event = "InsertEnter",
  --   config = function()
  --     require("better_escape").setup()
  --   end,
  -- },

  -- Override default settings for NvChad default plugins
  require("custom.plugins.mason"),
  require("custom.plugins.treesitter"),
  require("custom.plugins.nvim-tree"),
  require("custom.plugins.lspconfig"),
  require("custom.plugins.telescope"),
  require("custom.plugins.gitsigns"),
}

return plugins

