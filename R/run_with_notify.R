run_with_notify <- function(expr, task_name = "Задача") {
  start_time <- Sys.time()
  tryCatch({
    result <- eval(expr)
    duration <- round(difftime(Sys.time(), start_time, units = "secs"), 1)
    msg <- paste0("✅ ", task_name, " завершена за ", duration, " сек.")
    send_telegram_message(msg)
    invisible(result)
  }, error = function(e) {
    msg <- paste0("❌ ", task_name, " завершилась с ошибкой:\n", e$message)
    send_telegram_message(msg)
    stop(e)
  })
}
