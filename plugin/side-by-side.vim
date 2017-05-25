" Based on https://brookhong.github.io/2016/09/03/view-diff-file-side-by-side-in-vim.html
function! s:side_by_side()
    if &filetype !=# 'diff'
        echo 'Not a diff file'
        return
    endif

    let lines = getline(0, '$')
    let la = []
    let lb = []
    for line in lines
        if line[0] ==# '-'
            if line ==# '---' || line ==# '-- '
                " Separator lines in email-formatted patch
                call add(la, line)
                call add(lb, line)
            elseif line[0:2] ==# '---'
                call add(la, line)
            else
                call add(la, ' ' . line[1:])
            endif
        elseif line[0] ==# '+'
            if line[0:2] ==# '+++'
                call add(lb, line)
            else
                call add(lb, ' ' . line[1:])
            endif
        else
            call add(la, line)
            call add(lb, line)
        endif
    endfor
    tabnew
    set buftype=nofile
    vertical new
    set buftype=nofile
    " Go to left pane
    execute "normal \<C-W>t"
    call append(0, la)
    setlocal nomodifiable
    diffthis
    " Go to right pane
    execute "normal \<C-W>b"
    call append(0, lb)
    setlocal nomodifiable
    diffthis
endfunction

command! -nargs=0 SideBySide call s:side_by_side()
