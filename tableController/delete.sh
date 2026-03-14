#!/bin/bash
DIR="$(dirname "${BASH_SOURCE[0]}")"

source "$DIR/../helpers.sh"
source "$DIR/list_tables.sh"

delete_from_table() {
    clear
    list_tables

    read -p "Enter table name to delete from: " tableName

    local meta="$DB_ROOT/$database_name/.$tableName.meta"
    local data="$DB_ROOT/$database_name/$tableName.data"

    if [[ ! -f "$meta" || ! -f "$data" ]]; then
        center " Table '$tableName' does not exist."
        return
    fi

    _parse_schema "$meta"

    read -p "Enter ${columns[$pk_index]} (${types[$pk_index]}) to delete: " pk_val

    if [[ -z "$pk_val" ]]; then
        center " Primary key cannot be empty."
        return
    fi

    if ! _pk_exists "$pk_val" "$pk_index" "$data"; then
        center " No record found with ${columns[$pk_index]} = '$pk_val'."
        return
    fi

    # Rewrite the data file excluding the matched row
    local tmp
    tmp=$(mktemp)
    awk -F: -v pk="$pk_val" -v col="$((pk_index + 1))" \
        '$col != pk' "$data" > "$tmp" && mv "$tmp" "$data"

    center " Record deleted successfully."
}