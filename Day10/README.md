1. Setting Thresholds

THRESHOLD_CPU=80
THRESHOLD_MEM=80

![alt text](<Screenshot from 2024-07-31 14-43-47-1.png>)

THRESHOLD_CPU and THRESHOLD_MEM define the CPU and memory usage thresholds (in percentage) that will be considered high. The script will compare current usage against these thresholds to detect potential issues.


2. Functions
a. get_system_metrics

get_system_metrics() {
    ...
}

![alt text](<Screenshot from 2024-07-31 14-48-21.png>)

CPU Usage: Extracts CPU idle percentage using top and calculates CPU usage.
Memory Usage: Uses free to calculate used memory as a percentage.
Disk Space: Displays available space on the root filesystem using df.
Network Stats: Displays network interface statistics using netstat.
Top Processes: Shows the top 10 processes by CPU usage using top.

b. get_log_analysis

get_log_analysis() {
    ...
}

![alt text](<Screenshot from 2024-07-31 14-49-01.png>)

Error Logs: Searches /var/log/syslog for lines containing "error" or "critical" and shows the last 20 matches.
Recent Logs: Displays the last 20 lines of /var/log/syslog.

c. perform_health_checks

perform_health_checks() {
    ...
}

![alt text](<Screenshot from 2024-07-31 14-49-30.png>)

Service Status: Checks if apache2 and mysql services are active using systemctl.
Connectivity: Pings google.com to check internet connectivity.

3. Threshold Checks

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed 's/.*, *\([0-9.]*\)%* id.*/\1/')
if (( $(echo "$CPU_USAGE >= $THRESHOLD_CPU" | bc -l) )); then
    echo "High CPU usage detected: $CPU_USAGE%"
fi

MEMORY_USAGE=$(free | awk '/Mem/{printf("%.2f"), $3/$2*100}')
if (( $(echo "$MEMORY_USAGE >= $THRESHOLD_MEM" | bc -l) )); then
    echo "High memory usage detected: $MEMORY_USAGE%"
fi

![alt text](<Screenshot from 2024-07-31 14-50-16.png>)

CPU Usage Check: Compares current CPU usage against the defined threshold and prints a warning if it’s high.
Memory Usage Check: Compares current memory usage against the threshold and prints a warning if it’s high.

4. Creating a Report

REPORT_FILE="/tmp/system_report_$(date +'%Y%m%d_%H%M%S').txt"
echo "System Report $(date)" >> $REPORT_FILE
get_system_metrics >> $REPORT_FILE
get_log_analysis >> $REPORT_FILE
perform_health_checks >> $REPORT_FILE

![alt text](<Screenshot from 2024-07-31 14-51-10.png>)

Report File: Creates a timestamped report file in /tmp.
Appending Data: Collects and appends system metrics, logs, and service status to the report file.

5. User Menu

echo "Select an option:
1. Check system metrics
2. View logs
3. Check service status
4. Exit"
read -r choice

case $choice in
    1) get_system_metrics ;;
    2) get_log_analysis ;;
    3) perform_health_checks ;;
    4) exit ;;
    *) echo "Invalid option" ;;
esac

![alt text](<Screenshot from 2024-07-31 14-51-35.png>)

Menu Options: Provides a menu for the user to choose:
1: View system metrics.
2: View logs.
3: Check service status.
4: Exit the script.
Choice Handling: Executes the corresponding function based on the user's choice. If the choice is invalid, it prints an error message.


