#!/bin/sh
pkill wob 2>/dev/null
rm -f /tmp/wob.sock
mkfifo /tmp/wob.sock
exec tail -f /tmp/wob.sock | wob
