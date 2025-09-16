notify_on_error <- function(fun, task_name = "Task", notify_success = FALSE) {
  if (!is.function(fun)) {
    stop(paste(fun, "is not a function"))
  }
  function(...) {
    fun_wrapper(fun, ..., task_name = task_name, notify_success = notify_success)
  }
}

fun_wrapper <- function(fun, ..., task_name = "Task", notify_success = FALSE) {
  if (!is.function(fun)) {
    stop(paste(fun, "is not a function"))
  }
  start_time <- Sys.time()
  tryCatch({
    result <- fun(...)
    if (notify_success) {
      duration <- round(difftime(Sys.time(), start_time, units = "secs"), 1)
      send_telegram_message(paste0("✅ ", task_name, "is ready in ", duration, " sec."))
    }
    invisible(result)
  }, error = function(e) {
    send_telegram_message(paste0("❌ ", task_name, " failed with error:\n", e$message))
    stop(e)
  })
}
