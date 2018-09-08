#!/usr/bin/env bash
set -e

for i in _*; do
    source="${PWD}/$i"
    target="${HOME}/${i/_/.}"
    
    # everything else gets symlinked into home dir
    if [ -e "${target}" ] && [ ! -h "${target}" ]; then
        backup="${HOME}/.save.${i}"
        echo "${target} already exists. Moving to ${backup}"
        mv "${target}" "${backup}"
    fi
    ln -s "$source" "$target"
done
