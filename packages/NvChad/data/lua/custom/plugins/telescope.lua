local actions = require "telescope.actions"

-- Lifted from: https://github.com/nvim-telescope/telescope.nvim/issues/1048#issuecomment-2142669167
local select_one_or_multi = function(prompt_bufnr)
  local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
  local multi = picker:get_multi_selection()
  if not vim.tbl_isempty(multi) then
    actions.close(prompt_bufnr)
    for _, j in pairs(multi) do
      if j.path ~= nil then
        if j.lnum ~= nil then
          vim.cmd(string.format("%s +%s %s", "edit", j.lnum, j.path))
        else
          vim.cmd(string.format("%s %s", "edit", j.path))
        end
      end
    end
  else
    actions.select_default(prompt_bufnr)
  end
end

local send_to_qflist_and_open = function(prompt_bufnr)
  actions.send_selected_to_qflist(prompt_bufnr)
  actions.open_qflist(prompt_bufnr)
  vim.cmd(":cfirst")
end

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

          -- Use tab to only move the selector and use <C-s> to toggle marker/selection
          ["<Tab>"] = actions.move_selection_worse,
          ["<S-Tab>"] = actions.move_selection_better,
          ["<C-s>"] = actions.toggle_selection,
          ["<C-q>"] = send_to_qflist_and_open,

          -- Mapping <C-m> interferes with <CR> action. Bug report filed at upstream.
          -- https://github.com/nvim-telescope/telescope.nvim/issues/3246
          -- ["<C-m>"] = actions.toggle_selection,
          ["<CR>"] = select_one_or_multi,
        },

        n = {
          -- Scroll the preview window
          ["<C-j>"] = actions.preview_scrolling_down,
          ["<C-k>"] = actions.preview_scrolling_up,
          ["<C-h>"] = actions.preview_scrolling_left,
          ["<C-l>"] = actions.preview_scrolling_right,

          -- Use tab to only move the selector and use <C-s> to toggle marker/selection
          ["<Tab>"] = actions.move_selection_worse,
          ["<S-Tab>"] = actions.move_selection_better,
          ["<C-s>"] = actions.toggle_selection,
          ["s"] = actions.toggle_selection,
          ["<C-q>"] = send_to_qflist_and_open,
          ["q"] = send_to_qflist_and_open,

          -- Mapping <C-m> interferes with <CR> action. Bug report filed at upstream.
          -- https://github.com/nvim-telescope/telescope.nvim/issues/3246
          -- ["<C-m>"] = actions.toggle_selection,
          ["<CR>"] = select_one_or_multi,
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
