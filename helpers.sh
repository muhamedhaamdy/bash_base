#  Validate a value against its declared type 
_validate_value() {
    local value="$1" type="$2"
    case "$type" in
        int)   [[ "$value" =~ ^[0-9]+$          ]] || { echo " Must be a whole number";   return 1; } ;;
        float) [[ "$value" =~ ^[0-9]*\.[0-9]+$  ]] || { echo " Must be a decimal number"; return 1; } ;;
        str)   [[ -n "$value"                   ]] || { echo " Value cannot be empty";    return 1; } ;;
        *)     echo " Unknown type '$type'";           return 1 ;;
    esac
}

#  Check if PK value already exists in the data file
_pk_exists() {
    local pk_value="$1"
    local pk_col_index="$2"
    local data_file="$3"
    cut -d: -f$((pk_col_index + 1)) "$data_file" | grep -qx "$pk_value"
}

#  Parse .meta file into columns[], types[], pk_index 
_parse_schema() {
    local meta_file="$1"
    columns=()
    types=()
    pk_index=0
    local i=0

    while IFS=: read -r col type flag; do
        columns+=("$col")
        types+=("$type")
        [[ "$flag" == "PK" ]] && pk_index=$i
        (( i++ ))
    done < "$meta_file"
}

# Check if a string is empty
_is_not_empty() {
    local value="$1"
    local field_name="${2:-Field}"
    if [[ -z "$value" ]]; then
        tput setaf 1; tput bold
        center "  $field_name cannot be empty."
        tput sgr0
        read -p "  Press Enter to continue..."
        return 1
    fi
    return 0
}

# Check if a string is a valid identifier (starts with letter, contains A-Z, 0-9, _)
_is_valid_identifier() {
    local value="$1"
    local field_name="${2:-Name}"
    if [[ ! "$value" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
        tput setaf 1; tput bold
        center "  Invalid $field_name. Must start with a letter and contain only letters, digits, or underscores."
        tput sgr0
        read -p "  Press Enter to continue..."
        return 1
    fi
    return 0
}

# Check if a number is a positive integer (> 0)
_is_positive_integer() {
    local value="$1"
    if ! [[ "$value" =~ ^[1-9][0-9]*$ ]]; then
        tput setaf 1; tput bold
        center "  Invalid number. Must be an integer greater than 0."
        tput sgr0
        read -p "  Press Enter to continue..."
        return 1
    fi
    return 0
}

# Check if a directory exists
_directory_exists() {
    local dir_path="$1"
    if [[ -d "$dir_path" ]]; then
        return 0
    else
        return 1
    fi
}

# Check if a file exists
_file_exists() {
    local file_path="$1"
    if [[ -f "$file_path" ]]; then
        return 0
    else
        return 1
    fi
}

_valid_type() {
    if [[ "$1" != "int" && "$1" != "float" && "$1" != "str" && "$1" != "bool" ]]; then
        tput setaf 1; tput bold
        center "  Invalid type. Must be 'int', 'float', or 'str'."
        tput sgr0
        read -p "  Press Enter to continue..."
        return 1
    fi
    return 0
}

_valid_constraint() {
    if [[ "$1" != "PK" && "$1" != "FK" && "$1" != "UNIQUE" && "$1" != "NOT NULL" && "$1" != "" ]]; then
        tput setaf 1; tput bold
        center "  Invalid constraint. Must be 'PK', 'FK', 'UNIQUE', or 'NOT NULL'."
        tput sgr0
        read -p "  Press Enter to continue..."
        return 1
    fi
    return 0
}

# Print column names
_print_headers() {
    local IFS=:
    echo "${columns[*]}"
}

# Get 1-based awk index of a column by name, returns 1 on fail
_col_index() {
    local col_name="$1"
    for i in "${!columns[@]}"; do
        [[ "${columns[$i]}" == "$col_name" ]] && echo $((i + 1)) && return 0
    done
    return 1
}

# Print in columns
_display_results() {
    local header="$1" body="$2"
    [[ -z "$body" ]] && center " No records found." && return
    { echo "$header"; echo "$body"; } | column -t -s:
}