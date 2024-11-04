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
  actions.smart_send_to_qflist(prompt_bufnr)
  vim.cmd(":cfirst") -- Dirty fix for preventing the first [no name] buffer from being kept as a separate window
  actions.open_qflist(prompt_bufnr)
  vim.cmd(":cfirst")
end

local edit_all = function(prompt_bufnr)
  actions.select_all(prompt_bufnr)
  select_one_or_multi(prompt_bufnr)
end

return {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      mappings = {
        i = {
          -- Mapping <C-m> interferes with <CR> action. Bug report filed at upstream.
          -- https://github.com/nvim-telescope/telescope.nvim/issues/3246
          -- Above issue closed. Problem due to limitation of terminals/term emulators.
          -- Many interpret <C-m> and <CR> as the same keyboard sequence.

          -- Scroll the preview window
          ["<C-j>"] = actions.preview_scrolling_down,
          ["<C-k>"] = actions.preview_scrolling_up,
          ["<C-h>"] = actions.preview_scrolling_left,
          ["<C-l>"] = actions.preview_scrolling_right,

          -- Use tab to only move the selector and use <C-s> to toggle marker/selection
          ["<Tab>"] = actions.move_selection_worse,
          ["<S-Tab>"] = actions.move_selection_better,
          ["<C-s>"] = actions.toggle_selection + actions.move_selection_worse,
          ["<C-c>"] = actions.drop_all,

          -- Operations on selection
          ["<C-q>"] = send_to_qflist_and_open,
          ["<CR>"] = select_one_or_multi,
          ["<C-e>"] = edit_all,
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
          ["<C-s>"] = actions.toggle_selection + actions.move_selection_worse,
          ["s"] = actions.toggle_selection,
          ["<C-c>"] = actions.drop_all,

          -- Operations on selection
          ["<C-q>"] = send_to_qflist_and_open,
          ["q"] = send_to_qflist_and_open,
          ["<CR>"] = select_one_or_multi,
          ["<C-e>"] = edit_all,
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
      git_status = {
        mappings = {
        i = {
          ["<Tab>"] = actions.move_selection_worse,
          ["<S-Tab>"] = actions.move_selection_better,

          ["<C-s>"] = actions.git_staging_toggle,
        },

        n = {
          ["<Tab>"] = actions.move_selection_worse,
          ["<S-Tab>"] = actions.move_selection_better,

          ["<C-s>"] = actions.git_staging_toggle,
          ["s"] = actions.git_staging_toggle,
        },
      }
      }
    },
  },
}
