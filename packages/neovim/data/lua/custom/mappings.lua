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
    ["<tab>"] = { "", "Goto next buffer" },

    -- DISABLE line number toggles
    ["<leader>n"] = { "", "Toggle line number" },
    ["<leader>rn"] = { "", "Toggle relative number" },

    -- DISABLE default nvterm toggle mappings
    ["<A-i>"] = "",
    ["<A-h>"] = "",
    ["<A-v>"] = "",
    ["<leader>h"] = { "", "New horizontal term" },
    ["<leader>v"] = { "", "New vertical term" },

    -- DISABLE default NvChad telescope mappings
    ["<leader>cm"] = { "<cmd> Telescope git_commits <CR>", "Git commits" },
    ["<leader>gt"] = { "<cmd> Telescope git_status <CR>", "Git status" },
    ["<leader>pt"] = { "<cmd> Telescope terms <CR>", "Pick hidden term" },

    -- DISABLE default NvChad lsp mappings
    ["<leader>ls"] = { "", "LSP signature help" },
    ["<leader>ra"] = { "", "LSP rename" },
    ["<leader>lf"] = { "", "Floating diagnostic" },

    -- DISABLE default NvChad gitsigns mappings
    ["]c"] = { "", "Jump to next hunk" },
    ["[c"] = { "", "Jump to prev hunk" },
    ["<leader>td"] = { "", "Toggle deleted lines (git)" },
    ["<leader>ph"] = { "", "Preview hunk" },
  },
}

M.nvterm = {
  t = {
    ["<C-_>"] = {
      function() require("nvterm.terminal").toggle "float" end,
      "Toggle floating term",
    },

    ["<A-\\>"] = {
      function() require("nvterm.terminal").toggle "horizontal" end,
      "Toggle horizontal term",
    },

    ["<C-\\>"] = {
      function() require("nvterm.terminal").toggle "vertical" end,
      "Toggle vertical term",
    }
  },

  n = {
    ["<C-_>"] = {
      function() require("nvterm.terminal").toggle "float" end,
      "Toggle floating term",
    },

    ["<A-\\>"] = {
      function() require("nvterm.terminal").toggle "horizontal" end,
      "Toggle horizontal term",
    },

    ["<C-\\>"] = {
      function() require("nvterm.terminal").toggle "vertical" end,
      "Toggle vertical term",
    },

    ["<leader>H"] = {
      function() require("nvterm.terminal").new "horizontal" end,
      "New horizontal term",
    },

    ["<leader>V"] = {
      function() require("nvterm.terminal").new "vertical" end,
      "New vertical term",
    },
  },
}

M.lspconfig = {
  n = {
    ["<leader>ss"] = {
      function() vim.lsp.buf.signature_help() end,
      "Show LSP signature help",
    },

    ["<leader>re"] = {
      function() require("nvchad.renamer").open() end,
      "LSP rename symbol",
    },

    ["<leader>sd"] = {
      function() vim.diagnostic.open_float { border = "rounded" } end,
      "Show floating diagnostic",
    },

    ["[d"] = {
      function() vim.diagnostic.goto_prev { float = { border = "rounded" } } end,
      "Go to previous diagnostic",
    },

    ["]d"] = {
      function() vim.diagnostic.goto_next { float = { border = "rounded" } } end,
      "Go to next diagnostic",
    },
  }
}

M.gitsigns = {
  n = {
    -- Navigate through Git hunks
    ["]g"] = {
      function()
        if vim.wo.diff then return "]g" end
        vim.schedule(function() require("gitsigns").next_hunk() end)
        return "<Ignore>"
      end,
      "Jump to next git hunk",
      opts = { expr = true },
    },

    ["[g"] = {
      function()
        if vim.wo.diff then return "[g" end
        vim.schedule(function() require("gitsigns").prev_hunk() end)
        return "<Ignore>"
      end,
      "Jump to prev git hunk",
      opts = { expr = true },
    },

    -- Preview and view Git hunks and diffs
    ["<leader>sh"] = {
      function() require("gitsigns").preview_hunk() end,
      "Preview git hunk",
    },

    ["<leader>sih"] = {
      function() require("gitsigns").preview_hunk_inline() end,
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
      function() require("gitsigns").diffthis() end,
      "Perform |vimdiff| on current file"
    },

    -- Operate on Git hunks
    ["<leader>gah"] = {
      function() require("gitsigns").stage_hunk() end,
      "Stage the hunk under the cursor"
    },

    ["<leader>grh"] = {
      function() require("gitsigns").undo_stage_hunk() end,
      "Undo the last stage hunk operation"
    },

    ["<leader>gab"] = {
      function() require("gitsigns").stage_buffer() end,
      "Stage all hunks in the current buffer"
    },

    ["<leader>grb"] = {
      function() require("gitsigns").reset_buffer_index() end,
      "Unstage all hunks in the current buffer"
    },

    ["<leader>gRh"] = {
      function() require("gitsigns").reset_hunk() end,
      "Revert the hunk under the cursor (discard changes)",
    },

    ["<leader>gRb"] = {
      function() require("gitsigns").reset_buffer() end,
      "Revert all hunks in the current buffer (discard changes)",
    }
  }
}

M.tabufline = {
  n = {
    -- cycle through buffers
    ["<leader>n"] = {
      function() require("nvchad.tabufline").tabuflineNext() end,
      "Goto next buffer",
    },

    ["<leader>p"] = {
      function() require("nvchad.tabufline").tabuflinePrev() end,
      "Goto prev buffer",
    },
  }
}

M.telescope = {
  n = {
    ["<C-p>"] = { "<Cmd>Telescope buffers<CR>", "Find buffer using telescope" },
    ["<S-tab>"] = { "<Cmd>Telescope git_files show_untracked=true<CR>", "Find files using telescope" },
    ["<leader>hl"] = { "<cmd> Telescope highlights <CR>", "Look up highlight groups" },
    ["<leader>gs"] = { "<cmd> Telescope git_status <CR>", "Git status" },
    ["<leader>gc"] = { "<cmd> Telescope git_commits <CR>", "Git commits" },
    ["<leader>ft"] = { "<cmd> Telescope terms <CR>", "Pick hidden term" },
  }
}

M.general = {
  ["!"] = {
    ["<C-h>"] = { "<Left>", "Move cursor left", opts = { noremap = true } },
    ["<C-j>"] = { "<Down>", "Move cursor down", opts = { noremap = true } },
    ["<C-k>"] = { "<Up>", "Move cursor up", opts = { noremap = true } },
    ["<C-l>"] = { "<Right>", "Move cursor right", opts = { noremap = true } },

    ["<C-t>"] = { "<End>", "Move cursor to end of line", opts = { noremap = true } },
    ["<C-y>"] = { "<Home>", "Move cursor to begining of line", opts = { noremap = true } },

    ["<C-s>"] = { "<Esc><Cmd>w<CR>", "Write the buffer", opts = { noremap = true } },
  },

  i = {
    ["<C-f>"] = { "<S-Right>", "(ins-mode) Move cursor 1 words forward", opts = { noremap = true } },
    ["<C-b>"] = { "<S-Left>", "(ins-mode) Move cursor 1 words backward", opts = { noremap = true } },
    ["<C-e>"] = { "<Esc>ea", "(ins-mode) Move cursor forward to the end of word N", opts = { noremap = true } },

    ["<C-q>"] = { "<C-o>de", "(ins-mode) Delete word behind the cursor in a UNDOABLE fashion", opts = { noremap = true } },
    ["<C-w>"] = { "<C-g>u<C-w>", "(ins-mode) Delete word in front of the cursor in a UNDOABLE fashion", opts = { noremap = true } },
    ["<C-d>"] = { "<C-o>d$", "(ins-mode) Delete until end of line", opts = { noremap = true } },

    ["<C-c>"] = { "<C-t>", "insert one shiftwidth of indent in the current line", opts = { noremap = true } },
    ["<C-g>"] = { "<C-d>", "delete one shiftwidth of indent in the current line", opts = { noremap = true } },
  },

  c = {
    ["<C-f>"] = { "<S-Right><Right>", "(cmd-mode) Move cursor 1 words forward", opts = { noremap = true } },
    ["<C-b>"] = { "<S-Left>", "(cmd-mode) Move cursor 1 words backward", opts = { noremap = true } },
    ["<C-e>"] = { "<S-Right>", "(cmd-mode) Move cursor forward to the end of word N", opts = { noremap = true } },

    ["<C-q>"] = { "<C-f>de<C-c>", "(cmd-mode) Delete word behind the cursor in a UNDOABLE fashion", opts = { noremap = true } },
    ["<C-d>"] = { "<C-f>d$<C-c>", "(cmd-mode) Delete until end of line", opts = { noremap = true } },
  },

  [""] = {
    ["<C-h>"] = { "<C-w>h", "Move cursor to the left-side window", opts = { noremap = true } },
    ["<C-j>"] = { "<C-w>j", "Move cursor to the downward window", opts = { noremap = true } },
    ["<C-k>"] = { "<C-w>k", "Move cursor to the upward window", opts = { noremap = true } },
    ["<C-l>"] = { "<C-w>l", "Move cursor to the right-side window", opts = { noremap = true } },

    ["U"] = { "d^", "Delete all entered characters in the current line", opts = { noremap = true } },
    ["<Leader>U"] = { "U", "Undo all latest changes on one line", opts = { noremap = true } },

    ["+"] = { "<Cmd>resize +1<CR>", "Increase window height by 1 line", opts = { noremap = true, silent = true } },
    ["_"] = { "<Cmd>resize -1<CR>", "Decrease window height by 1 line", opts = { noremap = true, silent = true } },

    ["<C-q>"] = { "<C-y>", "Scroll [count] lines downwards", opts = { noremap = true } },

    ["<C-x>"] = { "<C-w>", "More accessible 'window commands' prefix", opts = { remap = true } },
    ["<C-w><C-x>"] = { "<C-w><C-w>", "Make typing double <C-x> the same as double <C-w>", opts = { noremap = true } },
    ["<C-w>i"] = { ":vsplit<CR><C-w>l", "Create a vertical split and place the cursor in the new split", opts = { noremap = true } },
    ["<C-w>u"] = { ":split<CR><C-w>j", "Create a horizontal split and place the cursor in the new split", opts = { noremap = true } },
    ["<C-w>D"] = { "<C-w>i", "Split window and jump to declaration of identifier under the cursor", opts = { noremap = true } },

    ["<C-b>"] = { "<Cmd>ls<CR>", "List open buffers", opts = { noremap = true } },
    [";"] = { ":", "Enter command mode", opts = { nowait = true } },
    ["q;"] = { "q:i", "Convenient launching of buffer-like window for editing ex-commands", opts = { noremap = true } },
    ["<C-m>"] = { ";", "Repeat last find character (forward) using <CR> or <C-m>", opts = { noremap = true } },
    ["<C-Space>"] = { "@:", "Repeat the last Ex command", opts = { noremap = true } }, -- Same as <C-@>
    ["<C-s>"] = { "<Cmd>w<CR>", "Write the buffer", opts = { noremap = true } },
  },

  n = {
    ["("] = { "<Cmd>vertical resize +1<CR>", "Increase window width by 1 line", opts = { noremap = true, silent = true } },
    [")"] = { "<Cmd>vertical resize -1<CR>", "Decrease window width by 1 line", opts = { noremap = true, silent = true } },
  },

  t = {
    ["<C-h>"] = { "<C-\\><C-N><C-w>h", "Move cursor to the left-side window", opts = { noremap = true } },
    ["<C-j>"] = { "<C-\\><C-N><C-w>j", "Move cursor to the downward window", opts = { noremap = true } },
    ["<C-k>"] = { "<C-\\><C-N><C-w>k", "Move cursor to the upward window", opts = { noremap = true } },
    ["<C-l>"] = { "<C-\\><C-N><C-w>l", "Move cursor to the right-side window", opts = { noremap = true } },
  },
}

return M

