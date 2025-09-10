notify_on_error <- function(fun, task_name = "Задача", notify_success = FALSE) {
  if (!is.function(fun)) {
    stop("Передана не функция")
  }
  function(...) {
    run_with_error_notify(fun, ..., task_name = task_name, notify_success = notify_success)
  }
}
