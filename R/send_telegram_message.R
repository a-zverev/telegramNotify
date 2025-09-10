send_telegram_message <- function(message) {
  bot_token <- Sys.getenv("TELEGRAM_BOT_TOKEN")
  chat_id <- Sys.getenv("TELEGRAM_CHAT_ID")
  if (bot_token == "" || chat_id == "") {
    stop("Telegram token или chat_id не заданы в .Renviron")
  }
  url <- paste0("https://api.telegram.org/bot", bot_token, "/sendMessage")
  try({
    httr::POST(url, body = list(chat_id = chat_id, text = message), encode = "form")
  }, silent = TRUE)
}
