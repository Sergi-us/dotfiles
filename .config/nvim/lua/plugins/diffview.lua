return {
  "sindrets/diffview.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- Optional für Icons
  },
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewFileHistory"
  },
  keys = {
    { "<leader>dv", "<cmd>DiffviewOpen<CR>", desc = "Open Diffview" },
    { "<leader>dh", "<cmd>DiffviewFileHistory<CR>", desc = "Diffview File History" },
  },
  config = function()
    require("diffview").setup({
      enhanced_diff_hl = true,  -- Verbesserte Syntax-Hervorhebung für Diffs
      git_cmd = { "git" },      -- Git-Kommando
    })
  end,
}
