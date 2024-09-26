#!/bin/bash

du -a "${1:-.}" | cut -f2 | fzf --color=16 | xargs -r -I{} vim "{}"
