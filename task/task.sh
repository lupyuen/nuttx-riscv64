#!/usr/bin/env bash
## Auto Test Task for SG2000, BL602 and RISC-V

set -x  #  Echo commands

## Kill the Auto Test Tasks
pgrep -f task.sh task-nsh64.sh task-knsh64.sh
pkill -f task.sh task-nsh64.sh task-knsh64.sh

## Remove the log
rm nohup.out

## SG2000 Test Task
nohup $HOME/sg2000/autotest-nuttx-sg2000/scripts/task.sh &
sleep 60

## BL602 Test Task
nohup $HOME/bl602/remote-bl602/scripts/task.sh &
sleep 60

## nsh64 Test Task
nohup $HOME/riscv/nuttx-riscv64/task/task-nsh64.sh &
sleep 60

## knsh64 Test Task
nohup $HOME/riscv/nuttx-riscv64/task/task-knsh64.sh &

## Show the tasks and the log
pgrep -f task.sh task-nsh64.sh task-knsh64.sh
tail -f nohup.out
