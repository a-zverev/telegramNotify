send_telegram_file <- function(file_path, caption = NULL) {
  bot_token <- Sys.getenv("TELEGRAM_BOT_TOKEN")
  chat_id <- Sys.getenv("TELEGRAM_CHAT_ID")
  if (bot_token == "" || chat_id == "") {
    stop("Telegram token или chat_id не заданы в .Renviron")
  }
  if (!file.exists(file_path)) {
    stop("Файл не найден: ", file_path)
  }
  ext <- tolower(tools::file_ext(file_path))
  if (ext %in% c("jpg", "jpeg", "png", "bmp")) {
    method <- "sendPhoto"
    file_param <- "photo"
  } else {
    method <- "sendDocument"
    file_param <- "document"
  }
  url <- paste0("https://api.telegram.org/bot", bot_token, "/", method)
  try({
    httr::POST(
      url,
      body = list(
        chat_id = chat_id,
        caption = caption,
        .name = file_param,
        file = httr::upload_file(file_path)
      ),
      encode = "multipart"
    )
  }, silent = TRUE)
}
