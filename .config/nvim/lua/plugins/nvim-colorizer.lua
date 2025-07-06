return{
  "norcalli/nvim-colorizer.lua",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("colorizer").setup({
      "*", -- Aktiviert für alle Dateitypen
      css = { css = true; }, -- CSS-spezifische Optionen
      html = { css = true; }, -- CSS in HTML aktivieren
    })
  end,
}
