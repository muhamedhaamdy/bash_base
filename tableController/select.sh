#!/bin/bash

DIR="$(dirname "${BASH_SOURCE[0]}")"
source "$DIR/../helpers.sh"
source "$DIR/list_tables.sh"

_prompt_columns() {
    center " Available columns: ${columns[*]}"
    read -p "Enter column names (space separated): " cols_input
    _is_not_empty "$cols_input" "Columns" || return 1

    field_list="" header=""
    for col in $cols_input; do
        local idx
        idx=$(_col_index "$col") || { center " Column '$col' does not exist."; return 1; }
        field_list+="$idx,"
        header+="$col:"
    done
    field_list="${field_list%,}"
    header="${header%:}"
}

_prompt_filter() {
    center " Available columns: ${columns[*]}"
    read -p "Filter by column: " filter_col
    filter_idx=$(_col_index "$filter_col") || { center " Column '$filter_col' does not exist."; return 1; }

    read -p "Value for '$filter_col': " filter_val
    _is_not_empty "$filter_val" "Filter value" || return 1
}

_query_data() {
    local data="$1" field_list="$2" filter_idx="$3" filter_val="$4"
    awk -F: -v fields="$field_list" -v fcol="$filter_idx" -v fval="$filter_val" '
        BEGIN { n = split(fields, f, ",") }
        fcol == "" || $fcol == fval {
            for (i = 1; i <= n; i++) { printf "%s", $f[i]; if (i < n) printf ":"; }
            printf "\n"
        }
    ' "$data"
}

select_from_table() {
    clear
    list_tables

    local tableName meta data
    while true; do
        read -p "Enter table name to select from: " tableName
        _is_not_empty "$tableName" "Table name" || continue

        meta="$DB_ROOT/$database_name/.$tableName.meta"
        data="$DB_ROOT/$database_name/$tableName.data"

        _file_exists "$meta" && _file_exists "$data" || { center " Table '$tableName' does not exist."; continue; }
        _file_exists "$meta" && [[ -s "$meta"      ]] || { center " Table has no columns defined.";     continue; }
        break
    done

    _parse_schema "$meta"

    while true; do
        clear
        center " Table: $tableName"
        center "+------------------------------+"
        center "| 1 - Select all columns       |"
        center "| 2 - Select specific columns  |"
        center "| 3 - Back                     |"
        center "+------------------------------+"
        read -p "Choice: " choice

        case $choice in
            1)
                [[ -s "$data" ]] || { center " Table is empty."; read -p "Press Enter..."; continue; }
                echo ""
                _display_results "$(_print_headers)" "$(_query_data "$data" "$(seq -s, 1 ${#columns[@]})" "" "")"
                echo ""
                ;;

            2)
                [[ -s "$data" ]] || { center " Table is empty."; read -p "Press Enter..."; continue; }
                echo ""
                _prompt_columns || { read -p "Press Enter..."; continue; }

                local do_filter filter_idx="" filter_val=""
                read -p "Filter results? (y/n): " do_filter
                [[ "$do_filter" =~ ^[Yy]$ ]] && { _prompt_filter || { read -p "Press Enter..."; continue; }; }

                echo ""
                _display_results "$header" "$(_query_data "$data" "$field_list" "$filter_idx" "$filter_val")"
                echo ""
                ;;

            3) return ;;
            *) center " Invalid choice." ;;
        esac
        read -p "Press Enter to continue..."
    done
}