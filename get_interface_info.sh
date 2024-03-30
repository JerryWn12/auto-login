#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: ./get_interface_info.sh <interface>"
    echo "<interface>: Specify an interface to show its login information."
    exit 0
fi

echo "Interface: $1"

res=$(curl "http://40.11.3.2" \
        -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
        -H 'Accept-Language: zh-CN,zh;q=0.9' \
        -H 'Connection: keep-alive' \
        -H 'Upgrade-Insecure-Requests: 1' \
        -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36' \
        -i -s --interface "$1")

uid=$(echo "$res" | grep "uid=")

if [[ "$uid" =~ uid=\'([0-9]{11})\'\; ]]; then
    echo "Logged in: yes"
    echo "Account:" "${BASH_REMATCH[1]}"
else
    echo "Haven't logged in yet."
fi