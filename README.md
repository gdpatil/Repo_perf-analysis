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

## Command Descriptions:

**vmstat**:
Displays system information related to processes, memory, paging, block IO, traps, and CPU activity.
Useful for getting an overall snapshot of the system's performance.

**vmstat -d**:
Provides statistics about disk I/O activities, such as reads and writes on block devices.
Useful for monitoring disk performance.

**ss -s:**
Summarizes socket statistics, showing information about TCP, UDP, and other protocol connections.
Helps in understanding the state of network connections.

**cat /proc/meminfo**:
Displays detailed information about the system's memory usage, including total, free, and cached memory.
Helpful for diagnosing memory issues and monitoring resource consumption.

**cat /proc/slabinfo**:
Shows kernel slab cache information, which is used to monitor the internal memory management of the kernel.
Useful for understanding kernel memory allocations and troubleshooting memory leaks.

**ps -eo user,pid,%cpu,%mem,vsz,rss,tty,stat,start,time,wchan:32,args**:
Lists processes with specific information such as CPU and memory usage, process state, start time, etc.
Useful for identifying resource-hungry processes.

**ss -neopa**:
Displays detailed socket information, including established connections, along with their process IDs (PIDs) and network states.
Helpful for in-depth network analysis and troubleshooting.

**iostat $execution_time 1 -t -k -x -N**:
Monitors disk I/O performance with extended statistics such as read/write rates, device utilization, and more, at intervals of $execution_time seconds.
Valuable for identifying I/O bottlenecks.

**top -c -b -d $execution_time -n 1**:
Shows real-time process monitoring in batch mode (-b), with details about CPU and memory usage of each process.
This is useful for capturing system performance snapshots at intervals.

**mpstat $execution_time 1 -P ALL**:
Reports CPU usage per processor at intervals of $execution_time seconds, showing system and user CPU time for all cores.
Useful for identifying uneven load distribution across CPU cores.

**pidstat**:
Monitors the resource usage of individual processes (e.g., CPU, memory, I/O usage).
Provides detailed insights into process-level performance, which helps in identifying problematic processes.

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
