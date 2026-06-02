#!/bin/sh
exec > /tmp/wob-start.log 2>&1
echo "WAYLAND_DISPLAY=$WAYLAND_DISPLAY"
echo "HOME=$HOME"
pkill wob 2>/dev/null
rm -f /tmp/wob.sock
mkfifo /tmp/wob.sock && echo "FIFO created" || echo "mkfifo FAILED"
tail -f /tmp/wob.sock | wob
echo "pipeline exited: $?"
