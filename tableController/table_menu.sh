#!/bin/bash

table_menu() {
    local DIR="$(dirname "${BASH_SOURCE[0]}")"
    
    source "$DIR/list_tables.sh"   
    source "$DIR/create_table.sh"
    source "$DIR/drop_table.sh"
    source "$DIR/insert.sh"       
    source "$DIR/delete.sh"
    source "$DIR/select.sh"
    source "$DIR/update.sh"

    
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
        center "║           ⚡  TABLE  MENU  ⚡           ║"
        center "╠══════════════════════════════════════╣"
        tput sgr0

        tput setaf 7
        center "║                                      ║"
        center "║   $(tput setaf 3)[1]$(tput setaf 7)  Create Table              ║"
        center "║   $(tput setaf 3)[2]$(tput setaf 7)  List Tables               ║"
        center "║   $(tput setaf 3)[3]$(tput setaf 7)  Drop Table                ║"
        center "║   $(tput setaf 3)[4]$(tput setaf 7)  Insert into Table         ║"
        center "║   $(tput setaf 3)[5]$(tput setaf 7)  Select from Table         ║"
        center "║   $(tput setaf 3)[6]$(tput setaf 7)  Update Table Data         ║"
        center "║   $(tput setaf 3)[7]$(tput setaf 7)  Delete from Table         ║"
        center "║                                      ║"
        tput setaf 1
        center "║   $(tput setaf 1)[8]$(tput setaf 7)  Back to Main Menu         ║"
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
        printf "Choice :  "
        tput sgr0
        read choice

        echo ""

        case $choice in
            1)
                create_table
                read -p "  Press Enter to continue..."
                ;;
            2)
                list_tables
                read -p "  Press Enter to continue..."
                ;;
            3)
                drop_table
                read -p "  Press Enter to continue..."
                ;;
            4)
                insert_into_table
                read -p "  Press Enter to continue..."
                ;;
            5)
                select_from_table
                read -p "  Press Enter to continue..."
                ;;
            6)
                update_table  
                read -p "  Press Enter to continue..."
                ;;
            7)
                delete_from_table
                read -p "  Press Enter to continue..."
                ;;
            8)
                current_db=''
                return
                ;;
            *)
                tput setaf 1
                center "  !  Invalid choice — please enter 1 to 8."
                tput sgr0
                read -p "  Press Enter to continue..."
                ;;
        esac
    done
}