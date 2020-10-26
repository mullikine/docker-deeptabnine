#!/bin/sh

ic="$1"
: "${ic:="magit-status"}"

eval `resize`
# emacs \
#     --no-window-system \
#     --eval \
#     "(progn ($ic) \
#     (delete-other-windows) \
#     (setq \
#     termframe-local \
#     (selected-frame)))"

emacs --no-window-system
