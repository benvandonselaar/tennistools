#' Divide Players into Training Groups
#'
#' Splits a list of players into balanced training groups of a given size.
#' If a \code{levels} vector is provided, players are first sorted by level
#' (highest to lowest) and then distributed across groups using a snake-draft
#' order, so each group gets a balanced mix of strong and weaker players.
#' If no levels are given, players are shuffled randomly before assignment.
#'
#' @param players Character vector. Names of the players to divide.
#' @param group_size Integer. Desired number of players per group (default: 4).
#' @param levels Numeric vector (optional). Skill level for each player,
#'   in the same order as \code{players}. Lower values mean a stronger player.
#'   If \code{NULL} (default), groups are formed by random shuffle.
#' @param seed Integer (optional). Random seed for reproducibility when no
#'   levels are supplied. Default is \code{NULL} (no fixed seed).
#'
#' @return A named list of character vectors, one element per group
#'   (named \code{"Group 1"}, \code{"Group 2"}, etc.).
#'
#' @examples
#' players <- c("Jan", "Piet", "Kees", "Greetje", "Joke", "Herma")
#' make_training_groups(players, group_size = 3)
#'
#' # With skill levels
#' lvls <- c(9, 4, 8, 5, 7, 6)
#' make_training_groups(players, group_size = 3, levels = lvls)
#'
#' @export
make_training_groups <- function(players, group_size = 4, levels = NULL,
                                 seed = NULL) {
  if (!is.character(players) || length(players) == 0) {
    stop("'players' must be a non-empty character vector.")
  }
  if (!is.numeric(group_size) || group_size < 1) {
    stop("'group_size' must be a positive integer.")
  }
  group_size <- as.integer(group_size)

  if (!is.null(levels)) {
    if (length(levels) != length(players)) {
      stop("'levels' must have the same length as 'players'.")
    }
    # Sort by level ascending for snake draft
    order_idx <- order(levels)
    players <- players[order_idx]
  } else {
    if (!is.null(seed)) set.seed(seed)
    players <- sample(players)
  }

  n_players <- length(players)
  n_groups  <- ceiling(n_players / group_size)

  groups <- vector("list", n_groups)
  names(groups) <- paste("Group", seq_len(n_groups))

  for (i in seq_len(n_players)) {
    # Snake draft: alternate direction each round
    round     <- ceiling(i / n_groups)
    pos_in_round <- ((i - 1) %% n_groups) + 1
    if (round %% 2 == 0) {
      group_idx <- n_groups - pos_in_round + 1
    } else {
      group_idx <- pos_in_round
    }
    groups[[group_idx]] <- c(groups[[group_idx]], players[i])
  }

  return(groups)
}
