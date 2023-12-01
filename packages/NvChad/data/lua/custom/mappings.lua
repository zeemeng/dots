---@type MappingsTable
local M = {}

M.disabled = {
  t = {
    -- DISABLE default nvterm toggle mappings
    ["<A-i>"] = "",
    ["<A-h>"] = "",
    ["<A-v>"] = "",
  },

  n = {
    -- DISABLE line number toggles
    ["<leader>n"] = { "<cmd> set nu! <CR>", "Toggle line number" },
    ["<leader>rn"] = { "<cmd> set rnu! <CR>", "Toggle relative number" },

    -- DISABLE default nvterm toggle mappings
    ["<A-i>"] = "",
    ["<A-h>"] = "",
    ["<A-v>"] = "",

    -- DISABLE default NvChad lsp mappings
    ["<leader>ls"] = {
      function()
        vim.lsp.buf.signature_help()
      end,
      "LSP signature help",
    },

    ["<leader>ra"] = {
      function()
        require("nvchad.renamer").open()
      end,
      "LSP rename",
    },

    ["<leader>lf"] = {
      function()
        vim.diagnostic.open_float { border = "rounded" }
      end,
      "Floating diagnostic",
    },

    -- DISABLE default NvChad gitsigns mappings
    ["]c"] = {
      function()
        if vim.wo.diff then
          return "]c"
        end
        vim.schedule(function()
          require("gitsigns").next_hunk()
        end)
        return "<Ignore>"
      end,
      "Jump to next hunk",
      opts = { expr = true },
    },

    ["[c"] = {
      function()
        if vim.wo.diff then
          return "[c"
        end
        vim.schedule(function()
          require("gitsigns").prev_hunk()
        end)
        return "<Ignore>"
      end,
      "Jump to prev hunk",
      opts = { expr = true },
    },

    ["<leader>td"] = {
      function()
        require("gitsigns").toggle_deleted()
      end,
      "Toggle deleted lines (git)",
    },
  },
}

M.nvterm = {
  t = {
    ["<C-_>"] = {
      function()
        require("nvterm.terminal").toggle "float"
      end,
      "Toggle floating term",
    },

    ["<A-\\>"] = {
      function()
        require("nvterm.terminal").toggle "horizontal"
      end,
      "Toggle horizontal term",
    },

    ["<C-\\>"] = {
      function()
        require("nvterm.terminal").toggle "vertical"
      end,
      "Toggle vertical term",
    }
  },

  n = {
    ["<C-_>"] = {
      function()
        require("nvterm.terminal").toggle "float"
      end,
      "Toggle floating term",
    },

    ["<A-\\>"] = {
      function()
        require("nvterm.terminal").toggle "horizontal"
      end,
      "Toggle horizontal term",
    },

    ["<C-\\>"] = {
      function()
        require("nvterm.terminal").toggle "vertical"
      end,
      "Toggle vertical term",
    }
  },
}

M.lspconfig = {
  n = {
    ["<leader>ss"] = {
      function()
        vim.lsp.buf.signature_help()
      end,
      "Show LSP signature help",
    },

    ["<leader>re"] = {
      function()
        require("nvchad.renamer").open()
      end,
      "LSP rename symbol",
    },

    ["<leader>fd"] = {
      function()
        vim.diagnostic.open_float { border = "rounded" }
      end,
      "Floating diagnostic",
    },

    ["[d"] = {
      function()
        vim.diagnostic.goto_prev { float = { border = "rounded" } }
      end,
      "Go to previous diagnostic",
    },

    ["]d"] = {
      function()
        vim.diagnostic.goto_next { float = { border = "rounded" } }
      end,
      "Go to next diagnostic",
    },
  }
}

M.gitsigns = {
  n = {
    -- Navigate through Git hunks
    ["]g"] = {
      function()
        if vim.wo.diff then
          return "]g"
        end
        vim.schedule(function()
          require("gitsigns").next_hunk()
        end)
        return "<Ignore>"
      end,
      "Jump to next git hunk",
      opts = { expr = true },
    },

    ["[g"] = {
      function()
        if vim.wo.diff then
          return "[g"
        end
        vim.schedule(function()
          require("gitsigns").prev_hunk()
        end)
        return "<Ignore>"
      end,
      "Jump to prev git hunk",
      opts = { expr = true },
    },

    -- Preview and view Git hunks and diffs
    ["<leader>ph"] = {
      function()
        require("gitsigns").preview_hunk()
      end,
      "Preview git hunk",
    },

    ["<leader>ih"] = {
      function()
        require("gitsigns").preview_hunk_inline()
      end,
      "Preview git hunk inline",
    },

    ["<leader>gd"] = {
      function ()
        require("gitsigns").toggle_linehl()
        require("gitsigns").toggle_deleted()
      end,
      "Show diff in buffer (git)",
    },

    ["<leader>vd"] = {
      function()
        require("gitsigns").diffthis()
      end,
      "Perform |vimdiff| on current file"
    },

    -- Operate on Git hunks
    ["<leader>sh"] = {
      function()
        require("gitsigns").stage_hunk()
      end,
      "Stage the hunk under the cursor"
    },

    ["<leader>uh"] = {
      function()
        require("gitsigns").undo_stage_hunk()
      end,
      "Undo the last stage hunk operation"
    },

    ["<leader>sb"] = {
      function()
        require("gitsigns").stage_buffer()
      end,
      "Stage all hunks in the current buffer"
    },

    ["<leader>ub"] = {
      function()
        require("gitsigns").reset_buffer_index()
      end,
      "Unstage all hunks in the current buffer"
    },

    ["<leader>rh"] = {
      function()
        require("gitsigns").reset_hunk()
      end,
      "Revert the hunk under the cursor (discard changes)",
    },

    ["<leader>rb"] = {
      function()
        require("gitsigns").reset_buffer()
      end,
      "Revert all hunks in the current buffer (discard changes)",
    }
  }
}

M.telescope = {
  n = {
    ["<leader>tt"] = { "<cmd> Telescope themes <CR>", "Nvchad theme picker" },

    ["<leader>th"] = { "<cmd> Telescope highlights <CR>", "Look up highlight groups" },

    ["<leader>gs"] = { "<cmd> Telescope git_status <CR>", "Git status" },
  }
}

M.general = {
  n = {
    [";"] = { ":", "Enter command mode", opts = { nowait = true } },

    ["<Leader>0"] = { "$", "Go to end of line" },
  },
}

return M

