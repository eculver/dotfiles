" Evan's bitchin vimrc

" Stop behaving like vi; vim enhancements are better
set nocompatible
filetype off

" Don't unload buffer when it's abandoned
set hidden

" Ignore extensions
set wildignore=*.o,*~,*.pyc,*.so,*.swp,*.zip,*.gz

" Vundle setup
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle
Plugin 'VundleVim/Vundle.vim'

" Snippets / Auto-complete
Plugin 'honza/vim-snippets'
Plugin 'Shougo/neosnippet-snippets'
Plugin 'Shougo/neocomplete.vim'
Plugin 'Shougo/neosnippet.vim'

" Enable on startup
let g:neocomplete#enable_at_startup = 1

" Use smartcase.
let g:neocomplete#enable_smart_case = 1

" Keymapping
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'

" Syntax checking/highlight
Plugin 'Syntastic'

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_signs=1
let g:syntastic_less_options=""
let g:syntastic_python_checkers=['flake8']
let g:syntastic_puppet_checkers=['puppetlint']
let g:syntastic_javascript_checkers=['standard']
let g:syntastic_go_checkers = ['goimports', 'errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }

Plugin 'tGpg'
Plugin 'Markdown'
Plugin 'elzr/vim-json'
let g:vim_json_syntax_conceal = 0

Plugin 'rodjek/vim-puppet'
Plugin 'pangloss/vim-javascript'
Plugin 'zaiste/tmux.vim'
Plugin 'solarnz/thrift.vim'
Plugin 'elubow/cql-vim'
Plugin 'digitaltoad/vim-jade'

" Go
Plugin 'fatih/vim-go'
let g:go_fmt_command = "goimports"
let g:go_list_type = "quickfix"
" let g:go_highlight_methods = 1
" let g:go_highlight_structs = 1
" let g:go_highlight_interfaces = 1
" let g:go_highlight_operators = 1

" Go Plugin key-mappings

" Open definition under cursor in new vertical, horizontal split or tab
au FileType go nmap <Leader>ds <Plug>(go-def-split)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>dt <Plug>(go-def-tab)

" Info, run, build, test, coverage
au FileType go nmap <Leader>i <Plug>(go-info)
au FileType go nmap <Leader>r <Plug>(go-run)
au FileType go nmap <Leader>b <Plug>(go-build)
au FileType go nmap <Leader>t <Plug>(go-test)
au FileType go nmap <Leader>c <Plug>(go-coverage)
au FileType go nmap <Leader>x <Plug>(go-coverage-clear)
au FileType go nmap <Leader>e :GoErrCheck<CR>

" Git(hub) integration
Plugin 'mattn/webapi-vim'
Plugin 'git.zip'
Plugin 'fugitive.vim'
Plugin 'gitignore'
Plugin 'airblade/vim-gitgutter'
Plugin 'mattn/gist-vim'
let g:gist_open_browser_after_post=0

" Utility
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'repeat.vim'
Plugin 'surround.vim'
Plugin 'benmills/vimux'
Plugin 'briandoll/change-inside-surroundings.vim'
Plugin 'wincent/command-t'

" ctrlp
" Plugin 'kien/ctrlp.vim'

" Lightline
Plugin 'itchyny/lightline.vim'
let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ 'active': {
      \     'left': [ [ 'mode', 'paste' ],
      \               [ 'fugitive', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'LightlineFugitive',
      \   'readonly': 'LightlineReadonly',
      \   'filename': 'LightlineFilename',
      \   'modified': 'LightlineModified'
      \ },
      \ 'separator': { 'left': '⮀', 'right': '⮂' },
      \ 'subseparator': { 'left': '⮁', 'right': '⮃' }
      \ }

function! LightlineModified()
  if &filetype == "help"
    return ""
  elseif &modified
    return "+"
  elseif &modifiable
    return ""
  else
    return ""
  endif
endfunction

function! LightlineReadonly()
  if &filetype == "help"
    return ""
  elseif &readonly
    return "⭤"
  else
    return ""
  endif
endfunction

function! LightlineFugitive()
  return exists('*fugitive#head') ? fugitive#head() : ''
endfunction

function! LightlineFilename()
  return ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
       \ ('' != expand('%:t') ? expand('%:t') : '[No Name]') .
       \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunction

" Ag
Plugin 'rking/ag.vim'
noremap <LocalLeader># "ayiw:Ag <C-r>a<CR>
vnoremap <LocalLeader># "ay:Ag <C-r>a<CR>

" tComment
Plugin 'tomtom/tcomment_vim'
nnoremap // :TComment<CR>
vnoremap // :TComment<CR>

" Search/Navigation
Plugin 'gmarik/vim-visual-star-search' " Use <leader>* or * # in visual mode

" Tagbar
Plugin 'majutsushi/tagbar'
let g:tagbar_autofocus = 1
let g:tagbar_ctags_bin = '/usr/local/Cellar/ctags/5.8_1/bin/ctags'
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : '/usr/local/bin/gotags',
    \ 'ctagsargs' : '-sort -silent'
    \ }

" Required end of Vundl'ing
call vundle#end()


" Encoding
if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  set encoding=utf-8
  setglobal fileencoding=utf-8
  "setglobal bomb
  set fileencodings=utf-8,latin1
endif

""" Moving Around/Editing
set nostartofline           " Avoid moving cursor to BOL when jumping around
set virtualedit=block       " Let cursor move past the last char in <C-v> mode
set scrolloff=3             " Keep 3 context lines above and below the cursor
set backspace=2             " Allow backspacing over autoindent, EOL, and BOL
set showmatch               " Briefly jump to a paren once it's balanced
set matchtime=2             " (for only .2 seconds).
set nowrap                  " don't wrap text
set linebreak               " don't wrap textin the middle of a word

""" Searching and Patterns
set ignorecase              " Default to using case insensitive searches,
set smartcase               " unless uppercase letters are used in the regex.
set hlsearch                " Highlight searches by default.
set incsearch               " Incrementally search while typing a /regex

""" More Natural Splits
set splitbelow
set splitright

""" Insert completion
" don't select first item, follow typing in autocomplete
set completeopt=longest,menuone,preview
set pumheight=6             " Keep a small completion window

" close preview window automatically
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

""" Folding
" set nofoldenable            " Disable folding
"folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1

set number                  " Display line numbers
set numberwidth=1           " using only 1 column (and 1 space) while possible
set background=dark
set cursorline              " Highlight current line
set cursorcolumn            " Highlight current column

if has("gui_running")
    set guioptions-=m           " remove menu bar
    set guioptions-=T           " remove toolbar
    set guioptions-=r           " remove right-hand scroll bar
endif

set t_Co=256 " Explicitly tell vim that the terminal has 256 colors

" show a gray line at column 79
if exists("&colorcolumn")
    execute "set colorcolumn=" . join(range(81,335), ',')
    set colorcolumn=79
endif

"""" Messages, Info, Status
set title                   " Terminal title
set vb t_vb=                " Disable all bells.  I hate ringing/flashing.
set confirm                 " Y-N-C prompt if closing with unsaved changes.
set showcmd                 " Show incomplete normal mode commands as I type.
set report=0                " : commands always print changed line count.
set shortmess+=a            " Use [+]/[RO]/[w] for modified/readonly/written.
set ruler                   " Show some info, even without statuslines.
set laststatus=2            " Always show statusline, even if only 1 window.
"set statusline=%F%m%r%h%w\ %{fugitive#statusline()}\ [LINE=%l:%c]\ [LEN=%L]

"""" Tabs/Indent Levels
let g:tabsize = 4
execute "set tabstop=".g:tabsize
execute "set shiftwidth=".g:tabsize
execute "set softtabstop=".g:tabsize

function! UpdateTabSize()
  " <tab> inserts <my_tab> spaces
  execute "set tabstop=".g:tabsize

  " but an indent level is <my_tab> spaces wide.
  execute "set shiftwidth=".g:tabsize

  "<BS> over an autoindent deletes both spaces.
  execute "set softtabstop=".g:tabsize
endfunction
nnoremap <Leader>tz execute UpdateTabSize()<CR>

set smartindent
set autoindent
set expandtab               " Use spaces, not tabs, for autoindent/tab key.
set shiftround              " rounds indent to a multiple of shiftwidth

"""" Tags
" Tags can be in ./tags, ../tags, ..., /home/tags.
set tags+=$HOME/.vim/tags/python.ctags
set tags+=$HOME/.vim/tags/django.ctags

set showfulltag             " Show more information while completing tags.
set cscopetag               " When using :tag, <C-]>, or "vim -t", try cscope:
set cscopetagorder=0        " try ":cscope find g foo" and then ":tselect foo"

"""" Reading/Writing
set noautowrite             " Never write a file unless I request it.
set noautowriteall          " NEVER.
set noautoread              " Don't automatically re-read changed files.
set modeline                " Allow vim options to be embedded in files;
set modelines=5             " they must be within the first or last 5 lines.
set ffs=unix,dos,mac        " Try recognizing dos, unix, and mac line endings.

"""" Backups/Swap Files
" Make sure that the directory where we want to put swap/backup files exists.
if has("unix")
    if ! len(glob("~/.backup/"))
        echomsg "Backup directory ~/.backup doesn't exist!"
    endif
    set backupdir^=~/.backup    " Backups are written to ~/.backup/ if possible.
    set directory^=~/.backup//  " Swap files are also written to ~/.backup, too.
endif

set writebackup             " Make a backup of the original file when writing

"set backup                 " and don't delete it after a succesful write.
set backupskip=             " There are no files that shouldn't be backed up.
set updatetime=2000         " Write swap files after 2 seconds of inactivity.
set backupext=~             " Backup for "file" is "file~"
" ^ Here be magic! Quoth the help:
" For Unix and Win32, if a directory ends in two path separators "//" or "\\",
" the swap file name will be built from the complete path to the file with all
" path separators substituted to percent '%' signs.  This will ensure file
" name uniqueness in the preserve directory.

"""" Command Line
set history=1000            " Keep a very long command-line history.
set wildmenu                " Menu completion in command mode on <Tab>
set wildmode=full           " <Tab> cycles between all matching choices.
set wcm=<C-Z>               " Ctrl-Z in a mapping acts like <Tab> on cmdline
source $VIMRUNTIME/menu.vim " Load menus (this would be done anyway in gvim)
" <F4> triggers the menus, even in terminal vim.
map <F4> :emenu <C-Z>

"""" Per-Filetype Scripts
" NOTE: These define autocmds, so they should come before any other autocmds.
"       That way, a later autocmd can override the result of one defined here.
filetype on                 " Enable filetype detection,
filetype indent on          " use filetype-specific indenting where available,
filetype plugin on          " also allow for filetype-specific plugins,
filetype plugin indent on   " required for Vundle
syntax on                   " and turn on per-filetype syntax highlighting.

""" Key Mappings
let mapleader=","
let maplocalleader="."

" map <silent><C-Left> <C-T>
" map <silent><C-Right> <C-]>

" Tab management
map <silent><S-n> :tabnext<CR>
map <silent><S-p> :tabprevious<CR>
map <silent><S-t> :tabnew<CR>

" Open new tab and toggle NERDTree
nnoremap <Leader>tt :tablast<CR><Bar>:tabnew<CR><Bar>:NERDTreeToggle<CR><Bar><C-w><Right><Bar>:q<CR>
let g:NERDTreeWinSize = 40

" Easily move around long wrapped lines
nnoremap k gk
nnoremap j gj

" Execute selected script
map <C-h> :py EvaluateCurrentRange()<CR>

" Show Project Tree
map <LocalLeader>tt :NERDTreeToggle<CR>

" Open Project Tree to current file
map <LocalLeader>tf :NERDTreeFind<CR>

" Toggle Paste Mode
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" Prompt for a command to run
map <Leader>rp :VimuxPromptCommand<CR>

" Run last command executed by RunVimTmuxCommand
map <Leader>rl :VimuxRunLastCommand<CR>

" Close all other tmux panes in current window
map <Leader>rx :CloseVimTmuxPanes<CR>

" If text is selected, save it in the v buffer and send that buffer it to tmux
vmap <LocalLeader>vs "vy :call RunVimTmuxCommand(@v)<CR>

" Mappings for handling unwanted whitespace
nnoremap <Leader>ss :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
nnoremap <Leader>st :let _s=@/<Bar>:%s/\t/    /ge<Bar>:let @/=_s<Bar>:nohl<CR>

" Apply title case to visual selection
vmap <Leader>sT :s/\<\(\w\)\(\w*\)\>/\u\1\L\2/g<CR>

" Mapping to insert a newline after line w/o entering insert mode
nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>

" Clear search highlight
nnoremap <Leader>/ :noh<CR>

" Re-indent entire file and return to current mark
" map to both Shift-i and <Leader>si to be consistent with other line
" manipulations
map <S-i> mzgg=G`z
nnoremap <Leader>si mzgg=G`z<CR>

" Rebind Command-T
map <LocalLeader>t :CommandT<CR>
map <LocalLeader>b :CommandTBuffer<CR>

" Buffer helpers
" new empty buffer
nmap <LocalLeader>T :enew<CR><Bar>:NERDTreeToggle<CR>
" move to next buffer
nmap <LocalLeader>l :bnext<CR>
" move to previous buffer
nmap <LocalLeader>h :bprevious<CR>
" close current buffer and move to the previous one
nmap <LocalLeader>bq :bp <BAR> bd #<CR>
" show all open buffers and their status
nmap <LocalLeader>bl :ls<CR>

let Tlist_GainFocus_On_ToggleOpen=1
let g:skip_loading_mswin=1


" treat html files as django templates
autocmd BufRead *.html set filetype=htmldjango

" JSON Highlighting
autocmd BufRead *.json set filetype=json

" YAML Highlighting
au! BufRead,BufNewFile *.yaml,*.yml so ~/.vim/syntax/yaml.vim

" LESS Highlighting
au! BufRead,BufNewFile *.less set filetype=less

" SASS Highlighting
au! BufRead,BufNewFile *.sass set filetype=sass
au! BufRead,BufNewFile *.scss set filetype=scss

" Handlebars Highlighting
au BufRead,BufNewFile *.handlebars,*.hbs set ft=html syntax=handlebars

autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd BufRead *.py set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
autocmd BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

" Go Highlighting
set rtp+=~/$GOROOT/misc/vim

" CQL Highlighting
au! BufRead,BufNewFile *.cql set filetype=cql

" Display
colorscheme jellybeans
" colorscheme lucid
" colorscheme benlight
" colorscheme void

" Tabs / Whitespace / Highlights (*after* colorscheme to override)
"
" Previous preference:
" ------------------------------
" preceeding/trailing tabs: '··'
" trailing whitespace:      '-'
" line-endings:             '$'
" ------------------------------
" set listchars=tab:··,eol:$,trail:-,precedes:<,extends:>
" set list
"
" OR
"
" Yet another option:
" ------------------------------
" preceeding/trailing tabs: '··'
" trailing whitespace:      '·'
" line-endings:             NONE
" ------------------------------
" set listchars=trail:·,tab:··
" set list

" Current preference (autocmds):
" ------------------------------
" preceeding/trailing tabs: highlight: gray
" trailing whitespace:      highlight: green
" line-endings:             NONE
" ------------------------------
highlight ExtraWhitespace ctermbg=darkgreen
match ExtraWhitespace /\s\+$/
au BufWinEnter * match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhitespace /\s\+$/
au BufWinLeave * call clearmatches()

" ignore tab highlights for go files
let tabftexclude = ['go', 'c']
highlight PreceedingTabs ctermbg=darkgray
match PreceedingTabs /^\t\+/
au BufWinEnter * if index(tabftexclude, &ft) < 0 | match PreceedingTabs /^\t\+/
au InsertEnter * if index(tabftexclude, &ft) < 0 | match PreceedingTabs /^\t\+\%#\@<!/
au InsertLeave * if index(tabftexclude, &ft) < 0 | match PreceedingTabs /^\t\+/
au BufWinLeave * call clearmatches()



