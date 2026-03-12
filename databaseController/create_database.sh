#!/bin/bash

create_database() {

    echo ""
    tput setaf 6; tput bold
    center "╔══════════════════════════════════════╗"
    center "║           CREATE DATABASE            ║"
    center "╚══════════════════════════════════════╝"
    tput sgr0
    echo ""

    # Prompt for database name
    printf "%*s" $(( (term_cols - 30) / 2 )) ""
    tput setaf 3; tput bold
    printf "Enter Database Name ➜  "
    tput sgr0
    read db_name

    echo ""

    # Validate: not empty
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

    # Check if database already exists
    if [[ -d "$DB_ROOT/$db_name" ]]; then
        tput setaf 1; tput bold
        center "✘  Database '$db_name' already exists."
        tput sgr0
        read -p "  Press Enter to continue..."
        return
    fi

    # Create the database directory and its files
    mkdir "$DB_ROOT/$db_name"
    touch "$DB_ROOT/$db_name/$db_name.data"
    touch "$DB_ROOT/$db_name/.$db_name.meta"

    tput setaf 2; tput bold
    center "✔  Database '$db_name' created successfully!"
    tput sgr0
    read -p "  Press Enter to continue..."
}
