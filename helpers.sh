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