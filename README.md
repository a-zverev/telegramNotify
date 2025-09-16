# telegramNotify

Tiny R package for sending Telegram notifications.

## Installation

```r
# Install devtools if you don't have it
install.packages("devtools")

# Install from GitHub (after you upload it)
devtools::install_github("a-zverev/telegramNotify")
```

Or install from tar.gz:

```r
install.packages("telegramNotify_0.2.0.tar.gz", repos = NULL, type = "source")
```

## Setup

Create a new bot on BotFather. Send something to your bot. Get your `chat_id` from https://api.telegram.org/bot<YOUR_TOKEN>/getUpdates

Add your bot token and chat id to `~/.Renviron`:

```
TELEGRAM_BOT_TOKEN=123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11
TELEGRAM_CHAT_ID=123456789
```

Then reload R or run `readRenviron("~/.Renviron")`.

## Usage

```r
library(telegramNotify)

# Send a message
send_telegram_message("Hello from R!")

# Send a JPG/PNG file, or convert other images to JPG before sending
send_telegram_file("plot.png", caption = "My plot")

# Run code with notification
result <- run_with_notify({
  Sys.sleep(3)
  2 + 2
}, success_msg = "Computation finished!")

# Run code with error notification only
run_with_error_notify({
  stop("Something went wrong")
})

# Decorator-like wrapper
f <- function(x) { x + 1 }
safe_f <- notify_on_error(f, notify_success = TRUE)
safe_f(10)
```
