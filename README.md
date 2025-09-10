# telegramNotify 📬

R-пакет для отправки уведомлений и файлов в Telegram при выполнении скриптов или функций.  
Полезно для уведомлений об окончании долгих процессов в RStudio или на сервере.

## 🚀 Установка

Установить напрямую из GitHub (нужен пакет `remotes`):

```r
install.packages("remotes")
remotes::install_github("alekseizverev/telegramNotify")
```

## ⚙️ Настройка

В файл `~/.Renviron` добавь:

```
TELEGRAM_BOT_TOKEN=123456789:ABCdefGhIJKlmnoPQRstuVwxyZ
TELEGRAM_CHAT_ID=987654321
```

После изменения перезапусти R.

## 🧪 Использование

### Отправить сообщение
```r
library(telegramNotify)

send_telegram_message("Привет из R! ✅")
```

### Отправить файл
```r
send_telegram_file("plot.png", caption = "Готовый график 📊")
```

### Выполнить код с уведомлением
```r
run_with_notify({
  Sys.sleep(3)
  log("abc")  # вызовет ошибку
}, task_name = "Тестовый процесс")
```

### Запустить функцию с уведомлениями
```r
slow_fun <- function(x) {
  Sys.sleep(2)
  sqrt(x)
}

safe_fun <- notify_on_error(slow_fun, task_name = "Квадратный корень", notify_success = TRUE)

safe_fun(16)   # получишь сообщение в Telegram
```

## 📜 Лицензия
MIT
