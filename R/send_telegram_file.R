send_telegram_file <- function(file_path, caption = NULL) {
  bot_token <- Sys.getenv("TELEGRAM_BOT_TOKEN")
  chat_id <- Sys.getenv("TELEGRAM_CHAT_ID")
  if (bot_token == "" || chat_id == "") {
    stop("Telegram token or chat_id not set in .Renviron")
  }
  if (!file.exists(file_path)) {
    stop("File not found: ", file_path)
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
  
  body <- list(chat_id = chat_id)
  if (!is.null(caption)) {
    body$caption <- caption
  }
  body[[file_param]] <- httr::upload_file(file_path)
  
  try({
    httr::POST(url, body = body, encode = "multipart")
  }, silent = TRUE)
}
