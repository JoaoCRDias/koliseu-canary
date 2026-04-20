#!/bin/bash

# Coredump wrapper for systemd service
# Runs server under GDB to capture backtrace on crash
# Systemd handles restarts - this script runs once per invocation

LOGDIR="/root/logs"
BINARY="${1:-./canary_running}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
CRASH_LOG="$LOGDIR/crash_$TIMESTAMP.log"

mkdir -p "$LOGDIR"

echo "========================================"
echo "[$(date)] Starting server (no GDB): $BINARY"
echo "========================================"

# Check if GDB is available
if command -v gdb &>/dev/null; then
    gdb -batch \
        -ex "set pagination off" \
        -ex "set logging file $CRASH_LOG" \
        -ex "set logging enabled on" \
        -ex "run" \
        -ex "echo \n\n===== CRASH DETECTED =====\n\n" \
        -ex "bt full" \
        -ex "echo \n\n===== THREAD INFO =====\n\n" \
        -ex "info threads" \
        -ex "echo \n\n===== ALL THREADS BT =====\n\n" \
        -ex "thread apply all bt full" \
        -ex "quit" \
        "$BINARY"
else
    exec "$BINARY"
fi
