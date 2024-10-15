#!/usr/bin/env bash
# Validate all defconfig files:
# git clone https://github.com/apache/nuttx
# cd nuttx
# check_config.sh

set -e  #  Exit when any command fails
set -x  #  Echo commands

# Derived from https://github.com/apache/nuttx/blob/master/tools/testbuild.sh
build=arm-01
testfile=tools/ci/testlist/$build.dat
testlist=`grep -v -E "^(-|#)|^[C|c][M|m][A|a][K|k][E|e]" $testfile || true`
echo testlist=$testlist
for line in $testlist; do
  firstch=${line:0:1}
  if [ "X$firstch" == "X/" ]; then
    dir=`echo $line | cut -d',' -f1`
    echo "***** dir=$dir"
    echo "***** find boards$dir -name defconfig" && find boards$dir -name defconfig

    # i looks like "nucleo-f303ze/adc"
    list=`find boards$dir -name defconfig | cut -d'/' -f4,6`
    for i in ${list}; do
      echo "**** i=$i"
      ./tools/refresh.sh --silent $i
      # Previously: dotest $i${line/"$dir"/}
    done
  else
    echo dotest $line
  fi
done