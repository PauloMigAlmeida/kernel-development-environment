" ##############
" Vundle configs
" ##############
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdtree'
Plugin 'bogado/file-line'
call vundle#end()            

" ##############
" Paulo's preferences
" ############## 
syntax on
set number
filetype on
filetype plugin indent on
set title
set tabstop=8
set softtabstop=8
set shiftwidth=8
set noexpandtab


" ##############
" CScope configs
" ############## 
if has("cscope")

	set nocscopeverbose
        " Look for a 'cscope.out' file starting from the current directory,
        " going up to the root directory.
        let s:dirs = split(getcwd(), "/")
        while s:dirs != []
                let s:path = "/" . join(s:dirs, "/")
                if (filereadable(s:path . "/cscope.out"))
                        execute "cs add " . s:path . "/cscope.out " . s:path . " -v"
                        break
                endif
                let s:dirs = s:dirs[:-2]
        endwhile

        set csto=0  " Use cscope first, then ctags
        set cst     " Only search cscope
        set csverb  " Make cs verbose

	"   's'   symbol: find all references to the token under cursor	
        nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
        "   'g'   global: find global definition(s) of the token under cursor
        nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
        "   'c'   calls:  find all calls to the function name under cursor
        nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
        "   't'   text:   find all instances of the text under cursor
        nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
        "   'e'   egrep:  egrep search for the word under cursor
        nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
        "   'f'   file:   open the filename under cursor
        nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
        "   'i'   includes: find files that include the filename under cursor
        nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
        "   'd'   called: find functions that function under cursor calls
        nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
        "   'a'   Find places where this symbol is assigned a value
	nmap <C-\>a :cs find a <C-R>=expand("<cword>")<CR><CR>
	"   's'   symbol: find all references to the token under cursor	
        nmap <C-\>S :cs find t struct <C-R>=expand("<cword>")<CR> {<CR>
	nmap <F6> :cnext <CR>
        nmap <F5> :cprev <CR>

        " Using 'CTRL-spacebar' (intepreted as CTRL-@ by vim) then a search type
        " makes the vim window split horizontally, with search result displayed in
        " the new window.
        "
        " (Note: earlier versions of vim may not have the :scs command, but it
        " can be simulated roughly via:
        "    nmap <C-@>s <C-W><C-S> :cs find s <C-R>=expand("<cword>")<CR><CR>

        nmap <C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@>g :scs find g <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@>t :scs find t <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@>e :scs find e <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
        nmap <C-@>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
        nmap <C-@>d :scs find d <C-R>=expand("<cword>")<CR><CR>
 
 
        " Hitting CTRL-space *twice* before the search type does a vertical
        " split instead of a horizontal one (vim 6 and up only)
        "
        " (Note: you may wish to put a 'set splitright' in your .vimrc
        " if you prefer the new window on the right instead of the left

        nmap <C-@><C-@>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@><C-@>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@><C-@>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@><C-@>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@><C-@>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@><C-@>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
        nmap <C-@><C-@>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
        nmap <C-@><C-@>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>

        " Open a quickfix window for the following queries.
        set cscopequickfix=s-,c-,d-,i-,t-,e-,g-
endif

" ##########
" Fugitive #
" ##########
nmap <F2> :G blame <CR>
nmap <F3> :G diff <CR>


" ##############
" Print to PDF #
" ##############
nmap <C-p> :hardcopy > %.ps \| !ps2pdf %.ps ~/Documents/<C-R>=expand('%:t:r')<CR>.pdf && rm %.ps && echo "exported PDF to ~/Documents/<C-R>=expand('%:t:r')<CR>.pdf" <CR>
