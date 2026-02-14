cpu_usage=$((100 - $(vmstat 1 2 | tail -1 | awk '{print $15}')))

echo "The CPU usage is $cpu_usage%"
echo

total=$(free | awk '/Mem/ {print $2}')
used=$(free | awk '/Mem/ {print $3}')
free=$(free -h | awk '/Mem/ {print $4}')

echo "$(($used * 100 / $total))% of memory is being used and $free memory is available"
echo

size=$(df | awk '/nvme0n1p2/ {print $2}')
used=$(df | awk '/nvme0n1p2/ {print $3}')
available=$(df -h | awk '/nvme0n1p2/ {print $4}')

echo "$(($used * 100 / $size))% of disk size is being used and $available is available"
echo

echo "The top 5 processes by CPU usage are:"
ps -eo pid,comm,%cpu --sort=-%cpu | head -6 
echo

echo "The top 5 processes by memory usage are:"
ps -eo pid,comm,%mem --sort=-%mem | head -6
echo

echo "The OS version is $(lsb_release -d | cut -f2)"
echo

echo "The system is $(uptime -p)"
echo

echo "The load average is $(awk '{print $1 ", " $2 ", " $3}' /proc/loadavg)"
