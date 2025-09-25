#' Run a function with Telegram notifications
#'
#' Wraps a function so that its execution sends a Telegram notification
#' on error, and optionally on success.
#'
#' @param fun A function to wrap.
#' @param task_name A character string, name of the task (appears in the notification).
#' @param notify_success Logical, whether to send a notification when the function succeeds.
#'
#' @return A wrapped function with the same arguments as `fun`.
#' @export
#'
#' @examples
#' \dontrun{
#'   good_fun <- function(x) x^2
#'   bad_fun  <- function(x) stop("Oops")
#'
#'   safe_good <- run_with_notification(good_fun, task_name = "Square", notify_success = TRUE)
#'   safe_bad  <- run_with_notification(bad_fun,  task_name = "Crasher", notify_success = TRUE)
#'
#'   safe_good(3) # sends success message
#'   safe_bad(3)  # sends error message
#' }
run_with_notification <- function(fun, task_name = "Task", notify_success = FALSE) {
  if (!is.function(fun)) {
    stop(paste(fun, "is not a function"))
  }
  
  function(...) {
    start_time <- Sys.time()
    tryCatch({
      result <- fun(...)
      if (notify_success) {
        duration <- round(difftime(Sys.time(), start_time, units = "secs"), 1)
        send_telegram_message(paste(task_name, "finished in", duration, "sec"))
      }
      invisible(result)
    }, error = function(e) {
      send_telegram_message(paste(task_name, "failed with error:\n", e$message))
      stop(e)
    })
  }
}
