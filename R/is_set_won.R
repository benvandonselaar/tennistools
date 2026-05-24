#' Check Whether a Tennis Set Has Been Won
#'
#' Determines whether a tennis set is finished based on the current game scores
#' of both players. Follows standard ATP/WTA rules: a set is won at 6 games
#' with a margin of at least 2, or at 7 games (either via 7-5 or a tiebreak 7-6).
#'
#' @param games_a Integer. Number of games won by player A.
#' @param games_b Integer. Number of games won by player B.
#'
#' @return A logical value: \code{TRUE} if the set is complete, \code{FALSE} if
#'   it is still in progress.
#'
#' @examples
#' is_set_won(6, 4)  # TRUE
#' is_set_won(6, 0)  # TRUE
#' is_set_won(7, 6)  # TRUE  (tiebreak)
#' is_set_won(7, 5)  # TRUE
#' is_set_won(6, 5)  # FALSE (must reach 7-5 or tiebreak)
#' is_set_won(5, 3)  # FALSE
#' is_set_won(6, 6)  # FALSE (tiebreak not yet played)
#'
#' @export
is_set_won <- function(games_a, games_b) {
  if (!is.numeric(games_a) || !is.numeric(games_b)) {
    stop("Both arguments must be numeric.")
  }
  if (games_a < 0 || games_b < 0) {
    stop("Game counts cannot be negative.")
  }

  a <- as.integer(games_a)
  b <- as.integer(games_b)

  # Tiebreak result: 7-6
  if ((a == 7 && b == 6) || (a == 6 && b == 7)) return(TRUE)

  # 7-5
  if ((a == 7 && b == 5) || (a == 5 && b == 7)) return(TRUE)

  # Standard win at 6 with at least 2 game lead
  if (a >= 6 && (a - b) >= 2) return(TRUE)
  if (b >= 6 && (b - a) >= 2) return(TRUE)

  return(FALSE)
}
