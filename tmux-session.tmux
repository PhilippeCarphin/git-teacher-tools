source-file ~/.tmux.conf
split-window -d -h
split-window -t 1 -v
resize-pane -t 0 -x 80
send-keys -t 1 'vim' enter
send-keys -t 0 'vim Corr*8.txt' enter
send-keys -t 2 'gitk' enter

select-pane -t 1
