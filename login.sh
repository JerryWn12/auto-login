#!/bin/bash

host=$(cat host.txt)

if [ -z "$host" ]; then
    echo "No host.txt file was found, please create it and put the login host in there."
    exit 0
fi

if [ -z "$1" ]; then
    echo "Usage: ./login.sh <account> <password> <interface>"
    exit 0
fi

res=$(curl "http://$host/login?DDDDD=$1&upass=$2&R1=0&R2=&R3=2&R6=0&para=00&0MKKey=123456&buttonClicked=&redirect_url=&err_flag=&username=&password=&user=&cmd=&Login=&v6ip=" \
        -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
        -H 'Accept-Language: zh-CN,zh;q=0.9' \
        -H 'Connection: keep-alive' \
        -H 'Referer: http://'$host'/a70.htm?isReback=1' \
        -H 'Upgrade-Insecure-Requests: 1' \
        -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36' \
        -i -s --interface "$3")

length=$(echo "$res" | grep -i 'Content-length:')

if [[ "$length" =~ Content-length:[[:space:]](4[0-9]*) ]]; then
    echo "Login success"
else
    echo "Something error, login failed."
    echo "Content length: ${BASH_REMATCH[1]}"
fi
