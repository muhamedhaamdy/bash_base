#!/bin/bash

connect_database() {
    source "./tableController/table_menu.sh"

    echo ""
    tput setaf 6; tput bold
    center "╔══════════════════════════════════════╗"
    center "║           CONNECT DATABASE           ║"
    center "╚══════════════════════════════════════╝"
    tput sgr0
    echo ""
    
    # Prompt for database name
    printf "%*s" $(( (term_cols - 30) / 2 )) ""
    tput setaf 3; tput bold
    printf "Enter Database Name :  "
    tput sgr0
    read db_name
    echo ""

    # Validate: not empty and matches naming rules
    _is_not_empty "$db_name" "Database name" || return
    _is_valid_identifier "$db_name" "Database name" || return

    if ! _directory_exists "$DB_ROOT/$db_name"; then
        tput setaf 1; tput bold
        center "  Database '$db_name' does not exist."
        tput sgr0
        read -p "  Press Enter to continue..."
        return
    fi

    current_db="$db_name"
    database_name="$db_name"
    tput setaf 2; tput bold
    center "  Connected to database '$current_db' successfully"
    tput sgr0

    # Call the table menu loop
    table_menu
}