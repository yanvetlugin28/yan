# yan
# FastCGI Webapp с мониторингом

## Описание
Простое FastCGI приложение на C, возвращает "Hello World".
Мониторbyu на Bash следит за приложением и перезапускает его при падении.

## Установка
1. Скопировать все файлы (`webapp.c`, `monitor.sh`, `webapp-monitor.service`, `install.sh`) в каталог.
2. Запустить:
   sudo bash install.sh
