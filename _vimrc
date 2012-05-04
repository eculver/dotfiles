" Original Author: John Anderson (sontek@gmail.com)

" Stop behaving like vi; vim enhancements are better
set nocompatible

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

""" Insert completion
" don't select first item, follow typing in autocomplete
set completeopt=longest,menuone,preview
set pumheight=6             " Keep a small completion window

" close preview window automatically
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

"""" Folding
set foldmethod=indent       " By default, use syntax to determine folds
set foldlevelstart=99       " All folds open by default


set number                  " Display line numbers
set numberwidth=1           " using only 1 column (and 1 space) while possible
set background=dark

if has("gui_running")
    set guioptions-=m           " remove menu bar
    set guioptions-=T           " remove toolbar
    set guioptions-=r           " remove right-hand scroll bar
endif

set t_Co=256 " Explicitly tell vim that the terminal has 256 colors

" show a line at column 79
if exists("&colorcolumn")
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
set tabstop=4               " <tab> inserts 4 spaces 
set shiftwidth=4            " but an indent level is 2 spaces wide.
set softtabstop=4           " <BS> over an autoindent deletes both spaces.
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
syntax on                   " and turn on per-filetype syntax highlighting.

""" Key Mappings
let mapleader=","
let maplocalleader="."

map <silent><C-Left> <C-T>
map <silent><C-Right> <C-]>

" easily move around tabs
map <silent><S-n> :tabnext<CR>

" easily move around long wrapped lines
nnoremap k gk
nnoremap j gj

" execute selected script
map <C-h> :py EvaluateCurrentRange()<CR>

" Show tasks in current buffer
map T :TaskList<CR><C-w><Left>

" Show Project Menu
map <F5> :NERDTreeToggle<CR>

" Toggle Paste Mode
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" Prompt for a command to run
map <Leader>rp :PromptVimTmuxCommand<CR>

" Run last command executed by RunVimTmuxCommand
map <Leader>rl :RunLastVimTmuxCommand<CR>

" Close all other tmux panes in current window
map <Leader>rx :CloseVimTmuxPanes<CR>

" If text is selected, save it in the v buffer and send that buffer it to tmux
vmap <LocalLeader>vs "vy :call RunVimTmuxCommand(@v)<CR>

" Ignore .o, ~ and .pyc extensions
set wildignore=*.o,*~,*.pyc

let Tlist_GainFocus_On_ToggleOpen=1
let g:skip_loading_mswin=1

" Set terminal title
set title

" treat html files as django templates
autocmd BufRead *.html set filetype=htmldjango

" treat pjs files as JavaScript
autocmd BufRead *.pjs set filetype=javascript

" treat phtml files as HTML
autocmd BufRead *.phtml set filetype=html

" SASS Highlighting
au! BufRead,BufNewFile *.sass setfiletype sass
au! BufRead,BufNewFile *.scss setfiletype scss

autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd BufRead *.py set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"      
autocmd BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m       

"""" Display
colorscheme jellybeans

"""" Gist.vim
let g:gist_clip_command='pbcopy'
let g:gist_open_browser_after_post=1

"""" Pathogen
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

