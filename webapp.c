#include <fcgiapp.h>
#include <stdio.h>
#include <stdlib.h>

/*
 * Простое FastCGI приложение.
 * Возвращает "Hello World" при каждом запросе.
 */

int main(void) {
    FCGX_Init(); // Инициализация FastCGI
    FCGX_Request request;
    FCGX_InitRequest(&request, 0, 0);

    while (FCGX_Accept_r(&request) >= 0) {
        // Заголовки HTTP
        FCGX_FPrintF(request.out, "Content-Type: text/plain\r\n\r\n");
        // Ответ
        FCGX_FPrintF(request.out, "Hello World");
        FCGX_Finish_r(&request);
    }

    return 0;
}
