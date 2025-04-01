return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    require("nvim-autopairs").setup({
      check_ts = true,
      ts_config = {
        lua = {'string'},
        javascript = {'template_string'},
      }
    })
    -- Für die Klammerhervorhebung
    local npairs = require("nvim-autopairs")
    npairs.setup({
      highlight_pair_events = {"CursorMoved"}, -- oder {"CursorMoved", "InsertEnter"}
      highlight_pair = true,
    })
  end,
}
