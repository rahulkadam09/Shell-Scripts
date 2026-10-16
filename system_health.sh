#!/bin/bash

# ==========================================
# Linux System Health Report
# Compatible with Ubuntu
# ==========================================

# Colors for terminal output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

print_line() {
    echo "--------------------------------------------------"
}

section() {
    echo
    print_line
    echo -e "${BLUE}$1${NC}"
    print_line
}

# 1. System Information
system_info() {
    section "1. SYSTEM INFORMATION"

    echo "Hostname          : $(hostname)"
    echo "Operating System  : $(. /etc/os-release && echo "$PRETTY_NAME")"
    echo "Kernel Version    : $(uname -r)"
    echo "Architecture      : $(uname -m)"
    echo "Current Date      : $(date)"
    echo "System Uptime     : $(uptime -p)"
    echo "Last Boot         : $(who -b | awk '{print $3, $4}')"
}

# 2. CPU Information
cpu_info() {
    section "2. CPU INFORMATION"

    echo "CPU Model         : $(awk -F ': ' '/model name/ {print $2; exit}' /proc/cpuinfo)"
    echo "Logical CPU Cores : $(nproc)"

    # Read CPU usage over a short interval
    read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
    total1=$((user + nice + system + idle + iowait + irq + softirq + steal))
    idle1=$((idle + iowait))

    sleep 1

    read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
    total2=$((user + nice + system + idle + iowait + irq + softirq + steal))
    idle2=$((idle + iowait))

    total_diff=$((total2 - total1))
    idle_diff=$((idle2 - idle1))

    if [ "$total_diff" -gt 0 ]; then
        cpu_usage=$(( (100 * (total_diff - idle_diff)) / total_diff ))
        echo "CPU Usage         : ${cpu_usage}%"
    else
        cpu_usage=0
        echo "CPU Usage         : Unable to calculate"
    fi

    if [ "$cpu_usage" -ge 85 ]; then
        echo -e "${RED}CPU Status        : HIGH usage${NC}"
    elif [ "$cpu_usage" -ge 70 ]; then
        echo -e "${YELLOW}CPU Status        : Elevated usage${NC}"
    else
        echo -e "${GREEN}CPU Status        : Normal usage${NC}"
    fi

    echo
    echo "Load Average      : $(awk '{print $1, $2, $3}' /proc/loadavg)"
    echo "Meaning           : Average system load over 1, 5 and 15 minutes"
}

# 3. Memory Information
memory_info() {
    section "3. MEMORY (RAM) INFORMATION"

    free -b | awk '
    NR==2 {
        total=$2
        used=$3
        available=$7
        printf "Total RAM         : %.2f GB\n", total/1073741824
        printf "Used RAM          : %.2f GB\n", used/1073741824
        printf "Available RAM     : %.2f GB\n", available/1073741824

        if (total > 0) {
            usage=(total-available)*100/total
            printf "RAM Usage         : %.1f%%\n", usage

            if (usage >= 90)
                print "RAM Status        : HIGH usage"
            else if (usage >= 75)
                print "RAM Status        : Elevated usage"
            else
                print "RAM Status        : Normal usage"
        }
    }'

    echo
    echo "Top 5 RAM Consumers:"
    ps -eo user,pid,comm,%mem,rss --sort=-%mem | head -n 6 |
    awk 'NR==1 {printf "%-12s %-8s %-18s %-8s %s\n","USER","PID","PROCESS","MEM%","RAM(MB)"; next}
         {printf "%-12s %-8s %-18s %-8s %.1f\n",$1,$2,$3,$4,$5/1024}'
}

# 4. Disk Storage Information
storage_info() {
    section "4. DISK STORAGE INFORMATION"

    df -hPT -x tmpfs -x devtmpfs |
    awk 'NR==1 {printf "%-22s %-8s %-8s %-8s %-7s %s\n","FILESYSTEM","TYPE","SIZE","USED","USE%","MOUNT"}
         NR>1 {
             printf "%-22s %-8s %-8s %-8s %-7s %s\n",$1,$2,$3,$4,$6,$7
         }'

    echo
    echo "Root Filesystem Summary:"
    df -hP / | awk '
    NR==2 {
        printf "Total Disk Space    : %s\n", $2
        printf "Used Disk Space     : %s\n", $3
        printf "Available Disk Space: %s\n", $4
        printf "Disk Usage          : %s\n", $5

        usage=$5
        sub(/%/,"",usage)

        if (usage >= 90)
            print "Disk Status         : CRITICAL - almost full"
        else if (usage >= 75)
            print "Disk Status         : WARNING - usage elevated"
        else
            print "Disk Status         : Normal"
    }'
}

# 5. Top CPU Consumers
top_cpu_processes() {
    section "5. TOP 5 CPU-CONSUMING PROCESSES"

    ps -eo user,pid,comm,%cpu,%mem --sort=-%cpu | head -n 6 |
    awk 'NR==1 {printf "%-12s %-8s %-18s %-8s %s\n","USER","PID","PROCESS","CPU%","MEM%"; next}
         {printf "%-12s %-8s %-18s %-8s %s\n",$1,$2,$3,$4,$5}'
}

# 6. Network Information
network_info() {
    section "6. NETWORK INFORMATION"

    if command -v ip >/dev/null 2>&1; then
        echo "IP Addresses:"
        ip -brief address show | awk '$1!="lo" {print "  " $1 " : " $3}'
        echo
        echo "Default Route:"
        ip route show default | awk 'NR==1 {print "  " $0}'
    else
        echo "Network utility 'ip' is not available."
    fi
}

# 7. System Health Summary
health_summary() {
    section "7. SYSTEM HEALTH SUMMARY"

    # Memory usage percentage based on available RAM
    mem_usage=$(free | awk '/^Mem:/ {
        if ($2 > 0) printf "%.0f", ($2-$7)*100/$2;
        else print 0
    }')

    # Root filesystem usage
    disk_usage=$(df -P / | awk 'NR==2 {gsub(/%/,"",$5); print $5}')

    echo "CPU Usage         : ${cpu_usage:-Unknown}%"
    echo "Memory Usage      : ${mem_usage:-Unknown}%"
    echo "Root Disk Usage   : ${disk_usage:-Unknown}%"
    echo

    if [ "${cpu_usage:-0}" -ge 90 ] ||
       [ "${mem_usage:-0}" -ge 90 ] ||
       [ "${disk_usage:-0}" -ge 90 ]; then
        echo -e "${RED}Overall Status: ATTENTION REQUIRED${NC}"
        echo "At least one major resource is heavily utilized."
    elif [ "${cpu_usage:-0}" -ge 75 ] ||
         [ "${mem_usage:-0}" -ge 75 ] ||
         [ "${disk_usage:-0}" -ge 75 ]; then
        echo -e "${YELLOW}Overall Status: WARNING${NC}"
        echo "Monitor resource usage and investigate if it persists."
    else
        echo -e "${GREEN}Overall Status: HEALTHY${NC}"
        echo "CPU, memory and root disk usage are below warning thresholds."
    fi
}

# Run the complete report
system_info
cpu_info
memory_info
storage_info
top_cpu_processes
network_info
health_summary

echo
print_line
echo "System health report completed at $(date)"
print_line
