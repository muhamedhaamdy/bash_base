#!/bin/bash

list_tables() {
    local found=false

    center "||======== Current Tables ========||"

    for file in "$DB_ROOT/$database_name/"*.data; do
        local name
        name="$(basename "$file")"
        [[ -f "$file" ]] || { center "No tables found."; center "||=================================||"; return; }
        center "${name%.data}"
        found=true
    done

    $found || center "No tables found."
    center "||=================================||"
    # for file in "$DB_ROOT/$database_name/"*.data; do
    #     echo "$(basename "$file")"
    # done
}