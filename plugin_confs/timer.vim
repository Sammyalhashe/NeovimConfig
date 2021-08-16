command! -nargs=0 TimerStop lua require'timer'.markDone()
command! -nargs=1 TimerStart lua require'timer'.timerFunc(<q-args>, print, nil)
