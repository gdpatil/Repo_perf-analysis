# Performance Analysis Bash Script

## Description
This bash script is designed for custom purposes to analyze specific resource utilization and process utilization. 
It gathers data related to system performance by executing various commands and saves the output to log files. 
The script is intended to be run periodically to monitor system performance over time.

### DISCLAIMER
This script is provided as-is, without warranty of any kind. Use it at your own risk.

## Prerequisites
- Bash shell
- Linux system

## Usage
To execute the script, provide the following inputs:
$ ./perf-analyse.sh <execution_time_seconds> <num_iterations> <log_directory> <days_to_keep>

- `<execution_time_seconds>`: Interval at which the script repeats execution and appends command output to the output file (in seconds).
- `<num_iterations>`: Number of times to repeat execution and save output in the output file.
- `<log_directory>`: Path to the directory where log files will be saved.
- `<days_to_keep>`: Number of days to retain log files in the log directory.

## Cron Job Setup
To schedule the script to run periodically, set up a cron job. Here's an example:

Run the script every hour
01 * * * * /bin/bash /path/to/perf-analyse.sh 20 181 /path/to/log_directory 1

This cron job creates a new log file every hour.

## Commands and Output
The script executes various commands to collect system performance data, including:
- vmstat
- vmstat -d
- ss -s
- cat /proc/meminfo
- cat /proc/slabinfo
- ps -eo user,pid,%cpu,%mem,vsz,rss,tty,stat,start,time,wchan:32,args
- ss -neopa
- iostat
- top
- mpstat

The output of each command is saved to a corresponding log file in the specified log directory.

## Interfaces
The script also executes the "ethtool -S" command for each interface defined in the script. The output for each interface is saved to a separate log file.
You need to provide the interfaces list manually. If there is only one interface, mention only one; if there are more than two interfaces, update accordingly.

# Define interfaces for single interface
interfaces=("eth0")

# Define interfaces for more than one interface
interfaces=("eth0" "eth1" "eth2")

## Removing Old Log Files
The script removes old log files from the log directory based on the specified number of days to keep.

## Cusomize the commands 
You can customize the script with your own set of commands.
You just need to edit the "commands" array list and the "output_filenames" array list with the same sequence number as your commands section.
