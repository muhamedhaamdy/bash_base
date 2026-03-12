#!/bin/bash

main() {

    source ./databaseController/create_database.sh
    source ./databaseController/list_database.sh
    source ./databaseController/connect_database.sh
    source ./databaseController/delete_database.sh

    rows=$(tput lines)
    term_cols=$(tput cols)

    DB_ROOT="./Databases"
    current_db=""
    valid_string="^[a-zA-Z][a-zA-Z0-9_]*$"

    mkdir -p "$DB_ROOT"


    center() {
        local text="$1"
        local clean_text
        clean_text=$(echo -e "$text" | sed 's/\x1b\[[0-9;]*m//g')
        local padding=$(( (term_cols - ${#clean_text}) / 2 ))
        (( padding < 0 )) && padding=0
        printf "%*s%s\n" "$padding" "" "$text"
    }

    RED=$(tput setaf 1)
    YELLOW=$(tput setaf 3)
    CYAN=$(tput setaf 6)
    WHITE=$(tput setaf 7)
    BOLD=$(tput bold)
    RESET=$(tput sgr0)


    while true; do
        clear

        echo ""
        tput setaf 6; tput bold
        center "  ██████╗ ██╗  ██╗███████╗██╗     ██╗     ██████╗  █████╗ ███████╗███████╗"
        center " ██╔════╝ ██║  ██║██╔════╝██║     ██║     ██╔══██╗██╔══██╗██╔════╝██╔════╝"
        center " ╚█████╗  ███████║█████╗  ██║     ██║     ██████╔╝███████║███████╗█████╗  "
        center "  ╚═══██╗ ██╔══██║██╔══╝  ██║     ██║     ██╔══██╗██╔══██║╚════██║██╔══╝  "
        center " ██████╔╝ ██║  ██║███████╗███████╗███████╗██████╔╝██║  ██║███████║███████╗"
        center " ╚═════╝  ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝"
        tput sgr0
        echo ""

        tput setaf 3
        center "▸  Your lightweight Bash-powered Database Engine  ◂"
        tput sgr0
        echo ""

        tput setaf 6
        center "╔══════════════════════════════════════╗"
        center "║           ⚡  MAIN  MENU  ⚡           ║"
        center "╠══════════════════════════════════════╣"
        tput sgr0

        tput setaf 7
        center "║                                      ║"
        center "║   $(tput setaf 3)[1]$(tput setaf 7)  Create Database               ║"
        center "║   $(tput setaf 3)[2]$(tput setaf 7)  List Databases                ║"
        center "║   $(tput setaf 3)[3]$(tput setaf 7)  Connect to Database           ║"
        center "║   $(tput setaf 3)[4]$(tput setaf 7)  Drop Database                 ║"
        center "║                                      ║"
        tput setaf 1
        center "║   $(tput setaf 1)[5]$(tput setaf 7)  Exit                          ║"
        center "║                                      ║"
        tput setaf 6
        center "╚══════════════════════════════════════╝"
        tput sgr0

        echo ""
        tput setaf 3
        center "──────────────────────────────────────"
        tput sgr0

        echo ""
        printf "%*s" $(( (term_cols - 10) / 2 )) ""
        tput setaf 6; tput bold
        printf "Choice ➜  "
        tput sgr0
        read choice

        echo ""

        case $choice in
            1)
                create_database
                ;;
            2)
                list_databases
                ;;
            3)
                connect_database;
                ;;
            4)
                delete_database;
                ;;
            5)
                clear
                tput setaf 6; tput bold
                center ""
                center "  Thanks for using ShellBase. Goodbye!  "
                center ""
                tput sgr0
                exit 0
                ;;
            *)
                tput setaf 1
                center "  ✘  Invalid choice — please enter 1 to 5."
                tput sgr0
                read -p "  Press Enter to continue..."
                ;;
        esac
    done
}

main