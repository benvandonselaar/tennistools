#' Call a Tennis Score
#'
#' Converts a raw tennis point score (within a game) to the official tennis
#' spoken call, as used by umpires. Handles standard points, deuce, and
#' advantage situations.
#'
#' @param server_points Integer. Number of points won by the server (0–4+).
#' @param receiver_points Integer. Number of points won by the receiver (0–4+).
#'
#' @return A character string with the official tennis score call.
#'
#' @examples
#' call_score(0, 0)   # "ready? play!"
#' call_score(1, 2)   # "fifteen, thirty"
#' call_score(3, 3)   # "deuce"
#' call_score(4, 3)   # "advantage, server"
#' call_score(3, 4)   # "advantage, receiver"
#' call_score(4, 2)   # "game, server"
#' call_score(2, 4)   # "game, receiver"
#'
#' @export
call_score <- function(server_points, receiver_points) {
  point_names <- c("love", "fifteen", "thirty", "forty")

  # Validate input
  if (!is.numeric(server_points) || !is.numeric(receiver_points)) {
    stop("Both arguments must be numeric.")
  }
  if (server_points < 0 || receiver_points < 0) {
    stop("Points cannot be negative.")
  }

  s <- as.integer(server_points)
  r <- as.integer(receiver_points)

  # Opening call
  if (s == 0 && r == 0) {
    return("ready? play!")
  }

  # Game won (no deuce situation yet)
  if (s >= 4 && r <= 2 && (s - r) >= 2) {
    return("game, server")
  }
  if (r >= 4 && s <= 2 && (r - s) >= 2) {
    return("game, receiver")
  }

  # Deuce / advantage territory (both have reached 3+)
  if (s >= 3 && r >= 3) {
    diff <- s - r
    if (diff == 0) return("deuce")
    if (diff == 1) return("advantage, server")
    if (diff == -1) return("advantage, receiver")
    if (diff >= 2) return("game, server")
    if (diff <= -2) return("game, receiver")
  }

  # Standard score (both still below deuce range)
  if (s <= 3 && r <= 3) {
    return(paste0(point_names[s + 1], ", ", point_names[r + 1]))
  }

  # One player has 4+ points without deuce ever being reached
  if (s >= 4 && (s - r) >= 2) return("game, server")
  if (r >= 4 && (r - s) >= 2) return("game, receiver")

  stop("Invalid score combination.")
}
