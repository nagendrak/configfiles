" -------------------------------------------------------------------
" Vim configuration file
" -------------------------------------------------------------------
" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

set nocompatible            " Set vi-compatibility
filetype plugin on

set ignorecase              " Ignore case during searches [OFF]
set nohls                   " Do not highlight search patterns [ON]
set incsearch		    " Enable incremental search

"set spell                   " Checks spelling [OFF]
"Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Editing options
set textwidth=120           " Restrict the column width [OFF]

set tabstop=8               " Set tab (\t) spacing [8]
set softtabstop=2           " Set tab (<tab>) spacing
set shiftwidth=2            " Set indent width
"set expandtab               " Use spaces, not tabs [OFF]

set autoindent              " Retain indentation from previous line [OFF]
set smartindent             " Autoindent when starting new lines [OFF]

set showmatch               " Highlight matching braces briefly if present
let loaded_matchparen = 1

let Tlist_Inc_Winwidth=0

syntax on                   " Set syntax colouring [OFF]
set background=dark
set foldmethod=syntax       " Set folding method to syntax [manual]
colorscheme koehler
"let $myscheme=$VIMRUNTIME . '\colors\koehler.vim'
"highlight Comment term=bold ctermfg=2
highlight Comment cterm=none term=none ctermfg=2
highlight Constant term=underline ctermfg=7
highlight TabLineFill ctermfg=LightBlue ctermbg=DarkBlue
highlight TabLine ctermfg=Blue ctermbg=Black
highlight TabLineSel ctermfg=Red ctermbg=Yellow
highlight Title ctermfg=LightBlue ctermbg=Magenta
highlight PreProc ctermfg=magenta cterm=bold guifg=#FF00FF

set pastetoggle=<F2>
nmap <silent> <leader>/ :set hlsearch!<CR>
nmap <silent> <C-w>N :below new<CR>
nmap <C-N><C-N> :set invnumber<CR>

""" Code folding options
" nmap <leader><f0> :set foldlevel=0<CR>
" nmap <leader><f1> :set foldlevel=1<CR>
" nmap <leader><f2> :set foldlevel=2<CR>
" nmap <leader><f3> :set foldlevel=3<CR>
" nmap <leader><f4> :set foldlevel=4<CR>
" nmap <leader><f5> :set foldlevel=5<CR>
" nmap <leader><f6> :set foldlevel=6<CR>
" nmap <leader><f7> :set foldlevel=7<CR>
" nmap <leader><f8> :set foldlevel=8<CR>
" nmap <leader><f9> :set foldlevel=9<CR>

set ruler                   " Line and Column number of cursor [OFF]

set backup                  " Set backup of files [OFF]
set backupdir=~/.backup     " Set temp dir for backup files
"" Creating directories if they don't exist
silent execute '!mkdir -p $HOME/.backup'
set mouse-=a                " Set mouse usage to off
set backspace=2

"Menu items for Commenting and Un-Commenting code
amenu 20.435 &Edit.-SEP4- :
amenu Edit.Comment <Esc>`<:let fl=line(".")<CR>`>:let ll=line(".")<CR>:call Comment(fl, ll)<CR>
amenu Edit.UnComment <Esc>`<:let fl=line(".")<CR>`>:let ll=line(".")<CR>:call UnComment(fl, ll)<CR>
"
""Function for commenting a block of Visually selected text
function Comment(fl, ll)
  let i=a:fl
  let comment="//"
  while i<=a:ll
    let cl=getline(i)
    let cl2=comment.cl
    call setline(i, cl2)
    let i=i+1
  endwhile
endfunction

"Function for Un-Commenting a block of Visually selected text
function UnComment(fl, ll)
  let i=a:fl
  let comment="//"
  while i<=a:ll
    let cl=getline(i)
    let cl2=substitute(cl, "//", "", "")
    call setline(i, cl2)
    let i=i+1
  endwhile
endfunction

noremap <silent> ,c :<C-B>sil <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:noh<CR>
noremap <silent> ,u :<C-B>sil <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:noh<CR>

" Following setting if we want to do anything in particular only for
" text files.
" au BufRead,BufNewFile *.txt,*.tex set wrap linebreak nolist textwidth=0 wrapmargin=0

execute pathogen#infect()

" Taglist shortcuts (not being used - see tagbar below)
" nmap <silent> <leader>tt :TlistHighlightTag<CR>
" nmap <silent> <leader>tT :TlistToggle<CR>

" Tagbar shortcuts
nnoremap <silent> <leader>th :TagbarShowTag<CR>
nnoremap <silent> <leader>tt :TagbarToggle<CR>
nnoremap <silent> <leader>tf :TagbarOpen j<CR>

" Nerdtree settings
let NERDTreeShowBookmarks=1
nnoremap <silent> <Leader>nt :NERDTreeToggle<CR>
nnoremap <silent> <Leader>nf :NERDTreeFocus<CR>

" Fugitive settings
nnoremap <silent> <Leader>gd :Gdiff<CR>
nnoremap <silent> <Leader>gs :Gstatus<CR>
nnoremap <silent> <Leader>gl :Glog<CR>
set diffopt+=vertical

" Easy window navigation
let g:BASH_Ctrl_j = 'off'
let g:C_Ctrl_j = 'off'
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" VimWiki remapping for splitting
nmap <leader>we :VimwikiSplitLink<CR>
nmap <leader>wq :VimwikiVSplitLink<CR>

" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

set tags+=~/.vimtags

source ~/.vim/vimrc/vimrc_latexsuite
source ~/.vim/vimrc/vimrc_vimorganizer
source ~/.vim/vimrc/vimrc_fortran
source ~/.vim/vimrc/vimrc_cpp
source ~/.vim/vimrc/vimrc_python
source ~/.vimrc_local

runtime macros/matchit.vim " Enable the matchit plugin - smarter parantheses matching!

" Allow for local vimrc to over-ride for project related settings
set exrc
set secure
