run_with_error_notify <- function(fun, ..., task_name = "Задача", notify_success = FALSE) {
  if (!is.function(fun)) {
    stop("`fun` должен быть функцией")
  }
  start_time <- Sys.time()
  tryCatch({
    result <- fun(...)
    if (notify_success) {
      duration <- round(difftime(Sys.time(), start_time, units = "secs"), 1)
      send_telegram_message(paste0("✅ ", task_name, " завершена за ", duration, " сек."))
    }
    invisible(result)
  }, error = function(e) {
    send_telegram_message(paste0("❌ ", task_name, " завершилась с ошибкой:\n", e$message))
    stop(e)
  })
}
