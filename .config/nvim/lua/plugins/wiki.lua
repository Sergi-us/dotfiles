return {
    -- VimWiki
    "vimwiki/vimwiki",
    event = "VeryLazy",
    keys = {
      { "<leader>v", ":VimwikiIndex<CR>", desc = "Wiki Index", noremap = true, silent = true },
      { "<leader>ws", ":VimwikiUISelect<CR>", desc = "Wiki UI Select", noremap = true, silent = true },
    },
    config = function()
      -- Hier kannst du deine VimWiki Konfiguration einfügen
      -- Beispiel:
      vim.g.vimwiki_list = {
        {
          path = '~/vimwiki/',
          syntax = 'markdown',
          ext = '.md',
        }
      }
    end
  }
