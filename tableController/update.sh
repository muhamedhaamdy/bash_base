#!/bin/bash

DIR="$(dirname "${BASH_SOURCE[0]}")"
source "$DIR/../helpers.sh"
source "$DIR/list_tables.sh"

update_table() {
    clear
    list_tables

    #  Validate table name 
    local tableName meta data
    while true; do
        read -p "Enter table name to update: " tableName
        _is_not_empty "$tableName" "Table name" || continue

        meta="$DB_ROOT/$database_name/.$tableName.meta"
        data="$DB_ROOT/$database_name/$tableName.data"

        _file_exists "$meta" && _file_exists "$data" || { center " Table '$tableName' does not exist."; continue; }
        [[ -s "$meta" ]] || { center " Table has no columns defined."; continue; }
        [[ -s "$data" ]] || { center " Table '$tableName' is empty. Nothing to update."; continue; }
        break
    done

    _parse_schema "$meta"

    #  Show current data 
    echo ""
    _display_results "$(_print_headers)" "$(cat "$data")"
    echo ""

    #  Ask for PK value to identify the row 
    local pk_val old_row
    while true; do
        read -p "Enter ${columns[$pk_index]} (${types[$pk_index]}) of row to update: " pk_val
        _is_not_empty "$pk_val" "${columns[$pk_index]}" || continue
        _validate_value "$pk_val" "${types[$pk_index]}"  || continue

        _pk_exists "$pk_val" "$pk_index" "$data" || { center " No row found with ${columns[$pk_index]} = '$pk_val'."; continue; }
        break
    done

    old_row=$(awk -F: -v pk="$pk_val" -v col="$((pk_index + 1))" '$col == pk' "$data")

    #  Show columns and let user pick which to update 
    echo ""
    center " Available columns:"
    for i in "${!columns[@]}"; do
        echo "   $((i+1))) ${columns[$i]} (${types[$i]})"
    done
    echo ""

    local col_choice
    while true; do
        read -p "Enter column number to update: " col_choice
        _is_not_empty "$col_choice"    "Column number"  || continue
        _is_positive_integer "$col_choice"              || continue
        (( col_choice >= 1 && col_choice <= ${#columns[@]} )) || { center " Number out of range."; continue; }
        break
    done

    local col_idx=$(( col_choice - 1 ))
    local col_name="${columns[$col_idx]}"
    local col_type="${types[$col_idx]}"

    # ── Ask for new value ────────────────────────────────────────────────────
    local new_value
    while true; do
        read -p "Enter new value for '$col_name' ($col_type): " new_value
        _is_not_empty "$new_value" "$col_name"   || continue
        _validate_value "$new_value" "$col_type" || continue

        # If updating the PK column, check uniqueness
        if (( col_idx == pk_index )) && [[ "$new_value" != "$pk_val" ]]; then
            _pk_exists "$new_value" "$pk_index" "$data" && { center " Primary key '$new_value' already exists."; continue; }
        fi
        break
    done

    # ── Apply the update ─────────────────────────────────────────────────────
    IFS=: read -r -a fields <<< "$old_row"
    fields[$col_idx]="$new_value"

    local new_row
    new_row=$(IFS=:; echo "${fields[*]}")

    local tmp
    tmp=$(mktemp)
    awk -v old="$old_row" -v new="$new_row" '$0 == old { print new; next } { print }' "$data" > "$tmp" \
        && mv "$tmp" "$data"

    echo ""
    center " Row updated successfully."
    echo ""
    _display_results "$(_print_headers)" "$(awk -F: -v pk="$new_value" -v col="$((pk_index + 1))" '$col == pk' "$data")"
    echo ""
    read -p "Press Enter to continue..."
}