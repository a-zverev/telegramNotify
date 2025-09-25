send_telegram_message <- function(text) {
  token <- Sys.getenv("TELEGRAM_BOT_TOKEN")
  chat_id <- Sys.getenv("TELEGRAM_CHAT_ID")
  if (token == "" || chat_id == "") stop("Set TELEGRAM_BOT_TOKEN and TELEGRAM_CHAT_ID in .Renviron")
  url <- sprintf("https://api.telegram.org/bot%s/sendMessage", token)
  httr::POST(url, body = list(chat_id = chat_id, text = text), encode = "form")
}

send_telegram_file <- function(file, caption = NULL) {
  token <- Sys.getenv("TELEGRAM_BOT_TOKEN")
  chat_id <- Sys.getenv("TELEGRAM_CHAT_ID")
  if (token == "" || chat_id == "") stop("Set TELEGRAM_BOT_TOKEN and TELEGRAM_CHAT_ID in .Renviron")

  ext <- tools::file_ext(file)
  url_base <- sprintf("https://api.telegram.org/bot%s", token)

  if (tolower(ext) %in% c("jpg", "jpeg", "png")) {
    url <- paste0(url_base, "/sendPhoto")
    httr::POST(url,
      body = list(chat_id = chat_id, caption = caption, photo = httr::upload_file(file)),
      encode = "multipart"
    )
  } else {
    tmpfile <- tempfile(fileext = ".jpg")
    tryCatch({
      img <- magick::image_read(file)
      img <- magick::image_convert(img, format = "jpg")
      magick::image_write(img, path = tmpfile, format = "jpg")
      url <- paste0(url_base, "/sendPhoto")
      res <- httr::POST(url,
        body = list(chat_id = chat_id, caption = caption, photo = httr::upload_file(tmpfile)),
        encode = "multipart"
      )
      unlink(tmpfile)
      return(res)
    }, error = function(e) {
      stop("Unsupported file format and conversion failed.")
    })
  }
}

run_with_notify <- function(expr, success_msg = "Process finished") {
  tryCatch({
    result <- force(expr)
    send_telegram_message(success_msg)
    return(result)
  }, error = function(e) {
    send_telegram_message(paste("Error:", e$message))
    stop(e)
  })
}

run_with_error_notify <- function(expr) {
  tryCatch({
    force(expr)
  }, error = function(e) {
    send_telegram_message(paste("Error:", e$message))
    stop(e)
  })
}

notify_on_error <- function(fun, notify_success = FALSE) {
  force(fun)
  function(...) {
    tryCatch({
      result <- fun(...)
      if (notify_success) send_telegram_message("Success")
      return(result)
    }, error = function(e) {
      send_telegram_message(paste("Error:", e$message))
      stop(e)
    })
  }
}
