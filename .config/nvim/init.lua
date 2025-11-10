-- init.lua
-- ## 2025-07-04 SARBS

--  === === === === === === === === === === === === === === === === === === ===
-- ===                   SERGI Neovim-Konfiguration                          ===
-- ===                   https://sarbs.xyz                                   ===
-- ===                                                                       ===
-- ===                   TODO    umstieg auf lua                             ===
-- ===                   TODO    Tabulator Thematik ENDLICH angehen          ===
-- ===                   TODO    snack.nvim                                  ===
--  === === === === === === === === === === === === === === === === === === ===

-- Lazy.nvim Bootstrap (Selbstinstallation)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

-- das Verzeichnis von lazy.nvim dem "runtime path" (rtp) von Neovim hinzu
vim.opt.rtp:prepend(lazypath)

-- Bevorzuge unix, erkenne aber auch dos
vim.opt.fileformats = "unix,dos"

-- Grundlegende Neovim Konfiguration
vim.g.mapleader = " "      -- Space als Leader-Taste
vim.g.maplocalleader = "," -- Komma als lokale Leader-Taste

-- Initialisiere Lazy.nvim mit Plugins
-- Die anderen Konfigurationen laden wir erst NACH der Lazy-Initialisierung
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
  print("Lazy.nvim konnte nicht geladen werden!")
  return
end

lazy.setup({
  spec = {
    -- Importiere alle Plugins aus dem plugins/ Verzeichnis.
    -- oder trage sie hier einzeln ein
    { import = "plugins" },
  },
  -- Standard einstellungen für alle Plugins

  defaults = {
    lazy = false,     -- Ob Plugins standardmäßig lazy-loaded werden sollen
    version = nil,    -- Plugin-Version verwenden (kann auch "*" für aktuellste Version sein)
    cond = nil,       ---@type boolean|fun(self:LazyPlugin):boolean|nil
  },

  lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json", -- Lockfile, das nach dem Ausführen von update generiert wird.
                      ---@type number? begrenzt die maximale Anzahl gleichzeitiger Tasks
  concurrency = jit.os:find("Windows") and (vim.uv.available_parallelism() * 2) or nil,

  git = {
    -- Standardwerte für den Befehl `Lazy log`
    -- log = { "--since=3 days ago" }, -- zeige Commits der letzten 3 Tage
    log = { "-4" }, -- zeige die letzten 8 Commits
    timeout = 120, -- beende Prozesse, die länger als 2 Minuten dauern
    url_format = "https://github.com/%s.git",
    -- lazy.nvim benötigt Git >=2.19.0. Wenn du wirklich lazy mit einer älteren Version verwenden möchtest,
    -- setze unten auf false. Dies sollte funktionieren, ist aber NICHT unterstützt und wird
    -- Downloads stark erhöhen.
    filter = true,
    -- Rate der netzwerkbezogenen Git-Operationen (clone, fetch, checkout)
    throttle = {
      enabled = false, -- standardmäßig nicht aktiviert
      -- maximal 2 Operationen alle 5 Sekunden
      rate = 2,
      duration = 5 * 1000, -- in ms
    },
    -- Zeit in Sekunden, die gewartet werden soll, bevor ein Fetch für ein Plugin erneut ausgeführt wird.
    -- Wiederholte Update/Check-Operationen werden nicht erneut ausgeführt, bis diese
    -- Abkühlungszeit verstrichen ist.
    cooldown = 0,
  },

  pkg = {
    enabled = true,
    cache = vim.fn.stdpath("state") .. "/lazy/pkg-cache.lua",
    -- die erste Paketquelle, die für ein Plugin gefunden wird, wird verwendet.
    sources = {
      "lazy",
      "rockspec", -- wird nur verwendet, wenn rocks.enabled true ist
      "packspec",
    },
  },

  rocks = {
    enabled = true,
    root = vim.fn.stdpath("data") .. "/lazy-rocks",
    server = "https://nvim-neorocks.github.io/rocks-binaries/",
    -- hererocks verwenden, um luarocks zu installieren?
    -- auf `nil` setzen, um hererocks zu verwenden, wenn luarocks nicht gefunden wird
    -- auf `true` setzen, um immer hererocks zu verwenden
    -- auf `false` setzen, um immer luarocks zu verwenden
    hererocks = nil,
  },

  dev = {
    -- Verzeichnis, in dem du deine lokalen Plugin-Projekte speicherst. Wenn eine Funktion verwendet wird,
    -- muss das Plugin-Verzeichnis (z.B. `~/projects/plugin-name`) zurückgegeben werden.
    ---@type string | fun(plugin: LazyPlugin): string
    path = "~/projects",
    ---@type string[] Plugins, die diesen Mustern entsprechen, verwenden deine lokalen Versionen anstatt von GitHub abgerufen zu werden
    patterns = {}, -- Zum Beispiel {"folke"}
    fallback = false, -- Fallback zu Git, wenn lokales Plugin nicht existiert
  },

  install = {
    -- fehlende Plugins beim Start installieren. Dies erhöht die Startzeit nicht.
    missing = true,
    -- versuchen, eines dieser Farbschemata zu laden, wenn eine Installation während des Starts begonnen wird
    colorscheme = { "tokyonight", "habamax" },
  },

  ui = {
    -- eine Zahl <1 ist ein Prozentsatz, >1 ist eine feste Größe
    size = { width = 0.8, height = 0.8 },
    wrap = true, -- Zeilen in der UI umbrechen
    -- Der Rahmen für das UI-Fenster. Akzeptiert die gleichen Rahmenwerte wie |nvim_open_win()|.
    border = "none",
    -- Die Backdrop-Deckkraft. 0 ist vollständig undurchsichtig, 100 ist vollständig transparent.
    backdrop = 60,
    title = nil, ---@type string funktioniert nur, wenn der Rahmen nicht "none" ist
    title_pos = "center", ---@type "center" | "left" | "right"
    -- Pills am oberen Rand des Lazy-Fensters anzeigen
    pills = true, ---@type boolean
    icons = {
      cmd = " ",
      config = "",
      debug = "● ",
      event = " ",
      favorite = " ",
      ft = " ",
      init = " ",
      import = " ",
      keys = " ",
      lazy = "󰒲 ",
      loaded = "●",
      not_loaded = "○",
      plugin = " ",
      runtime = " ",
      require = "󰢱 ",
      source = " ",
      start = " ",
      task = "✔ ",
      list = {
        "●",
        "➜",
        "★",
        "‒",
      },
    },
    browser = nil, ---@type string?
    throttle = 1000 / 30, -- wie oft die UI Render-Events verarbeiten soll
    custom_keys = {
      -- Du kannst hier benutzerdefinierte Tastenkombinationen definieren. Falls vorhanden, wird die Beschreibung
      -- im Hilfe-Menü angezeigt.
      -- Um eine der Standardeinstellungen zu deaktivieren, setze sie auf false.
      ["<localleader>l"] = {
        function(plugin)
          require("lazy.util").float_term({ "lazygit", "log" }, {
            cwd = plugin.dir,
          })
        end,
        desc = "Öffne lazygit log",
      },
      ["<localleader>i"] = {
        function(plugin)
          Util.notify(vim.inspect(plugin), {
            title = "Inspiziere " .. plugin.name,
            lang = "lua",
          })
        end,
        desc = "Plugin inspizieren",
      },
      ["<localleader>t"] = {
        function(plugin)
          require("lazy.util").float_term(nil, {
            cwd = plugin.dir,
          })
        end,
        desc = "Terminal im Plugin-Verzeichnis öffnen",
      },
    },
  }, -- Schließende Klammer für ui

  -- Ausgabeoptionen für den Headless-Modus
  headless = {
    -- Ausgabe von Prozessbefehlen wie git anzeigen
    process = true,
    -- Log-Nachrichten anzeigen
    log = true,
    -- Task-Start/Ende anzeigen
    task = true,
    -- ANSI-Farben verwenden
    colors = true,
  },

  diff = {
    -- Diff-Befehl <d> kann einer der folgenden sein:
    -- * browser: öffnet die Github-Vergleichsansicht. Beachte, dass dies immer auch auf <K> gemappt ist,
    --   so dass du einen anderen Befehl für diff <d> haben kannst
    -- * git: führt git diff aus und öffnet einen Buffer mit Dateityp git
    -- * terminal_git: öffnet ein Pseudo-Terminal mit git diff
    -- * diffview.nvim: öffnet Diffview, um den Diff anzuzeigen
    cmd = "git",
  },

  -- automatisch nach Plugin-Updates suchen
  checker = {
    enabled = false,
    concurrency = nil, ---@type number? auf 1 setzen, um sehr langsam nach Updates zu suchen
    notify = true, -- eine Benachrichtigung erhalten, wenn neue Updates gefunden werden
    frequency = 3600, -- stündlich nach Updates suchen
    check_pinned = false, -- nach gepinnten Paketen suchen, die nicht aktualisiert werden können
  },

  -- automatisch nach Änderungen in der Konfigurationsdatei suchen und die UI neu laden
  change_detection = {
    enabled = true,
    notify = true, -- eine Benachrichtigung erhalten, wenn Änderungen gefunden werden
  },

  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true, -- den Paketpfad zurücksetzen, um die Startzeit zu verbessern
    rtp = {
      reset = true, -- den Runtime-Pfad auf $VIMRUNTIME und dein Konfigurationsverzeichnis zurücksetzen
      ---@type string[]
      paths = {}, -- füge hier alle benutzerdefinierten Pfade hinzu, die du in den rtp aufnehmen möchtest
      ---@type string[] liste hier alle Plugins auf, die du deaktivieren möchtest
      disabled_plugins = {
        -- "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        -- "tarPlugin",
        -- "tohtml",
        -- "tutor",
        -- "zipPlugin",
      },
    },
  },
  -- lazy kann Helptags aus den Überschriften in Markdown-README-Dateien generieren,
  -- sodass :help auch für Plugins funktioniert, die keine vim-Dokumentation haben.
  -- wenn die README mit :help geöffnet wird, wird sie korrekt als Markdown angezeigt
  readme = {
    enabled = true,
    root = vim.fn.stdpath("state") .. "/lazy/readme",
    files = { "README.md", "lua/**/README.md" },
    -- nur Markdown-Helptags für Plugins generieren, die keine Dokumentation haben
    skip_if_doc_exists = true,
  },
  state = vim.fn.stdpath("state") .. "/lazy/state.json", -- Zustandsinformationen für checker und andere Dinge
  -- Profiling von lazy.nvim aktivieren. Dies wird etwas Overhead hinzufügen,
  -- also aktiviere dies nur, wenn du lazy.nvim debuggst
  profiling = {
    -- Aktiviert zusätzliche Statistiken auf dem Debug-Tab bezüglich des Loader-Caches.
    -- Sammelt zusätzlich Statistiken über alle package.loaders
    loader = false,
    -- Verfolge jeden neuen require im Lazy-Profiling-Tab
    require = false,
  },
}) -- Schließende Klammer für lazy.setup

-- Lade Benutzereinstellungen VOR dem Theme-Setup
pcall(require, "config.options")      -- Grundlegende Vim-Optionen

-- DANN SARBS Grafische einstellungen
local ok, sarbs = pcall(require, "config.sarbs")
if ok and sarbs then
  sarbs.setup()
end

-- Lade Benutzereinstellungen nach dem Lazy-Setup
-- pcall(require, "config.autocmds")     -- Automatische Befehle
-- pcall(require, "config.shortcuts")    -- Shortcurt integration der Tastenkürzel für vim

-- Lade Benutzereinstellungen automatisch  (alle *.lua Dateien im config/ Ordner laden)
local config_path = vim.fn.stdpath("config") .. "/lua/config"
for _, file in ipairs(vim.fn.glob(config_path .. "/*.lua", false, true)) do
  local module = "config." .. vim.fn.fnamemodify(file, ":t:r")
  pcall(require, module)
end

pcall(require, "config.keymaps")      -- Tastenkombinationen
