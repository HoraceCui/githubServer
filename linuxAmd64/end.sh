#!/bin/bash
set -e




echo "sleep start"
#sleep 0.08h # Prevent to killing instance after failure
#timeout 20m ping -i 20 www.google.com | awk '{ echo  $0"\t" }' || echo "Error: $?"
#timeout 1.1m watch -n 20 date || echo "Error: $?"
#cat ~/.ssh/authorized_keys



# 设置循环结束时间（3分钟后）
start_time=$(date +%s)
end_time=$((start_time + 20880))  # 180秒 = 3分钟

# 要查找的文件路径
file_path="/home/runner/1.txt"

while [[ $(date +%s) -lt $end_time && ! -f "$file_path" ]]; do
  # 在这里写要执行的命令
  echo "循环正在运行..."
  sleep 20  # 每5秒检查一次文件是否存在
done

echo "sleep end"