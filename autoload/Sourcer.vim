" sourcing helper
function! Sourcer#Source(fp, name) abort
    let l:expanded = globpath(a:fp, a:name)
    exec printf("source %s", l:expanded)
endfunction


let s:plugin_cache = {}

function! s:FilenameIncludes(fp, name) abort
    return a:fp =~? 'plugged/' . a:name
endfunction

function! Sourcer#PlugWrapper() abort
endfunction

function! s:PluggedFolderExists() abort
    return isdirectory(expand('~/.config/nvim/plugged'))
endfunction

function! Sourcer#SourcePluginConfs(name) abort
    let l:plgconfs = globpath('~/.config/nvim', 'plugin_confs')
    call Sourcer#Source(l:plgconfs, a:name)
endfunction

function! Sourcer#PluginLoaded(name) abort
    if has_key(s:plugin_cache, a:name)
        return v:true
    endif
    let res = filter(split(&rtp, ","), {idx, val -> s:FilenameIncludes(val, a:name)})
    if len(res) > 0
        let s:plugin_cache[a:name] = res[0]
        return v:true
    endif
    return v:false
endfunction

function! Sourcer#SourcePluginConfIfHavePlugin(match, name) abort
    if s:PluggedFolderExists() && Sourcer#PluginLoaded(a:match)
        call Sourcer#SourcePluginConfs(a:name)
    endif
endfunction

function! Sourcer#PlugInstallIfPluggedDoesntExist() abort
    if !s:PluggedFolderExists()
        PlugInstall
    endif
endfunction
