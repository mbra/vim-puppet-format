if exists("b:did_ftplugin")
    finish                 
endif                      
let b:did_ftplugin = 1     

autocmd BufWritePre <buffer> call puppet#Format()

" This will run "puppet-lint --fix" on your unsaved buffer 
" If you are using syntastic, it will see the already fixed code 
" Most of this is stolen from vim-go go#fmt#Format
function! puppet#Format()
    " Save cursor position and many other things
    let l:curw=winsaveview()

    " Write current unsaved buffer to a temp file
	" Replace all tabs because of https://github.com/rodjek/puppet-lint/issues/366
	" To not remove an intended tab somewhere in the code, we only replace all tabs
	" at the beginning of a line, leaving more tabs in arrow indentations etc.
	" While puppet-lint will replace those, it will also not be able to indent
	" arrows correctly in the same run (this is almost certainly an ordering issue),
	" so we run puppet-lint twice if it replaced tabs on the first run.
    let l:tmpname = tempname()
	let l:content = []
	for l:line in getline(1, '$')
		call add(l:content, substitute(l:line, "^	\\+", "  ", "g"))
	endfor
    call writefile(l:content, l:tmpname)

    " Save our undo file to be restored after we are done. This is needed to
    " prevent an additional undo jump due to BufWritePre auto command and also
    " restore 'redo' history because it's getting being destroyed every BufWritePre
    let l:tmpundofile=tempname()
    exe 'wundo! ' . tmpundofile

    " 
	let out = system("puppet-lint --fix " . l:tmpname) 
	if out =~ "tab character found"
		call system("puppet-lint --fix " . l:tmpname)
	endif

    "if there is no error on the temp file replace the output with the current
    "file (if this fails, we can always check the outputs first line with:
    "splitted =~ 'package \w\+')
    if v:shell_error == 0
        " remove undo point caused via BufWritePre
        try | silent undojoin | catch | endtry

        " Replace current file with temp file, then reload buffer
        let old_fileformat = &fileformat
        call rename(l:tmpname, expand('%'))
        silent edit!
        let &fileformat = old_fileformat
        let &syntax = &syntax
    endif

    " restore our undo history
    silent! exe 'rundo ' . l:tmpundofile
    call delete(tmpundofile)

    " restore our cursor/windows positions
    call winrestview(l:curw)
endfunction

