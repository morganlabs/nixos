''
  # Fresh start, no bindings
  unbind -a

  # GENERAL -------------------- #
  ## Command prompt
  bind : command-prompt

  ## Quick-reload
  bind r source-file ~/.config/tmux/tmux.conf \; display-message "Tmux configuration has been reloaded."

  ## Start indexes at 1, not 0, like a sane person
  set -g base-index 1
  setw -g pane-base-index 1

  # SESSION -------------------- #
  bind s command-prompt -I "#S" -p "Enter a session name: " "rename-session '%%'"

  ## Detach
  bind d detach-client

  ## Session tree
  bind t choose-tree

  # WINDOWS -------------------- #
  bind w command-prompt -p "Enter a window name: " "rename-window '%%'"
  bind x confirm-before -p "kill-window #W? (y/n)" kill-window

  ## Go to window $x
  bind 1 select-window -t :1
  bind 2 select-window -t :2
  bind 3 select-window -t :3
  bind 4 select-window -t :4
  bind 5 select-window -t :5
  bind 6 select-window -t :6
  bind 7 select-window -t :7
  bind 8 select-window -t :8
  bind 9 select-window -t :9
  bind 0 select-window -t :10

  ## Create new window
  bind c new-window

  # STATUS LINE ---------------- #
  set -g status-style bg=black
  set -g status-fg white

  set -g status-left-length 256
  set -g status-left " #S | #(whoami)@#H | "

  set -g status-right-length 37
  set -g status-right "%A, %d/%m/%Y %H:%M "
''
