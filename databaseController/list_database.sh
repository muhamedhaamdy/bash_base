#!/bin/bash

list_databases() {

    echo ""
    tput setaf 6; tput bold
    center "╔══════════════════════════════════════╗"
    center "║          LIST DATABASES              ║"
    center "╚══════════════════════════════════════╝"
    tput sgr0
    echo ""

    # Collect database directories
    local dbs=()
    for dir in "$DB_ROOT"/*/; do
        # Skip if the glob didn't match anything (no directories)
        [[ ! -d "$dir" ]] && continue
        dbs+=("$(basename "$dir")")
    done

    # Check if any databases exist
    if [[ ${#dbs[@]} -eq 0 ]]; then
        tput setaf 1; tput bold
        center "  No databases found."
        tput sgr0
        read -p "  Press Enter to continue..."
        return
    fi

    # Display numbered list
    tput setaf 6
    center "──────────────────────────────────────"
    tput sgr0
    echo ""

    local i=1
    for db in "${dbs[@]}"; do
        center "  $(tput setaf 3)[${i}]$(tput setaf 7)  ${db}"
        ((i++))
    done

    echo ""
    tput setaf 6
    center "──────────────────────────────────────"
    tput sgr0
    echo ""

    tput setaf 3
    center "Total: ${#dbs[@]} database(s)"
    tput sgr0

    read -p "  Press Enter to continue..."
}
