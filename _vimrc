" Evan's bitchin vimrc

" Stop behaving like vi; vim enhancements are better
set nocompatible

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

"""" Folding
set nofoldenable            " Disable folding

set number                  " Display line numbers
set numberwidth=1           " using only 1 column (and 1 space) while possible
set background=dark
set cursorline              " Highlight current line

if has("gui_running")
    set guioptions-=m           " remove menu bar
    set guioptions-=T           " remove toolbar
    set guioptions-=r           " remove right-hand scroll bar
endif

set t_Co=256 " Explicitly tell vim that the terminal has 256 colors

" show a line at column 79
if exists("&colorcolumn")
    execute "set colorcolumn=" . join(range(81,335), ',')
    set colorcolumn=79
endif

" displays tabs with :set list & displays when a line runs off-screen
set listchars=tab:>-,eol:$,trail:-,precedes:<,extends:>
set list

"""" Messages, Info, Status
set vb t_vb=                " Disable all bells.  I hate ringing/flashing.
set confirm                 " Y-N-C prompt if closing with unsaved changes.
set showcmd                 " Show incomplete normal mode commands as I type.
set report=0                " : commands always print changed line count.
set shortmess+=a            " Use [+]/[RO]/[w] for modified/readonly/written.
set ruler                   " Show some info, even without statuslines.
set laststatus=2            " Always show statusline, even if only 1 window.
"set statusline=%F%m%r%h%w\ %{fugitive#statusline()}\ [LINE=%l:%c]\ [LEN=%L]

"""" Tabs/Indent Levels
let g:tabsize = 2
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

set tabstop=2
set shiftwidth=2
set softtabstop=2
set smartindent
set autoindent

set expandtab                 " Use spaces, not tabs, for autoindent/tab key.
set shiftround                " rounds indent to a multiple of shiftwidth

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
if has("win32")
    if ! len(glob("~/backup/"))
        echomsg "Backup directory ~/backup doesn't exist!"
    endif
    set backupdir^=~/backup    " Backups are written to ~/.backup/ if possible.
    set directory^=~/backup//  " Swap files are also written to ~/.backup, too.
endif
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

map <silent><C-Left> <C-T>
map <silent><C-Right> <C-]>

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

" Clear search highlight
nnoremap <Leader>/ :noh<CR>

" Rebind Command T
map <Leader>F :CommandT<CR>

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

" Ignore .o, ~ and .pyc extensions
set wildignore=*.o,*~,*.pyc

let Tlist_GainFocus_On_ToggleOpen=1
let g:skip_loading_mswin=1

" Set terminal title
set title

" treat html files as django templates
autocmd BufRead *.html set filetype=htmldjango

" treat json files as JavaScript
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

" CoffeeScript Highlighting
au! BufRead,BufNewFile *.coffee set filetype=coffee

" Scala Highlighting
au! BufRead,BufNewFile *.scala set filetype=scala

"""" Display
colorscheme jellybeans

"""" Gist.vim
let g:gist_open_browser_after_post=0

"""" Bundles
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
Bundle "gmarik/vundle"

" Snippets
Bundle 'honza/vim-snippets'
Bundle "Shougo/neocomplcache"
Bundle "Shougo/neosnippet"

let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underscore completion.
let g:neocomplcache_enable_underbar_completion = 1

" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'

" Syntax checking/highlight
Bundle "Syntastic"

let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=1
let g:syntastic_less_options=""
let g:syntastic_python_checkers=['pyflakes']

Bundle "Markdown"
Bundle "Sass"
Bundle "less-syntax"
Bundle "JSON.vim"
Bundle "nono/vim-handlebars"
Bundle "lunaru/vim-less"
Bundle "hail2u/vim-css3-syntax"

" Git integration
Bundle "mattn/gist-vim"
Bundle "mattn/webapi-vim"
Bundle "Git-Branch-Info"
Bundle "git.zip"
Bundle "gitignore"
Bundle "fugitive.vim"
Bundle "airblade/vim-gitgutter"

" (HT|X)ml tool
Bundle "ragtag.vim"
Bundle "rstacruz/sparkup", {'rtp': 'vim/'}

" Utility
Bundle 'ScrollColors'
Bundle 'openssl.vim'
Bundle "YankRing.vim"
Bundle "The-NERD-tree"
Bundle "repeat.vim"
Bundle "surround.vim"
Bundle "SuperTab"
"Bundle "WebAPI.vim"
Bundle "benmills/vimux"
Bundle "sudo.vim"
Bundle "briandoll/change-inside-surroundings.vim"

" Lightline
Bundle 'itchyny/lightline.vim'
let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ 'active': {
      \     'left': [ [ 'mode', 'paste' ],
      \               [ 'fugitive', 'filename' ] ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'MyFugitive',
      \   'readonly': 'MyReadonly',
      \   'modified': 'MyModified',
      \   'filename': 'MyFilename'
      \ },
      \ 'separator': { 'left': '⮀', 'right': '⮂' },
      \ 'subseparator': { 'left': '⮁', 'right': '⮃' }
      \ }

function! MyModified()
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

function! MyReadonly()
  if &filetype == "help"
    return ""
  elseif &readonly
    return "⭤"
  else
    return ""
  endif
endfunction

function! MyFugitive()
  if exists("*fugitive#head")
    let _ = fugitive#head()
    return strlen(_) ? '⭠ '._ : ''
  endif
  return ''
endfunction

function! MyFilename()
  return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
       \ ('' != expand('%:t') ? expand('%:t') : '[No Name]') .
       \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction


" Ack
Bundle "ack.vim"
noremap <LocalLeader># "ayiw:Ack <C-r>a<CR>
vnoremap <LocalLeader># "ay:Ack <C-r>a<CR>

" tComment
Bundle "tComment"
nnoremap // :TComment<CR>
vnoremap // :TComment<CR>

" Search/Navigation
Bundle "gmarik/vim-visual-star-search"
