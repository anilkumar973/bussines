LOGFILE="healthlog.txt"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
 
 
 
echo "==================== HEALTH CHECK REPORT ====================" >> $LOGFILE
echo "Timestamp: $TIMESTAMP" >> $LOGFILE
echo "--------------------------------------------------------------" >> $LOGFILE
 
 
echo "System Date & Time: $(date)" >> $LOGFILE
 
echo "--------------------------------------------------------------" >> $LOGFILE
 
 
uptime_formatted=$(awk '{print int($1/3600)" hours "int(($1%3600)/60)" minutes"}' /proc/uptime) >> $LOGFILE
echo "System Uptime: $uptime_formatted" >> $LOGFILE
 
echo "--------------------------------------------------------------" >> $LOGFILE
 
echo "Memory Usage (MB):" >> $LOGFILE
total_mem=$(grep MemTotal /proc/meminfo | awk '{print $2}') >> $LOGFILE
free_mem=$(grep MemAvailable /proc/meminfo | awk '{print $2}') >> $LOGFILE
total_mem_mb=$((total_mem / 1024)) >> $LOGFILE
free_mem_mb=$((free_mem / 1024)) >> $LOGFILE
used_mem_mb=$((total_mem_mb - free_mem_mb)) >> $LOGFILE
echo "Total: ${total_mem_mb} MB" >> $LOGFILE
echo "Used: ${used_mem_mb} MB" >> $LOGFILE
echo "Free: ${free_mem_mb} MB" >> $LOGFILE
 
 
echo "--------------------------------------------------------------" >> $LOGFILE
 
 
echo "CPU Load (1, 5, 15 min): $(cut -d ' ' -f 1-3 /proc/loadavg)" >> $LOGFILE
 
echo "--------------------------------------------------------------" >> $LOGFILE
 
echo -e "\nDisk Usage:" >> $LOGFILE
df -h >> $LOGFILE
echo "" >> $LOGFILE
 
echo "--------------------------------------------------------------" >> $LOGFILE
 
echo -e "\nService Status:" >> $LOGFILE
sc query sshd > /dev/null 2>&1 && echo "SSH: Running " || echo "SSH: Not Running " >> $LOGFILE
sc query nginx > /dev/null 2>&1 && echo "Nginx: Running " || echo "Nginx: Not Running " >> $LOGFILE
 
echo "--------------------------------------------------------------" >> $LOGFILE
 
echo -e "\nTop 5 Memory Consuming Processes:" >> $LOGFILE
wmic process get Name,WorkingSetSize | sort -k2 -n | tail -n 5 >> $LOGFILES