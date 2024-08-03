return {
  "nvim-tree/nvim-tree.lua",
  lazy = false,
  opts = {
    filters = {
      git_ignored = false,
      custom = {
        "^\\.git$"
      },
    },

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
