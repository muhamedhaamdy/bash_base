#!/bin/bash

DIR="$(dirname "${BASH_SOURCE[0]}")"
source "$DIR/../tableController/table_menu.sh"

connect_database() {
    echo ""
    tput setaf 6; tput bold
    center "╔══════════════════════════════════════╗"
    center "║           CONNECT DATABASE           ║"
    center "╚══════════════════════════════════════╝"
    tput sgr0
    echo ""

    printf "%*s" $(( (term_cols - 30) / 2 )) ""
    tput setaf 3; tput bold
    printf "Enter Database Name :  "
    tput sgr0
    read db_name
    echo ""

    _is_not_empty "$db_name"       "Database name" || return
    _is_valid_identifier "$db_name" "Database name" || return

    if ! _directory_exists "$DB_ROOT/$db_name"; then
        tput setaf 1; tput bold
        center "  Database '$db_name' does not exist."
        tput sgr0
        read -p "  Press Enter to continue..."
        return
    fi

    database_name="$db_name"

    tput setaf 2; tput bold
    center "  Connected to database '$database_name' successfully"
    tput sgr0
    sleep 1.5
    table_menu
}