#!/bin/bash
out=$(slop)
x=$(echo "$out" | cut -d "+" -f 2)
y=$(echo "$out" | cut -d "+" -f 3)
dim=$(echo "$out" | cut -d "+" -f 1)
echo "$x,$y $dim"
