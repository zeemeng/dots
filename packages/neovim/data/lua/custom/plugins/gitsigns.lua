return {
  "lewis6991/gitsigns.nvim",
  opts = {
    signs = {
      -- delete = { text = "─" },
      -- delete = { text = "━" },
      delete = { text = "│" },
      untracked    = { text = '┆' },
    },

    -- Options below are for enabling inline diffs, but feature does not seem to work as expected..
    -- diff_opts = {
    --   internal = true,
    -- },
    -- word_diff = true,
  },
}
