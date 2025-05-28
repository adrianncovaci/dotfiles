#!/bin/bash

session_name="update_session"

if [ -z "$TMUX" ]; then
    tmux new-session -d -s "$session_name"
    attach=true
else
    echo "No  $TMUX"
    exit 0
fi

sleep 0.5
tmux split-window -h -t "$session_name"
sleep 0.5
tmux split-window -v -t "$session_name":1.1
sleep 0.5

tmux send-keys -t "$session_name":1.0 "sudo dnf update -y" Enter
tmux send-keys -t "$session_name":1.1 "rustup update" Enter
tmux send-keys -t "$session_name":1.2 "cargo install-update -a" Enter
tmux select-pane -t "$session_name":1.0

tmux attach-session -t "$session_name"
