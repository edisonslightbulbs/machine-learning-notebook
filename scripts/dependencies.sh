#!/bin/bash

# dependencies.sh
#   Installs essential apt and pip packages
#
# author: Everett
# created: 2021-08-27 05:58
# Github: https://github.com/antiqueeverett/

# evaluate working directory
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    wd="$(dirname "$(dirname "$(readlink -f "$0")")")"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    wd="$(dirname "$(dirname "$(greadlink -f "$0")")")"
fi

# setup vars for apt and pip package lists
apt="$wd/resources/apt.txt"
pip="$wd/resources/pip.txt"
brew="$wd/resources/brew.txt"
tap="$wd/resources/tap.txt"
conda="$wd/resources/conda.txt"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo ""
    echo "-- installing apt packages:"
    cat "$apt"
    echo ""
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "-- installing brew packages:"
    cat "$brew"
    echo ""
fi

echo "-- installing pip packages:"
cat "$pip"
echo ""

# use awk to pre-process each line (i.e., in apt.txt & pip.txt)
# then, hand over each line-output to xargs (approach leaves STDIN unchanged!)
# args:
#      [ -a ] leave STDIN unchanged while reading each line as a  command
#      [ -r ] run iff line not empty
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    xargs -a <(awk '! /^ *(#|$)/' "$conda") -r -- conda install
    xargs -a <(awk '! /^ *(#|$)/' "$apt") -r -- sudo apt install
    xargs -a <(awk '! /^ *(#|$)/' "$pip") -r -- pip3 install --upgrade
elif [[ "$OSTYPE" == "darwin"* ]]; then
    gxargs -a <(awk '! /^ *(#|$)/' "$conda") -r -- conda install
    gxargs -a <(awk '! /^ *(#|$)/' "$brew") -r -- brew install
    gxargs -a <(awk '! /^ *(#|$)/' "$tap") -r -- brew tap
    gxargs -a <(awk '! /^ *(#|$)/' "$pip") -r -- pip3 install --upgrade
fi
