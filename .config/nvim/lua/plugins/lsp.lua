-- ~/.config/nvim/lua/plugins/lsp.lua
-- Language-Server-Setup fuer clangd ueber die moderne vim.lsp.config-API
-- ## 2026-09-11 SARBS
return {
  "neovim/nvim-lspconfig",
  config = function()
    -- Moderne API (Nvim 0.11+): require("lspconfig").X.setup() ist deprecated
    vim.lsp.config("clangd", {
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--completion-style=detailed",
        "--header-insertion=iwyu",
      },
      init_options = {
        fallbackFlags = { "-std=c11" }, -- Standardmäßig C11 für Lernprojekte nutzen
      },
    })

    -- Server aktivieren
    vim.lsp.enable("clangd")
  end,
}