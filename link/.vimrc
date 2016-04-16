"#############################################
" BASIC SETTINGS
"#############################################

" make vim incompatible to vi (better settings than VI) {{{
"
set nocompatible
"
" }}}
" LOAD and EXECUTE EXTERNAL SETTINGS {{{
"

" example
source $VIMRUNTIME/vimrc_example.vim

" controls like in WINDOWS operating system
source $VIMRUNTIME/mswin.vim
behave mswin
"
" }}}
" PATHOGEN PACKAGE MANAGER {{{
"
execute pathogen#infect()
"execute pathogen#helptags()
"
" }}}
" AIRLINE plugin {{{
"
"let g:airline_powerline_fonts = 1
set laststatus=2 " show controls even without further splits
"
" }}}
" VIEW settings {{{
"

" default font for all editor windows
set gfn=Lucida_Console:h9:cANSI

" automatically read externally modifies files
set autoread

" show absolute line numbers
set number

" set desired colorscheme
colo molokai

" maximize window on desktop
set sessionoptions+=resize,winpos


" MORE SETTINGS
"set encoding=utf-8
set scrolloff=3
set autoindent
set showmode
set showcmd " show (partial) command in status line
set hidden
set wildmenu
set wildmode=list:longest
set visualbell

filetype plugin indent on
syntax on " syntax highlighting ON
"
" }}}
" TABULATOR settings {{{
"

" set TAB to 4 spaces
set tabstop=4
set shiftwidth=4
set softtabstop=4

" expand TABs to spaces
set expandtab
"
" }}}
" CLIPBOARD settings {{{
"

" set clipboard as globally available (within other applications)
set clipboard=unnamed
"
" }}}




"#############################################
" BACKUP SETTINGS
"#############################################


" disable backup and swap files {{{
"
set nobackup
set nowritebackup
set noswapfile
"
" }}}
" enable backup and swap files in separate folder {{{
"
"set backup
set backupdir=c:\tmp,c:\temp,c:\WINDOWS\Temp,c:\_TEMP,d:\temp,d:\_TEMP,.
"set backupskip=c:\WINDOWS\Temp
set directory=c:\tmp,c:\temp,c:\WINDOWS\Temp,c:\_TEMP,d:\temp,d:\_TEMP,.
set undodir=c:\WINDOWS\Temp
"set writebackup
"
" }}}




"#############################################
" PLUGIN MODIFICATION SETTINGS
"#############################################


" PYTHON-MODE -> deactivate lookups for rope display {{{
"
let g:pymode_rope_lookup_project = 0
let g:pymode_rope_complete_on_dot = 0
let g:pymode_rope = 0
let g:pymode_rope_autoimport = 0
"
" }}}
" VIM-SESSION -> deactivate auto save question {{{
"
let g:session_autosave = 'no'
"
" }}}




"#############################################
" ADDITIONAL KEYBOARD SETTINGS
"#############################################


" set leader character {{{
"
let mapleader = ","
let localleader = "\\"
"
" }}}
" [NORMAL] change tab {{{
"
map <Leader>n <ESC>:tabprevious<CR>
map <Leader>m <ESC>:tabnext<CR>
"
" }}}
" [VISUAL] sort selection vertically {{{
"
vnoremap <Leader>s :sort<CR>
"
" }}}
" [VISUAL] indent code blocks {{{
"
vnoremap < <gv
vnoremap > >gv
"
" }}}
" [NORMAL] highlight word at cursor without changing position {{{
"
nnoremap <leader>h *<C-O>
" Highlight word at cursor and then Ack it.
"nnoremap <leader>H *<C-O>:AckFromSearch!<CR>
"
" }}}
" [NORMAL] edit VIMRC in new vertical split {{{
"
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
"
" }}}
" [NORMAL] source VIMRC for effects to take place immediately {{{
"
nnoremap <leader>sv :source $MYVIMRC<cr>
"
" }}}
" [NORMAL] surround word under cursor with double / single quotes {{{
"
nnoremap <leader>" viwh<ESC>a"<ESC>hbi"<ESC>lel
nnoremap <leader>' viwh<ESC>a'<ESC>hbi'<ESC>lel
"
" }}}
" [INSERT] use "jj" and "jk" as <ESC> {{{
"
inoremap jj <Esc>
inoremap jk <Esc>
"
" }}}
" [NORMAL] use CURSOR KEYS to move text line UP / DOWN {{{
"
noremap <down> ddp
noremap <up> ddkP
noremap <left> <Nop>
noremap <right> <Nop>
"
" }}}
" [INSERT] no CURSOR KEYS {{{
"
inoremap <down> <Nop>
inoremap <up> <Nop>
inoremap <left> <Nop>
inoremap <right> <Nop>
"
" }}}
" [VISUAL] no CURSOR KEYS {{{
"
vnoremap <down> <Nop>
vnoremap <up> <Nop>
vnoremap <left> <Nop>
vnoremap <right> <Nop>
"
" }}}
" [ all ]  <CTRL> + <N>  =>  stop highlighting {{{
"
noremap <C-n> :nohl<CR>
vnoremap <C-n> <Esc>:nohl<CR>
inoremap <C-n> <Esc>:nohl<CR>
"
" }}}
" [NORMAL] <CTRL> + <movement>  =>  move around existing split windows {{{
"
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h
"
" }}}
" [NORMAL] jumping up / down with <N> and <SHIFT> + <N> also centers view {{{
"
noremap n nzz
noremap N Nzz
"
" }}}




"#############################################
" OPERATORS (used in combination with d, c, ...)
"#############################################


" in(  operates on contents in next brackets {{{
"
onoremap in( :<c-u>normal! f(vi(<cr>
"
" }}}
" ih  operates on previous 'heading' text content {{{
"
onoremap ih :<c-u>execute "normal! ?^==\\+$\r:nohlsearch\rkvg_"<cr>
"
" }}}




"#############################################
" AUTOMATED STUFF
"#############################################


" save buffers and windows when leaving VIM {{{
"

" define function
fu! SaveSess()
    execute 'mksession! ' . getcwd() . '/.session.vim'
endfunction

" execute function on VIM LEAVE
autocmd VimLeave * call SaveSess()
"
" }}}
" restore buffers and windows when entering VIM {{{
"

" define function
fu! RestoreSess()
if filereadable(getcwd() . '/.session.vim')
    execute 'so ' . getcwd() . '/.session.vim'
    if bufexists(1)
        for l in range(1, bufnr('$'))
            if bufwinnr(l) == -1
                exec 'sbuffer ' . l
            endif
        endfor
    endif
endif
syntax on
endfunction

" execute function on VIM ENTER
"autocmd VimEnter * call RestoreSess()
"
" }}}
" delete trailing white spaces when saving buffer {{{
"

" function definition
func! DeleteTrailingWS()
    exe "normal! mz"
    %substitute/\s\+$//ge
    exe "normal! 'z"
endfunc

" execute function on VIM WRITEBUF
autocmd BufWrite * : call DeleteTrailingWS()
"
" }}}
" delete all ^M characters when saving buffer {{{
"

" function definition
func! DeleteCtrlM()
    %substitute/\r/\r/ge
endfunc

" execute function on VIM WRITEBUF
"autocmd BufWrite * : call DeleteCtrlM()
"
" }}}
" save and return to "normal" mode on FocusLost {{{
"
autocmd FocusLost * :silent! wall " Save on FocusLost
autocmd FocusLost * call feedkeys("\<C-\>\<C-n>") " Return to normal mode on FocustLost
"
" }}}
" automatically reload and execute vimrc on write {{{
"
autocmd bufwritepost _vimrc source %
"
" }}}



"#############################################
" FILE TYPE DEPENDENT STUFF
"#############################################


"
" commenting of lines
"
autocmd FileType javascript nnoremap <buffer> <localleader>c I//<ESC>
autocmd FileType python     nnoremap <buffer> <localleader>c I#<ESC>


" [JAVASCRIPT] - javascript file settings {{{
"
"
" }}}
" [HTML] - HTML file settings {{{
"
" re-format files when entering buffer and when saved
autocmd BufWritePre,BufRead *.html :normal gg=G

" no wrapping for respective buffer
autocmd BufNewFile,BufRead *.html setlocal nowrap
"
" }}}
" [VB] - visual basic file settings {{{
"
"
" }}}
" [VIM] - vimscript file settings {{{
"
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END
"
" }}}




"#############################################
" original stuff
"#############################################


set diffexpr=MyDiff()
function! MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction
