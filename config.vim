" Find and replace in file
nmap <space>F :%s/<c-r><c-w>//g<left><left>

" vnoremap <leader>am :<C-U>execute 'normal! /\<method\>\\<CR>'<CR>

autocmd BufRead,BufNewFile *.slim setlocal suffixesadd+=.slim
" set path+=app/views

set path=$PWD/**


" Ctags
set tags=tags;/
set tags+=gems.tags
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
cnoremap %% <C-R>=expand('%:h').'/'<cr>

" Deleting
nnoremap <leader>dd "_dd
nnoremap <leader>D "_d$

" Italics
hi htmlArg gui=italic
hi Comment gui=italic
hi Type    gui=italic
hi htmlArg cterm=italic
hi Comment cterm=italic
hi Type    cterm=italic

" Beginning of line in command mode
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

" Git Blame
map <leader>g :Git blame<CR>

" Map <leader>z in visual mode to the function
vnoremap <leader>z :GBrowse<CR>

nmap <leader>G :.GBrowse <cr>
" Close Git Blame with q
autocmd FileType fugitiveblame nmap <buffer> q gq

" Replace word under cursor with buffer
nmap <space>r viw"0p
" Copy word under cursor into buffer
nmap <space>c yiw
" Copy util end of line
nnoremap <space>S y$

nnoremap q :q<CR>

" Edit files
nmap <space>e :edit %%

" Close all other windows
nnoremap <leader>x :only<CR>

" Rename Current File
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <leader>n :call RenameFile()<cr>

" Move lines
nnoremap <leader>kk :m .+1<CR>==
nnoremap <leader>jj :m .-2<CR>==
inoremap <leader>vv <Esc>:m .+1<CR>==gi
inoremap <leader>ff <Esc>:m .-2<CR>==gi
vnoremap <leader>vv :m '>+1<CR>gv=gv
vnoremap <leader>ff :m '<-2<CR>gv=gv
nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
nnoremap <leader>= :wincmd =<cr>

" " " coc key bindings
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? coc#_select_confirm() :
"       \ coc#expandableOrJumpable() ?
"       \ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
"
" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction

" let g:coc_snippet_next = '<tab>'

" Promote Variable to Rspec Let
function! PromoteToLet()
  :normal! dd
  " :exec '?^\s*it\>'
  :normal! P
  :.s/\(\w\+\) = \(.*\)$/let(:\1) { \2 }/
  :normal ==
endfunction
:command! PromoteToLet :call PromoteToLet()
:map <leader>l :PromoteToLet<cr>

" Remove binding.pry
function! RemoveBindingPry()
  " Run the prybaby command on the current file
  call system('prybaby -r ' . expand('%'))

  edit!
  " Print a message
  echo "Removed bindings"
endfunction

" Map the shortcut 'rb' to call the RemoveBindingPry function
nnoremap <leader>rb :call RemoveBindingPry()<CR>

