#' Send a file to Telegram
#'
#' Sends a file to a Telegram chat. Supports `.jpeg` images (sent as photos)
#' and text-based files (`.txt`, `.csv`, `.log`) sent as documents.
#'
#' @param file Path to the file.
#' @param caption Optional caption (works only for images).
#'
#' @return The response from the Telegram API (httr response object).
#' @export
#'
#' @examples
#' \dontrun{
#'   send_telegram_file("plot.jpeg", caption = "My plot")
#'   send_telegram_file("logfile.txt")
#' }
send_telegram_file <- function(file, caption = NULL) {
  token <- Sys.getenv("TELEGRAM_BOT_TOKEN")
  chat_id <- Sys.getenv("TELEGRAM_CHAT_ID")
  if (token == "" || chat_id == "") stop("Set TELEGRAM_BOT_TOKEN and TELEGRAM_CHAT_ID in .Renviron")
  
  ext <- tolower(tools::file_ext(file))
  
  if (ext %in% c("jpg", "jpeg")) {
    url <- sprintf("https://api.telegram.org/bot%s/sendPhoto", token)
    httr::POST(url,
               body = list(chat_id = chat_id,
                           caption = caption,
                           photo = httr::upload_file(file)),
               encode = "multipart")
  } else if (ext %in% c("txt", "csv", "log")) {
    url <- sprintf("https://api.telegram.org/bot%s/sendDocument", token)
    httr::POST(url,
               body = list(chat_id = chat_id,
                           document = httr::upload_file(file)),
               encode = "multipart")
  } else {
    stop("Only .jpeg images and .txt/.csv/.log text files are supported.")
  }
}
