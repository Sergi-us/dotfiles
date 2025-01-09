" === === === === === === === === === ~~~ === === === === === === === === ===
" ===                                                                     ===
" ===                  SARBS Neovim-Konfiguration                         ===
" ===                  Letzte Änderung: 27.12.2024                        ===
" ===                  https://sarbs.sergius.xyz                          ===
" ===                                                                     ===
" ===                  TODO    umstieg auf lua                            ===
" ===                  TODO    Gojo fixen                                 ===
" === === === === === === === === === ~~~ === === === === === === === === ===

" === Basis-Einstellungen ===
	let mapleader =","
	set encoding=utf-8
	set mouse=a						" Mausunterstützung in allen Modi
	set title						" Setzt den Fenstertitel
	set go=a						" Aktiviert alle GUI-Optionen
	filetype plugin on				" Aktiviert Dateityp-Plugins
	syntax on						" Aktiviert Syntax-Highlighting
	set clipboard+=unnamedplus		" System-Clipboard Integration
	set nohlsearch					" Deaktiviert Such-Highlighting
	set number relativenumber		" Relative + absolute Zeilennummern
	set wildmode=longest,list,full	" Verbesserte Befehlszeilen-Vervollständigung

" === zusätzliche Bindings in Normal-mode ===
	nnoremap YY ZZ
	nnoremap YQ ZQ
	nnoremap - /

" === Tabs ===
"    nnoremap <leader>tn :tabnew<CR>

" === Plugin Management ===
    " Automatische vim-plug Installation
    if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
        echo "Downloading junegunn/vim-plug to manage plugins..."
        silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
        silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
        autocmd VimEnter * PlugInstall
    endif

    " Plugin-Liste
    call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
        Plug 'tpope/vim-surround'				" Umgebende Zeichen bearbeiten
        Plug 'preservim/nerdtree'				" Dateiexplorer
        Plug 'junegunn/goyo.vim'				" Fokussierter Schreibmodus
        Plug 'jreybert/vimagit'					" Git Integration
        Plug 'vimwiki/vimwiki'					" Persönliches Wiki
        Plug 'vim-airline/vim-airline'			" Statusleiste
        Plug 'vim-airline/vim-airline-themes'	" Airline Themes
        Plug 'tpope/vim-commentary'				" Kommentarfunktionen
        Plug 'ap/vim-css-color'					" Farb-Previews
        Plug 'mechatroner/rainbow_csv'			" CSV-Datei Highlighting
        Plug 'ryanoasis/vim-devicons'           " Entwickler Icons in Vim
    call plug#end()

" Plugin Konfiguration
    let NERDTreeShowHidden = 1
    let g:airline_powerline_fonts = 1
    "let g:airline#extensions#tabline#enabled = 'unique_tail'
    "let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#show_tabs = 1   " Nur Tabs anzeigen, keine Buffers
    let g:airline#extensions#tabline#formatter = 'default'  " Einfache Tab-Anzeige
    "let g:airline_theme = 'dark'
    " Tabline für VimWiki ausblenden
    "autocmd FileType vimwiki let g:airline#extensions#tabline#enabled = 0
    "autocmd FileType vimwiki let g:airline_powerline_fonts = 0



" ===== Visuelle Einstellungen =====
    " Farbschema
    colorscheme vim
    set bg=dark

    " Cursor und Linien-Highlights
    set colorcolumn=80,120
    set cursorline
    set cursorcolumn
    highlight ColorColumn ctermbg=NONE guibg=NONE guifg=#FF0000 gui=underline cterm=underline
    highlight CursorLine ctermbg=234 guibg=#1c1c1c cterm=NONE gui=NONE
    highlight CursorColumn ctermbg=234 guibg=#1c1c1c cterm=NONE gui=NONE

    " Unsichtbare Zeichen
    set list
    set listchars=tab:›\ ,lead:·,trail:·,extends:→,precedes:←,nbsp:␣

" ===== Faltungseinstellungen =====
    set foldmethod=indent		" Faltung basierend auf Einrückung
    set foldnestmax=10            " Maximale Verschachtelungstiefe
    set foldenable                " Aktiviert Faltungen
    set foldminlines=2            " Minimale Zeilenanzahl für Faltung

  " Faltungshervorhebung
  highlight Folded guifg=#BBC2C9 guibg=#262B31 gui=NONE ctermbg=235 ctermfg=250 cterm=NONE
  highlight FoldColumn guifg=#9EA7B3 guibg=#2D333B gui=NONE ctermbg=236 ctermfg=248 cterm=NONE

" ===== Einrückungseinstellungen =====
  set expandtab
  set tabstop=4           " Tab = 4 Spaces
  set shiftwidth=4        " Einrücktiefe
  set softtabstop=4       " Backspace löscht 4 Spaces

" ===== Plugin-Konfigurationen =====
	" VimWiki
	let g:vimwiki_list = [
		\ {'path': '~/.local/share/nvim/vimwiki', 'syntax': 'markdown', 'ext': '.md'},
		\ {'path': '~/.local/share/nvim/sarbs', 'syntax': 'default', 'ext': '.wiki',},
		\ ]
	let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
	let g:vimwiki_text_ignore_newline = 0
	autocmd FileType vimwiki nnoremap <buffer> - /

	" NERDTree
	let NERDTreeBookmarksFile = stdpath('data') . '/NERDTreeBookmarks'

	" vim-airline
		" Aktiviere powerline Symbole und Nerd Fonts
		let g:airline_powerline_fonts = 1

		" Git Integration aktivieren
		let g:airline#extensions#branch#enabled = 1
		let g:airline#extensions#hunks#enabled = 1

"	if !exists('g:airline_symbols')
		let g:airline_symbols = {}
"	endif
"	let g:airline_symbols.colnr = ' C:'
"	let g:airline_symbols.linenr = ' L:'
"	let g:airline_symbols.maxlinenr = '☰ '
"	let g:airline_powerline_fonts = 1

" ===== Tastenkombinationen =====
	" Platzhalter-Navigation
	map ,, :keepp /<++><CR>ca<
	imap ,, <esc>:keepp /<++><CR>ca<

	" Fenster-Navigation
	map <C-h> <C-w>h
	map <C-j> <C-w>j
	map <C-k> <C-w>k
	map <C-l> <C-w>l

	" Plugin-Shortcuts
	map <leader>n :NERDTreeToggle<CR>
	map <leader>f :Goyo \| set bg=dark \| set linebreak<CR>
	map <leader>v :VimwikiIndex<CR>

	" Utility-Shortcuts
	map <leader>o :setlocal spell! spelllang=de_de,en_us<CR>
	map <leader>s :!clear && shellcheck -x %<CR>
	map <leader>b :vsp<space>$BIB<CR>
	map <leader>r :vsp<space>$REFER<CR>
	map <leader>c :w! \| !compiler "%:p"<CR>
	map <leader>p :!opout "%:p"<CR>
	nnoremap S :%s//g<Left><Left>
	nnoremap c "_c                " Löschen ohne Register-Änderung

" ===== Splits und Fenster =====
    set splitbelow splitright     " Natürlicheres Split-Verhalten

" ===== Dateityp-spezifische Einstellungen =====
	augroup FileTypeSpecific
		autocmd!
		" Python: 4 Spaces Einrückung
		autocmd FileType python setlocal expandtab tabstop=4 shiftwidth=4
		" JavaScript: 2 Spaces Einrückung
		autocmd FileType javascript setlocal expandtab tabstop=2 shiftwidth=2
		" Markdown: Marker-basierte Faltung
		autocmd FileType markdown setlocal foldmethod=marker
	augroup END

	" Dateityp-Erkennung
		autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
		autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
		autocmd BufRead,BufNewFile *.tex set filetype=tex
		autocmd BufRead,BufNewFile *.h set filetype=c
		autocmd BufRead,BufNewFile Xresources,Xdefaults,xresources,xdefaults set filetype=xdefaults

" ===== Automatische Aktionen =====
	" Cleanup beim Speichern
	autocmd BufWritePre * let currPos = getpos(".")
	autocmd BufWritePre * %s/\s\+$//e
	autocmd BufWritePre * %s/\n\+\%$//e
	autocmd BufWritePre *.[ch] %s/\%$/\r/e
	autocmd BufWritePre *neomutt* %s/^--$/-- /e
	autocmd BufWritePre * cal cursor(currPos[1], currPos[2])

	" Externe Programme
	autocmd BufWritePost bm-files,bm-dirs !shortcuts
	autocmd BufWritePost Xresources,Xdefaults,xresources,xdefaults !xrdb %
	autocmd BufWritePost ~/.local/src/dwmblocks/config.h !cd ~/.local/src/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid -f dwmblocks }

	" Externe Konfigurationen
    " source ~/.config/nvim/plugin/voidrice.vim

" ===== Spezielle Einstellungen =====
	" Diff-Modus Highlighting
	if &diff
		highlight! link DiffText MatchParen
	endif

	" Goyo für mutt
	autocmd BufRead,BufNewFile /tmp/neomutt* :Goyo 80 | call feedkeys("jk")
	autocmd BufRead,BufNewFile /tmp/neomutt* map ZZ :Goyo!\|x!<CR>
	autocmd BufRead,BufNewFile /tmp/neomutt* map ZQ :Goyo!\|q!<CR>

	" Statusleisten-Toggle Funktion
	let s:hidden_all = 0
	function! ToggleHiddenAll()
		if s:hidden_all == 0
			let s:hidden_all = 1
			set noshowmode
			set noruler
			set laststatus=0
			set noshowcmd
		else
			let s:hidden_all = 0
			set showmode
			set ruler
			set laststatus=2
			set showcmd
		endif
	endfunction
	nnoremap <leader>h :call ToggleHiddenAll()<CR>

	" Sudo-Save Befehl
	cabbrev w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" ===== Shortcut Integration =====
	" Integration mit externem Shortcut-System
	" Verwendet ; als speziellen Marker (nicht mapleader)
	" Beispiel: ':vs ;cfz' expandiert zu ':vs /home/user/.config/zsh/.zshrc'
	silent! source ~/.config/nvim/shortcuts.vim
