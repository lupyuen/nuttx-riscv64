#!/usr/bin/env bash
## Upload Test Log to GitHub Release Notes of Apache NuttX RTOS for QEMU RISC-V 64-bit Kernel Build
## Parameters: Release Tag, Test Log

repo=lupyuen/nuttx-riscv64
tag=$1
log=$2

set -e  ##  Exit when any command fails

rm -f /tmp/upload-knsh64.log

##  Preserve the Auto-Generated GitHub Release Notes.
##  Fetch the current GitHub Release Notes and extract the body text.
set -x  ##  Echo commands
gh release view \
    `cat $tag` \
    --json body \
    --jq '.body' \
    --repo $repo \
    >/tmp/upload-knsh64.old
set +x  ##  Don't echo commands

##  Find the position of the Previous Test Log, starting with "```"
set +e  ##  Don't exit when any command fails
cat /tmp/upload-knsh64.old \
    | grep '```' --max-count=1 --byte-offset \
    | sed 's/:.*//g' \
    >/tmp/upload-knsh64-previous-log.txt
set -e  ##  Exit when any command fails
prev=`cat /tmp/upload-knsh64-previous-log.txt`

##  If Previous Test Log exists, discard it
if [ "$prev" != '' ]; then
    cat /tmp/upload-knsh64.old \
        | head --bytes=$prev \
        >>/tmp/upload-knsh64.log
else
    ##  Else copy the entire Release Notes
    cat /tmp/upload-knsh64.old \
        >>/tmp/upload-knsh64.log
    echo "" >>/tmp/upload-knsh64.log
fi

##  Show the Test Status
set +e  ##  Don't exit when any command fails
grep "^===== " $log \
    | colrm 1 6 \
    >>/tmp/upload-knsh64.log
set -e  ##  Exit when any command fails

##  Enquote the Test Log without Carriage Return and Terminal Control Characters
##  TODO: The long pattern for sed doesn't work on macOS
##  https://stackoverflow.com/questions/17998978/removing-colors-from-output
echo '```text' >>/tmp/upload-knsh64.log
cat $log \
    | tr -d '\r' \
    | tr -d '\r' \
    | sed 's/\x08/ /g' \
    | sed 's/\x1B(B//g' \
    | sed 's/\x1B\[K//g' \
    | sed 's/\x1B[<=>]//g' \
    | sed 's/\x1B\[[0-9:;<=>?]*[!]*[A-Za-z]//g' \
    | sed 's/\x1B[@A-Z\\\]^_]\|\x1B\[[0-9:;<=>?]*[-!"#$%&'"'"'()*+,.\/]*[][\\@A-Z^_`a-z{|}~]//g' \
    >>/tmp/upload-knsh64.log
echo '```' >>/tmp/upload-knsh64.log

## Trim to first 100000 bytes
head -c 100000 /tmp/upload-knsh64.log \
    >/tmp/upload-knsh64-trim.log

##  Upload the Test Log to the GitHub Release Notes
set -x  ##  Echo commands
gh release edit \
    `cat $tag` \
    --notes-file /tmp/upload-knsh64-trim.log \
    --repo $repo
set +x  ##  Don't echo commands

##  Show the Test Status
set +e  ##  Don't exit when any command fails
grep "^===== " $log
set -e  ##  Exit when any command fails
