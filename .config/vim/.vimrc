"               ███                                 
"              ░░░                                  
"   █████ █████████ █████████████  ████████  ██████ 
"  ░░███ ░░███░░███░░███░░███░░███░░███░░██████░░███
"   ░███  ░███ ░███ ░███ ░███ ░███ ░███ ░░░░███ ░░░ 
"   ░░███ ███  ░███ ░███ ░███ ░███ ░███    ░███  ███
"  ██░░█████   ██████████░███ ██████████   ░░██████ 
" ░░  ░░░░░   ░░░░░░░░░░ ░░░ ░░░░░░░░░░     ░░░░░░  

syntax on
colorscheme delek
highlight Comment cterm=italic
highlight SignColumn ctermbg=none
" highlight Normal ctermbg=none

" All mappings
" inoremap " ""<left>
" inoremap ' ''<left>
" inoremap ( ()<left>
" inoremap [ []<left>
" inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
" noremap {;<CR> {<CR>};<ESC>O
" noremap <expr> ) strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"
" noremap <expr> ] strpart(getline('.'), col('.')-1, 1) == "]" ? "\<Right>" : "]"
" noremap <expr> } strpart(getline('.'), col('.')-1, 1) == "}" ? "\<Right>" : "}"

" Markdown mappings
autocmd FileType markdown inoremap -> &rarr;

" Java save and execute
autocmd FileType java map <F5> :w<CR>:!java "%"<CR>
autocmd FileType java imap <F5> <ESC>:w<CR>:!java "%"<CR>

" LaTeX mappings
let g:tex_flavor = "latex"
" autocmd FileType tex inoremap -> $\to$

" Java execute single file
autocmd FileType java map <F5> :w<CR>:!java "%"<CR>
autocmd FileType java imap <F5> <ESC>:w<CR>:!java "%"<CR>

" LaTeX save, compile
autocmd FileType tex map <F4> :w<CR>:!lualatex --shell-escape "%"<CR><CR>
autocmd FileType tex imap <F4> <ESC>:w<CR>:!lualatex --shell-escape "%"<CR><CR>a
autocmd FileType tex map <F5> :w<CR>:!pdflatex --shell-escape "%"<CR><CR>
autocmd FileType tex imap <F5> <ESC>:w<CR>:!pdflatex --shell-escape "%"<CR><CR>a
" LaTeX save and compile with biber
autocmd FileType tex map <S-F5> :w<CR>:!pdflatex --shell-escape "%"<CR><CR>:execute "!biber ".substitute(@%, "[.]tex", "", "")<CR><CR>:!pdflatex "%"<CR><CR>
autocmd FileType tex imap <S-F5> <ESC>:w<CR>:!pdflatex --shell-escape "%"<CR><CR>:execute "!biber ".substitute(@%, "[.]tex", "", "")<CR><CR>:!pdflatex "%"<CR><CR>a

" LaTeX Diplomarbeit textparts compile
" autocmd BufRead,BufNewFile */textparts/* map <F4> :w<CR>:!cd ..<CR>:!pdflatex Diplomarbeit.tex<CR><CR>:!cd ./textparts<CR>

" LaTeX open pdf
autocmd FileType tex map <F6> :execute "!xdg-open \"".substitute(@%, "[.]tex", ".pdf", "")."\" &"<CR><CR>
autocmd FileType tex imap <F6> <ESC>:execute "!xdg-open \"".substitute(@%, "[.]tex", ".pdf", "")."\" &"<CR><CR>a

" Markdown save, compile
autocmd FileType markdown map <F5> :w<CR>:execute "!pandoc --verbose --template eisvogel -H ~/.local/share/pandoc/disable_float.tex -o \"".substitute(@%, "[.]md", ".pdf", "")."\" \"".@%."\""<CR><CR>
autocmd FileType markdown imap <F5> <ESC>:w<CR>:execute "!pandoc --verbose --template eisvogel -H ~/.local/share/pandoc/disable_float.tex -o \"".substitute(@%, "[.]md", ".pdf", "")."\" \"".@%."\""<CR><CR>a

" Markdown save, compile with marp
autocmd FileType markdown map <S-F5> :w<CR>:!marp --pdf "%"<CR><CR>
autocmd FileType markdown imap <S-F5> <ESC>:w<CR>:!marp --pdf "%"<CR><CR>a

" Markdown save, compile with marp to html
autocmd FileType markdown map <C-S-F5> :w<CR>:!marp "%"<CR><CR>
autocmd FileType markdown imap <C-S-F5> <ESC>:w<CR>:!marp "%"<CR><CR>a

" Markdown open pdf
autocmd FileType markdown map <F6> :execute "!xdg-open \"".substitute(@%, "[.]md", ".pdf", "")."\" &"<CR><CR>
autocmd FileType markdown imap <F6> <ESC>:execute "!xdg-open \"".substitute(@%, "[.]md", ".pdf", "")."\" &"<CR><CR>a

" Markdown open html
autocmd FileType markdown map <S-F6> :execute "!xdg-open \"".substitute(@%, "[.]md", ".html", "")."\" &"<CR><CR>
autocmd FileType markdown imap <S-F6> <ESC>:execute "!xdg-open \"".substitute(@%, "[.]md", ".html", "")."\" &"<CR><CR>a

" Markdown to HTML save and compile
autocmd FileType markdown map <F7> :w<CR>:execute "!pandoc --verbose -f markdown -t html -o \"".substitute(@%, "[.]md", ".html", "")."\" \"".@%."\" -c styles.css -s"<CR><CR>

" Spelling
" Keymapping:
"	z= ... korrekte Wörter vorschlagen
"	zw ... Wort immer als falsch kennzeichnen
"	zg ... Wort ist eigentlich richtig -> Ins Dictionary hinzufügen
"
map <F8> :setlocal spell! spelllang=de <return>

" Paste toggle
set pastetoggle=<F2>

" Tab
set tabstop=4
set shiftwidth=4
set autoindent
set smartindent
set breakindent
set wrap
set linebreak
set nolist

" Effective tab while editing
set softtabstop=4

" Line numbering
set number relativenumber

" Show command
set showcmd

" Cursor line highlight
" set cursorline

" Filetype indent on
filetype indent on

" Wild menu
set wildmenu

" Highlight matching brackets [{()}]
set showmatch

" Search tweaks
set incsearch
set hlsearch

" Code folding
set foldenable
set foldlevelstart=10
set foldmethod=indent

" vim-plug
call plug#begin('~/.vim/plugged')

Plug 'itchyny/lightline.vim'
Plug 'frazrepo/vim-rainbow'
Plug 'garbas/vim-snipmate'
" Dependencies of vim-snipmate
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
" end of dependencies
Plug 'mboughaba/i3config.vim'
Plug 'raimondi/delimitmate'

" vim-coc
"" Stable version of coc
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"" Keeping up to date with master
"Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter'

" VimTeX
Plug 'lervag/vimtex'

" Code::Stats
Plug 'https://gitlab.com/code-stats/code-stats-vim.git'

" hardmode
Plug 'https://github.com/wikitopian/hardmode'

call plug#end()

let g:HardMode_level = 'wannabe'
let g:HardMode_hardmodeMsg = 'Don''t use this!'
autocmd VimEnter,BufNewFile,BufReadPost * silent! call HardMode()

" Content of .secrets:
" let g:codestats_api_key = 'YOUR_KEY_HERE'
source ~/.config/vim/.secrets

filetype plugin indent on

" NerdTree
" autocmd vimenter * NERDTree

" Syntastic
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0
" let g:syntastic_python_checkers = ['pylint']

" vim-rainbow
let g:rainbow_active = 1

" lightline
" set laststatus=2
" set noshowmode
" let g:lightline = {
" 	\ 'colorscheme': 'delek',
" 	\ }

" SnipMate
let g:snipMate = { 'snippet_version': 0 }

" Centering automatically with autocmds
" augroup VCenterCursor
" 	au!
" 	au BufEnter,WinEnter,WinNew,VimResized *,*.*
" 	      \ let &scrolloff=winheight(win_getid())/2
" augroup END
" set scrolloff=999

" lightline
set laststatus=2
set noshowmode
let g:lightline = {
	\ 'colorscheme': 'ayu_dark',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'readonly', 'filename', 'modified', 'codestats' ] ]
    \ },
    \ 'component': {
    \   'codestats': '%{CodeStatsXp()}'
    \ },
	\ }

autocmd VimEnter * call SetupLightlineColors()
function SetupLightlineColors() abort
	" transparent background in statusbar
	let l:palette = lightline#palette()

	let l:palette.normal.middle = [ [ 'NONE', 'NONE', 'NONE', 'NONE' ] ]
    let l:palette.inactive.middle = l:palette.normal.middle
    let l:palette.tabline.middle = l:palette.normal.middle

	call lightline#colorscheme()
endfunction

" " coc config
" let g:coc_global_extensions = [
" 	\ 'coc-snippets',
" 	\ 'coc-pairs',
" 	\ 'coc-tsserver',
" 	\ 'coc-eslint',
" 	\ 'coc-prettier',
" 	\ 'coc-json',
" 	\ 'coc-java',
" 	\ ]
" " from readme
" " if hidden is not set, TextEdit might fail.
" set hidden " Some servers have issues with backup files, see #649 set nobackup set nowritebackup " Better display for messages set cmdheight=2 " You will have bad experience for diagnostic messages when it's default 4000.
" set updatetime=300
" 
" " don't give |ins-completion-menu| messages.
" set shortmess+=c
" 
" " always show signcolumns
" set signcolumn=yes
" 
" " Use tab for trigger completion with characters ahead and navigate.
" " Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" 
" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction
" 
" " Use <c-space> to trigger completion.
" inoremap <silent><expr> <c-space> coc#refresh()
" 
" " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" " Coc only does snippet and additional edit on confirm.
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" " Or use `complete_info` if your vim support it, like:
" " inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
" 
" " Use `[g` and `]g` to navigate diagnostics
" nmap <silent> [g <Plug>(coc-diagnostic-prev)
" nmap <silent> ]g <Plug>(coc-diagnostic-next)
" 
" " Remap keys for gotos
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)
" 
" " Use K to show documentation in preview window
" nnoremap <silent> K :call <SID>show_documentation()<CR>
" 
" function! s:show_documentation()
"   if (index(['vim','help'], &filetype) >= 0)
"     execute 'h '.expand('<cword>')
"   else
"     call CocAction('doHover')
"   endif
" endfunction
" 
" " Highlight symbol under cursor on CursorHold
" autocmd CursorHold * silent call CocActionAsync('highlight')
" 
" " Remap for rename current word
" nmap <F2> <Plug>(coc-rename)
" 
" " Remap for format selected region
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)
" 
" augroup mygroup
"   autocmd!
"   " Setup formatexpr specified filetype(s).
"   autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
"   " Update signature help on jump placeholder
"   autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
" augroup end
" 
" " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
" xmap <leader>a  <Plug>(coc-codeaction-selected)
" nmap <leader>a  <Plug>(coc-codeaction-selected)
" 
" " Remap for do codeAction of current line
" nmap <leader>ac  <Plug>(coc-codeaction)
" " Fix autofix problem of current line
" nmap <leader>qf  <Plug>(coc-fix-current)
" 
" " Create mappings for function text object, requires document symbols feature of languageserver.
" xmap if <Plug>(coc-funcobj-i)
" xmap af <Plug>(coc-funcobj-a)
" omap if <Plug>(coc-funcobj-i)
" omap af <Plug>(coc-funcobj-a)
" 
" " Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
" nmap <silent> <C-d> <Plug>(coc-range-select)
" xmap <silent> <C-d> <Plug>(coc-range-select)
" 
" " Use `:Format` to format current buffer
" command! -nargs=0 Format :call CocAction('format')
" 
" " Use `:Fold` to fold current buffer
" command! -nargs=? Fold :call     CocAction('fold', <f-args>)
" 
" " use `:OR` for organize import of current buffer
" command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
" 
" " Add status line support, for integration with other plugin, checkout `:h coc-status`
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
" 
" " Using CocList
" " Show all diagnostics
" nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" " Manage extensions
" nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" " Show commands
" nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" " Find symbol of current document
" nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" " Search workspace symbols
" nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" " Do default action for next item.
" nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" " Do default action for previous item.
" nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" " Resume latest coc list
" nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
