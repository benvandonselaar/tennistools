#' Generate a Round-Robin Match Schedule
#'
#' Creates a complete round-robin schedule using the \emph{circle method},
#' so that every player (or team) faces every other player exactly once.
#' If the number of players is odd, a dummy "bye" player is added automatically
#' and any match involving the bye is labelled as a bye round.
#'
#' @param players Character vector. Names of the players (or teams) to schedule.
#'   Must contain at least 2 players.
#' @param shuffle Logical. If \code{TRUE} (default), randomise the player order
#'   before generating the schedule. Set to \code{FALSE} for a deterministic
#'   schedule.
#' @param seed Integer (optional). Random seed used when \code{shuffle = TRUE}.
#'   Default is \code{NULL} (no fixed seed).
#'
#' @return A data frame with columns:
#'   \describe{
#'     \item{round}{Integer. The round number.}
#'     \item{match}{Integer. The match number within the round.}
#'     \item{player_1}{Character. Name of the first player.}
#'     \item{player_2}{Character. Name of the second player.}
#'     \item{bye}{Logical. \code{TRUE} if one player has a bye this round.}
#'   }
#'
#' @examples
#' generate_round_robin(c("Jan", "Piet", "Greetje", "Joke"))
#'
#' # Odd number of players (bye rounds added automatically)
#' generate_round_robin(c("Jan", "Piet", "Greetje"), shuffle = FALSE)
#'
#' @export
generate_round_robin <- function(players, shuffle = TRUE, seed = NULL) {
  if (!is.character(players) || length(players) < 2) {
    stop("'players' must be a character vector with at least 2 players.")
  }

  if (shuffle) {
    if (!is.null(seed)) set.seed(seed)
    players <- sample(players)
  }

  # Add bye if odd number of players
  bye_added <- FALSE
  if (length(players) %% 2 != 0) {
    players  <- c(players, "BYE")
    bye_added <- TRUE
  }

  n       <- length(players)
  n_rounds <- n - 1
  n_matches_per_round <- n / 2

  # Circle method: fix the last player, rotate the rest
  fixed    <- players[n]
  rotating <- players[-n]

  results <- data.frame(
    round    = integer(),
    match    = integer(),
    player_1 = character(),
    player_2 = character(),
    bye      = logical(),
    stringsAsFactors = FALSE
  )

  for (r in seq_len(n_rounds)) {
    # Build the circle for this round
    circle <- c(fixed, rotating)

    for (m in seq_len(n_matches_per_round)) {
      p1  <- circle[m]
      p2  <- circle[n - m + 1]
      bye <- (p1 == "BYE" || p2 == "BYE")

      results <- rbind(results, data.frame(
        round    = r,
        match    = m,
        player_1 = ifelse(p1 == "BYE", p2, p1),
        player_2 = ifelse(p1 == "BYE", "BYE", p2),
        bye      = bye,
        stringsAsFactors = FALSE
      ))
    }

    # Rotate: move last element of rotating to the front
    rotating <- c(rotating[length(rotating)], rotating[-length(rotating)])
  }

  # Remove BYE from player_2 label for readability (already in bye column)
  results$player_2[results$player_2 == "BYE"] <- "(bye)"

  return(results)
}
