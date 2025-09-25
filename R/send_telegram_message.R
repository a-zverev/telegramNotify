#' Send a message to Telegram
#'
#' Sends a plain text message to a Telegram chat using a bot.
#'
#' @param text A character string, the message to send.
#'
#' @return The response from the Telegram API (httr response object).
#' @export
#'
#' @examples
#' \dontrun{
#'   send_telegram_message("Hello from R!")
#' }
send_telegram_message <- function(text) {
  token <- Sys.getenv("TELEGRAM_BOT_TOKEN")
  chat_id <- Sys.getenv("TELEGRAM_CHAT_ID")
  if (token == "" || chat_id == "") stop("Set TELEGRAM_BOT_TOKEN and TELEGRAM_CHAT_ID in .Renviron")
  
  url <- sprintf("https://api.telegram.org/bot%s/sendMessage", token)
  httr::POST(url, body = list(chat_id = chat_id, text = text), encode = "form")
}
