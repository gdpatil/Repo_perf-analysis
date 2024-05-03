#!/bin/bash
#*
#*----------------------------------------------------------------------------------------
#*
#* DISCLAIMER: This script is created for custom purposes to analyze specific resource utilization and process utilization. 
#* It is provided as-is, without warranty of any kind.
#*
#*----------------------------------------------------------------------------------------
#*
#*To execute the script, you need to provide the following inputs:
# $1 = interval (execution_time) value in seconds: specifies the interval at which you want to repeat and append the command output to the output file.
# $2 = iterations (num_iterations) value as a number: determines how many outputs you want to save in the output file.
# $3 = log directory (log_directory) value as a string: specifies the location of the log file where there is sufficient space available to save the logs.
# $4 = days of logs to keep (days_to_keep) value as a number: indicates how many days of logs you want to retain in the log directory.
#*To set up the cron job, refer to the example below:
#
# crontab -u root -e 
# 01 * * * * /bin/bash  /<path>/perf-analyse.sh 20 181 /<log_directory location>  1
# This cron job is set to create a new file every hour.
#*-----------------------------------------------------------------------------------------


# Check if required arguments are provided
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <execution_time_seconds> <num_iterations> <log_directory> <days_to_keep>"
    exit 1
fi

# Assign command line arguments to variables
execution_time="$1"
num_iterations="$2"
log_directory="$3"
days_to_keep="$4"

# Define interfaces
interfaces=("eth0" "eth1")


# Define commands
commands=(
    "vmstat"
    "vmstat -d"
    "ss -s"
    "cat /proc/meminfo"
    "cat /proc/slabinfo"
    "ps -eo user,pid,%cpu,%mem,vsz,rss,tty,stat,start,time,wchan:32,args"
    "ss -neopa"
    "iostat $execution_time 1 -t -k -x -N"
    "top -c -b -d $execution_time -n 1"
    "mpstat $execution_time 1 -P ALL"
	"pidstat"
)

# Define output filenames
output_filenames=(
    "vmstat.log"
    "vmstat-d.log"
    "netstat.log"
    "meminfo.log"
    "slabinfo.log"
    "ps.log"
    "netstat-neopa.log"
    "iostat.log"
    "top.log"
    "mpstat.log"
	"pidstat.log"
)

# Create an output files with date and time
current_datetime=$(date +%Y%m%d-%H%M%S)

# Run commands and append output to the corresponding file
for ((i = 0; i < num_iterations; i++)); do
    for index in "${!commands[@]}"; do
        command="${commands[index]}"
        output_file="${log_directory}/${current_datetime}-${output_filenames[index]}"
	echo "$(date '+%Y-%m-%d %H:%M:%S') Executing command: $command" >> "$output_file"
        $command >> "$output_file" &
    done

    # Run ethtool -S for each interface
    for interface in "${interfaces[@]}"; do
        ethtool_output_file="${log_directory}/${current_datetime}-ethtool-${interface}.log"
        echo "$(date '+%Y-%m-%d %H:%M:%S') Executing command: ethtool -S $interface" >> "$ethtool_output_file"
        ethtool -S "$interface" >> "$ethtool_output_file" &
    done

    sleep "$execution_time"
done

# Remove old log files
find "$log_directory" -type f -mtime +$days_to_keep -delete