return {
  "neovim/nvim-lspconfig",
  dependencies = {
    -- format & linting
    require("custom.plugins.null-ls"),
  },

  config = function()
    local default_configs = require "plugins.configs.lspconfig"
    local lspconfig = require "lspconfig"

    -- if you just want default config for the servers then put them in a table
    local servers = { "html", "cssls", "tsserver", "clangd", "emmet_ls" }

    for _, lsp in ipairs(servers) do
      lspconfig[lsp].setup {
        on_attach = default_configs.on_attach,
        capabilities = default_configs.capabilities,
      }
    end

    -- to initialize a language server with custom configs, call its `setup` method separately
    -- lspconfig.pyright.setup { blabla }
  end,
}
