#!/usr/bin/env bash

# https://gist.github.com/Eising/8620880440016b9227bc31abeca8b1ac

push_url="https://my.uptime.kuma.server/api/push/PUSHURL"
disk="/dev/sda1"  # replace with the disk that you are monitoring
threshold="80"  # 80% seems reasonable, but YMMV

percentage=$(df -hl --total ${disk} | tail -1 | awk '{printf $5}')
number=${percentage%\%*}
message="Used space on ${disk} is ${number}%" 

if [ $number -lt $threshold ]; then
    service_status="up"
else
    service_status="down"
fi

curl \
    --get \
    --data-urlencode "status=${service_status}" \
    --data-urlencode "msg=${message}" \
    --data-urlencode "ping=${number}" \
    --silent \
    ${push_url} \
    > /dev/null
