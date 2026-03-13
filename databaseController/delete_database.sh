!#/bin/bash

delete_database() {

    echo ""
    tput setaf 6; tput bold
    center "╔══════════════════════════════════════╗"
    center "║           DELETE DATABASE            ║"
    center "╚══════════════════════════════════════╝"
    tput sgr0
    echo ""

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

    if [[ "$current_db" == "$db_name" ]]; then
        tput setaf 1; tput bold
        center "✘  Cannot delete the current database."
        tput sgr0
        read -p "  Press Enter to continue..."
        return
    fi

    read -p "  Are you sure you want to delete database '$db_name'? (y/n) " confirm

    if [[ "$confirm" == "y" ]]; then
        rm -rf "$DB_ROOT/$db_name"
        tput setaf 2; tput bold
        center "✔  Database '$db_name' deleted successfully!"
        tput sgr0
        read -p "  Press Enter to continue..."
    else
        tput setaf 1; tput bold
        center "✘  Database deletion cancelled."
        tput sgr0
        read -p "  Press Enter to continue..."
    fi
}