return {
  "nvim-tree/nvim-tree.lua",
  lazy = false,
  opts = {
    git = {
      enable = true,
    },

    renderer = {
      highlight_git = true,
      icons = {
        show = {
          git = true,
        },
      },
    },

    view = {
      width = 25,
    },
  }
}
