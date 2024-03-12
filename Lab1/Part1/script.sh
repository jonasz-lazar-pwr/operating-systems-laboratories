#!/bin/env bash

dir="${1:-plecak}"
file_content=$(cat sprzet)

if [[ -d "${dir}" ]]; then
    echo "Podany katalog już istnieje"
else
    mkdir "${dir}"
fi

counter=0

for item in $file_content; do

    rm -rf "$dir/$item"

    if [[ $((counter % 2 )) -eq 0 ]]; then
        touch "$dir/$item"
    else 
        mkdir -p "$dir/$item"
    fi

    counter=$((counter+1))
done

echo "$(date -I) Utworzyłem "${counter}" plików"
