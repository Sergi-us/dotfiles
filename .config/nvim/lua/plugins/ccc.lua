return{
  "uga-rosa/ccc.nvim",
  cmd = { "CccPick", "CccConvert", "CccHighlighterEnable", "CccHighlighterToggle" },
  keys = {
    { "<leader>c", "<cmd>CccPick<CR>", desc = "Pick color" },
  },
  config = function()
    local ccc = require("ccc")
    ccc.setup({
      highlighter = {
        auto_enable = false,
        lsp = true,
      }
    })
  end,
}
