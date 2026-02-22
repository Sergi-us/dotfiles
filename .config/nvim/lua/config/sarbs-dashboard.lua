-- SARBS Dashboard für NeoVim mit alpha-nvim
-- Diese Datei nach: ~/.config/nvim/lua/config/sarbs-dashboard.lua
-- Plugin-Definition in: ~/.config/nvim/lua/plugins/dashboard.lua

local alpha = require('alpha')
local dashboard = require('alpha.themes.dashboard')

-- Kompaktes SARBS ASCII Logo (80 Zeichen breit, zentriert)
local sarbs_logo = {
    [[                                                                      ]],
    [[      ███████╗ █████╗ ██████╗ ██████╗ ███████╗                        ]],
    [[      ██╔════╝██╔══██╗██╔══██╗██╔══██╗██╔════╝                        ]],
    [[      ███████╗███████║██████╔╝██████╔╝███████╗                        ]],
    [[      ╚════██║██╔══██║██╔══██╗██╔══██╗╚════██║                        ]],
    [[      ███████║██║  ██║██║  ██║██████╔╝███████║                        ]],
    [[      ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚══════╝                        ]],
    [[                                                                      ]],
    [[           Suckless Auto-Rice Bootstrapping Scripts                   ]],
    [[                                                                      ]],
}

dashboard.section.header.val = sarbs_logo

-- Buttons in zwei Spalten - helper function für spacing
local function button(sc, txt, keybind)
    local sc_after = sc:gsub("%s", ""):gsub("SPC", "<leader>")
    local opts = {
        position = "center",
        shortcut = sc,
        cursor = 5,
        width = 36,
        align_shortcut = "right",
        hl_shortcut = "Keyword",
    }

    if keybind then
        opts.keymap = {"n", sc_after, keybind, {noremap = true, silent = true, nowait = true}}
    end

    local btn = dashboard.button(sc, txt, keybind)
    btn.opts = vim.tbl_extend("force", btn.opts, opts)
    return btn
end

-- Buttons - clean einspaltig
local function create_buttons()
    return {
        type = "group",
        val = {
            button("n", "  Neue Datei", ":ene <BAR> startinsert <CR>"),
            button("f", "󰈞  Datei finden", ":Telescope find_files<CR>"),
            button("r", "  Recent Files", ":Telescope oldfiles<CR>"),
            button("g", "  Live Grep", ":Telescope live_grep<CR>"),
            button("c", "  NeoVim Config", ":cd ~/.config/nvim | :e init.lua<CR>"),
            button("d", "  Dotfiles", ":cd ~/.local/src/dotfiles | :e .<CR>"),
            button("s", "  src-Verzeichniss", ":cd ~/.local/src | :e .<CR>"),
            button("z", "  Zsh Config", ":e ~/.config/zsh/.zshrc<CR>"),
            button("u", "  Update Plugins", ":Lazy sync<CR>"),
            button("q", "  Quit", ":qa<CR>"),
        },
        opts = {
            spacing = 0,
        }
    }
end

-- Kompakter Footer
local function get_footer()
    local datetime = os.date("%d.%m.%Y  %H:%M")
    local version = vim.version()
    local nvim_version = "NVIM v" .. version.major .. "." .. version.minor .. "." .. version.patch

    local plugins_loaded = #vim.fn.globpath(vim.fn.stdpath("data") .. "/lazy", "*", 0, 1)
    local plugin_count = plugins_loaded .. " Plugins"

    return {
        "┌────────────────────────────────────────────────────────────┐",
        "│  \"Software wird schlecht durch Hinzufügen, nicht durch     │",
        "│   Entfernen.\"                       - suckless.org         │",
        "└────────────────────────────────────────────────────────────┘",
        "",
        "  " .. datetime .. "  |  " .. nvim_version .. "  |  " .. plugin_count,
        "",
        "  sarbs.xyz  |  https://codeberg.org/Sergius/SARBS",
    }
end

dashboard.section.footer.val = get_footer()

-- Farben
dashboard.section.header.opts.hl = "String"
dashboard.section.footer.opts.hl = "Comment"

-- Kompaktes Layout (max 25 Zeilen)
local layout = {
    { type = "padding", val = 1 },
    dashboard.section.header,
    { type = "padding", val = 1 },
    create_buttons(),
    { type = "padding", val = 1 },
    dashboard.section.footer,
}

alpha.setup({
    layout = layout,
    opts = {
        margin = 5,
        redraw_on_resize = true,
        noautocmd = true,
    },
})

-- Auto-close alpha beim Öffnen einer Datei
vim.api.nvim_create_autocmd("User", {
    pattern = "AlphaReady",
    callback = function()
        vim.opt.showtabline = 0
        vim.opt.laststatus = 0
        vim.opt.cmdheight = 0
    end,
})

vim.api.nvim_create_autocmd("BufUnload", {
    buffer = 0,
    callback = function()
        vim.opt.showtabline = 2
        vim.opt.laststatus = 3
        vim.opt.cmdheight = 1
    end,
})
