#!/bin/bash
grep -v "[\t ]*#.*" |
# Isolate the part of each line that is a string of consecutive digits
# \1 <- \([0-9]*\)
# and replace it by
# githost.git.polymtl.ca/git/inf1995-\1
sed 's/[^0-9]*\([0-9]*\)[^0-9]*/https:\/\/githost.gi.polymtl.ca\/git\/inf1995-\1/' |
# remove duplicates
sort | uniq
