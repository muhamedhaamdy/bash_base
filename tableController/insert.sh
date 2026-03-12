#!/bin/bash
source "../helpers.sh"
source "./tableController/list_tables.sh"

#  Main insert function 
insert_into_table() {
    clear
    list_tables

    read -p "Enter table name: " tableName

    local meta="$DB_ROOT/$database_name/.$tableName.meta"
    local data="$DB_ROOT/$database_name/$tableName.data"

    if [[ ! -f "$meta" || ! -f "$data" ]]; then
        center " Table '$tableName' does not exist."
        return
    fi

    # Parse schema once from .meta file
    _parse_schema "$meta"

    # Collect and validate input for each column
    local values=()
    for i in "${!columns[@]}"; do
        while true; do
            read -p "Enter ${columns[$i]} (${types[$i]}): " value
            _validate_value "$value" "${types[$i]}" && break
        done
        values[$i]="$value"
    done

    # Check PK uniqueness
    if _pk_exists "${values[$pk_index]}" "$pk_index" "$data"; then
        center " Primary key '${values[$pk_index]}' already exists."
        return
    fi

    # Write the new row to .data file
    local row
    row=$(IFS=:; echo "${values[*]}")
    echo "$row" >> "$data"
    center " Record inserted successfully."
}
