#!/bin/bash
TS=$(date +%Y%m%d_%H%M%S)
[ -f /root/logs/ot-out.log ] && mv /root/logs/ot-out.log "/root/logs/ot-out_${TS}.log"
[ -f /root/logs/ot-error.log ] && mv /root/logs/ot-error.log "/root/logs/ot-error_${TS}.log"
