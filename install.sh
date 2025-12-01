#!/bin/bash
# install.sh — установка FastCGI веб-приложения и мониторинга

set -e

echo "Installing FastCGI webapp..."

# Установка зависимостей
apt-get update
apt-get install -y libfcgi-dev spawn-fcgi cgi-fcgi gcc

# Компиляция приложения
gcc -o webapp webapp.c -lfcgi

# Копируем бинарник и монитор в /usr/local/bin
cp webapp /usr/local/bin/
cp monitor.sh /usr/local/bin/
chmod +x /usr/local/bin/webapp /usr/local/bin/monitor.sh

# Создаем systemd unit
cp webapp-monitor.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable webapp-monitor
systemctl start webapp-monitor

echo "Installation complete!"
echo "Check webapp via:"
echo "  cgi-fcgi -bind -connect /tmp/webapp.sock"
echo "Logs: tail -f /var/log/webapp-monitor.log"
