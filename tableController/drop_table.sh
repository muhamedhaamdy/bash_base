#!/bin/bash

drop_table() {
    list_tables
    read -p "Enter table name to drop: " tableName

    _is_not_empty "$tableName" "Table name" || return
    _is_valid_identifier "$tableName" "Table name" || return
    if ! _file_exists "$DB_ROOT/$database_name/$tableName.data"; then
        tput setaf 1; tput bold
        center "  Table '$tableName' does not exist."
        tput sgr0
        read -p "  Press Enter to continue..."
        return
    fi

    rm -f "$DB_ROOT/$database_name/$tableName.data"
    rm -f "$DB_ROOT/$database_name/.$tableName.meta"
    center "Table '$tableName' dropped successfully."
}