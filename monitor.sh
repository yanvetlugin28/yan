#!/bin/bash
# monitor.sh — мониторинг FastCGI webapp
# Функции:
#   - проверка доступности приложения
#   - логирование результатов
#   - перезапуск приложения при падении

APP="/usr/local/bin/webapp"         
SOCKET="/tmp/webapp.sock"           
LOGFILE="/var/log/webapp-monitor.log"
CHECK_INTERVAL=5                     
STARTUP_DELAY=2                      

[ ! -f "$LOGFILE" ] && touch "$LOGFILE"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> "$LOGFILE"
}

start_app() {
    if pgrep -x webapp > /dev/null; then
        return
    fi

    log "Starting webapp…"
    [ -e "$SOCKET" ] && rm -f "$SOCKET"

    spawn-fcgi -s "$SOCKET" "$APP"
    chmod 666 "$SOCKET"

    sleep $STARTUP_DELAY
}

check_app() {
    if ! pgrep -x webapp > /dev/null; then
        log "FAIL — webapp not running, restarting…"
        start_app
        return
    fi

    if ! cgi-fcgi -bind -connect "$SOCKET" 2>/dev/null | grep -q "Hello World"; then
        log "FAIL — webapp unresponsive, restarting…"
        pkill -x webapp
        start_app
        return
    fi

    log "OK"
}

log "Monitor started"
start_app

while true; do
    check_app
    sleep $CHECK_INTERVAL
done
