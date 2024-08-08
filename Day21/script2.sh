#!/bin/bash
 
THRESHOLD_CPU=80

THRESHOLD_MEM=80
 
get_log_analysis() {

    echo -e "\n Error Logs: "

    echo      "-------------"

    ERROR_LOGS=$(grep -iE "error|critical" /var/log/syslog | tail -n 20)

    echo "$ERROR_LOGS"
 
    echo -e "\n Recent Logs: "

    echo      "--------------"

    RECENT_LOGS=$(tail -n 20 /var/log/syslog)

    echo "$RECENT_LOGS"

}
 
# Create report file

REPORT_FILE="/tmp/system_report_$(date +'%Y%m%d_%H%M%S').txt"

echo "System Report $(date)" >> $REPORT_FILE

get_log_analysis >> $REPORT_FILE
 
# Menu for user selection

echo "Select an option:

1. View logs

2. Exit"
 
read -r choice
 
case $choice in

    1) get_log_analysis ;;

    2) exit ;;

    *) echo "Invalid option" ;;

esac
 
