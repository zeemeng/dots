local actions = require "telescope.actions"

return {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      mappings = {
        i = {
          -- Scroll the preview window
          ["<C-j>"] = actions.preview_scrolling_down,
          ["<C-k>"] = actions.preview_scrolling_up,
          ["<C-h>"] = actions.preview_scrolling_left,
          ["<C-l>"] = actions.preview_scrolling_right,

          -- Use tab to only move the selector and use <C-m> to toggle marker/selection
          ["<Tab>"] = actions.move_selection_worse,
          ["<S-Tab>"] = actions.move_selection_better,
          ["<C-m>"] = actions.toggle_selection,
          ["<C-s>"] = actions.toggle_selection,

          -- Fixes issue where mapping `actions.toggle_selection` unmaps `actions.select_default`. Should tell maintainers
          ["<CR>"] = actions.select_default,
        },

        n = {
          -- Scroll the preview window
          ["<C-j>"] = actions.preview_scrolling_down,
          ["<C-k>"] = actions.preview_scrolling_up,
          ["<C-h>"] = actions.preview_scrolling_left,
          ["<C-l>"] = actions.preview_scrolling_right,

          -- Use tab to only move the selector and use <C-m> to toggle marker/selection
          ["<Tab>"] = actions.move_selection_worse,
          ["<S-Tab>"] = actions.move_selection_better,
          ["<C-m>"] = actions.toggle_selection,
          ["<C-s>"] = actions.toggle_selection,

          -- Fixes issue where mapping `actions.toggle_selection` unmaps `actions.select_default`. Should tell maintainers
          ["<CR>"] = actions.select_default,
        },
      },
    },
    pickers = {
      buffers = {
        mappings = {
          i = {
            ["<C-d>"] = actions.delete_buffer,
          },

          n = {
            ["<C-d>"] = actions.delete_buffer,
          },
        },
      },
    },
  },
}
