#!/bin/bash

create_table(){
    source "$DIR/../helpers.sh"

    echo ""
    tput setaf 6; tput bold
    center "╔══════════════════════════════════════╗"
    center "║           CREATE TABLE               ║"
    center "╚══════════════════════════════════════╝"
    tput sgr0
    echo ""
    local i=0
    local columns=()
    local types=()
    local constraints=()
    local pk=false

    printf "%*s" $(( (term_cols - 30) / 2 )) ""
    tput setaf 3; tput bold
    printf "Table Name : "
    tput sgr0
    read tableName
    echo ""

    _is_not_empty "$tableName" "Table name" || return
    _is_valid_identifier "$tableName" "Table name" || return
    if _file_exists "$DB_ROOT/$database_name/.$tableName.meta"; then
        tput setaf 1; tput bold
        center "  Table '$tableName' already exists."
        tput sgr0
        read -p "  Press Enter to continue..."
        return
    fi

    


    printf "%*s" $(( (term_cols - 30) / 2 )) ""
    tput setaf 3; tput bold
    printf "No of Columns : "
    tput sgr0
    read num_columns
    echo ""

    _is_positive_integer "$num_columns" "Number of columns" || return
    
    while [ $i -lt $num_columns ]; do
        center "--------------------------------------"
        while true; do
            local duplicate=false
            printf "%*s" $(( (term_cols - 30) / 2 )) ""
            tput setaf 3; tput bold
            printf "Column %d Name : " $((i + 1))
            tput sgr0
            read column_name
            echo ""

            _is_not_empty "$column_name" "Column name" || continue
            _is_valid_identifier "$column_name" "Column name" || continue

            for col in "${columns[@]}"; do
                if [ "$col" == "$column_name" ]; then
                    duplicate=true
                    tput setaf 1; tput bold
                    center "  Column '$column_name' already exists."
                    tput sgr0
                    break
                fi
            done
            if [ "$duplicate" == "true" ]; then
                continue
            fi
            break
        done
        columns[$i]="$column_name"

        while true; do 
            printf "%*s" $(( (term_cols - 30) / 2 )) ""
            tput setaf 3; tput bold
            echo "the valid types: int, float, bool or str"
            printf "%*s" $(( (term_cols - 30) / 2 )) ""
            printf "Column %d Type : " $((i + 1))
            tput sgr0
            read column_type
            echo ""

            _valid_type "$column_type" || continue
            break
        done
        types[$i]="$column_type"

        while true; do   
            printf "%*s" $(( (term_cols - 30) / 2 )) ""
            tput setaf 3; tput bold
            echo "the valid constraints: PK, FK, UNIQUE, NOT NULL or just press enter for no constraint"
            printf "%*s" $(( (term_cols - 30) / 2 )) ""
            printf "Column %d Constraint : " $((i + 1))
            tput sgr0
            read column_constraint
        echo ""

        _valid_constraint "$column_constraint" || continue
        if [ "$column_constraint" == "PK" ]; then
            if [ "$pk" == "true" ]; then
                tput setaf 1; tput bold
                center "  tha table must got just one PK"
                tput sgr0
                continue
            fi
            pk=true
        fi
        break
        done

        constraints[$i]="$column_constraint"
        ((i++))
        center "--------------------------------------"
        echo ""
        echo ""
    done

    if [ "$pk" == "false" ]; then
        tput setaf 1; tput bold
        center "  the table must got a PK"
        tput sgr0
        read -p "  Press Enter to continue..."
        return
    fi

    touch "$DB_ROOT/$database_name/.$tableName.meta"
    touch "$DB_ROOT/$database_name/$tableName.data"
    for i in "${!columns[@]}"; do
        echo "${columns[$i]}:${types[$i]}:${constraints[$i]}" >> "$DB_ROOT/$database_name/.$tableName.meta"
    done

    center "Table '$tableName' created successfully."
    read -p "Press Enter to continue..."


}