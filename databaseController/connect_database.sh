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

    if [[ -z "$db_name" ]]; then
        tput setaf 1; tput bold
        center "✘  Database name cannot be empty."
        tput sgr0
        read -p "  Press Enter to continue..."
        return
    fi

    # Validate: matches naming rules
    if [[ ! "$db_name" =~ $valid_string ]]; then
        tput setaf 1; tput bold
        center "✘  Invalid name. Must start with a letter and contain only letters, digits, or underscores."
        tput sgr0
        read -p "  Press Enter to continue..."
        return
    fi

    if [[ ! -d "$DB_ROOT/$db_name" ]]; then
        tput setaf 1; tput bold
        center "✘  Database '$db_name' does not exist."
        tput sgr0
        read -p "  Press Enter to continue..."
        return
    fi

    current_db="$db_name"
    tput setaf 2; tput bold
    center "✔  Connected to database '$current_db' successfully"
    tput sgr0

    # Call the table menu loop
    table_menu
}