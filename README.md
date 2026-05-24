
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tennistools

<!-- badges: start -->

<!-- badges: end -->

The goal of tennistools is to make working with tennis data a little
easier. It provides helper functions for score calling, set validation,
training group division, and round-robin schedule generation — useful
for coaches, players, and anyone organising a tennis tournament.

## Installation

You can install the development version of tennistools from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("benvandonselaar/tennistools")
```

## Usage

### `call_score()`

A common need during a match is translating raw point counts into the
official tennis score call. `call_score()` handles all standard
situations: opening, normal points, deuce, advantage, and game.

``` r
library(tennistools)

call_score(0, 0)   # start of a game
#> [1] "ready? play!"
call_score(1, 2)   # fifteen, thirty
#> [1] "fifteen, thirty"
call_score(3, 3)   # deuce
#> [1] "deuce"
call_score(4, 3)   # advantage server
#> [1] "advantage, server"
call_score(4, 1)   # game server
#> [1] "game, server"
```

### `is_set_won()`

To check whether a set is finished, use `is_set_won()`. It follows
standard ATP/WTA rules, including the 7-5 and tiebreak (7-6) edge cases.

``` r
is_set_won(6, 4)   # TRUE
#> [1] TRUE
is_set_won(7, 6)   # TRUE  — tiebreak
#> [1] TRUE
is_set_won(6, 5)   # FALSE — not yet decided
#> [1] FALSE
is_set_won(6, 6)   # FALSE — tiebreak still to be played
#> [1] FALSE
```

### `make_training_groups()`

Dividing players into balanced groups is a recurring task for coaches.
`make_training_groups()` accepts a vector of player names and an
optional skill level per player. When levels are provided, a snake-draft
ensures every group gets a fair mix of strong and weaker players.

``` r
players <- c("Jan", "Piet", "Kees", "Greetje", "Joke", "Herma")
levels  <- c(9, 4, 8, 5, 7, 6)

make_training_groups(players, group_size = 3, levels = levels)
#> $`Group 1`
#> [1] "Piet" "Joke" "Kees"
#> 
#> $`Group 2`
#> [1] "Greetje" "Herma"   "Jan"
```

Without levels, players are shuffled randomly. Use `seed` for
reproducibility:

``` r
make_training_groups(players, group_size = 3, seed = 42)
#> $`Group 1`
#> [1] "Jan"     "Greetje" "Piet"   
#> 
#> $`Group 2`
#> [1] "Joke"  "Herma" "Kees"
```

### `generate_round_robin()`

To make sure everyone plays against everyone, `generate_round_robin()`
builds a complete schedule using the circle method. It works with any
number of players; if the count is odd, a bye is added automatically.

``` r
generate_round_robin(c("Jan", "Piet", "Greetje"), shuffle = FALSE)
#>   round match player_1 player_2   bye
#> 1     1     1  Greetje    (bye)  TRUE
#> 2     1     2      Jan     Piet FALSE
#> 3     2     1     Piet    (bye)  TRUE
#> 4     2     2  Greetje      Jan FALSE
#> 5     3     1      Jan    (bye)  TRUE
#> 6     3     2     Piet  Greetje FALSE
```

Use `seed` to get the same randomised draw every time:

``` r
generate_round_robin(c("Jan", "Piet", "Kees", "Greetje"), seed = 7)
#>   round match player_1 player_2   bye
#> 1     1     1  Greetje      Jan FALSE
#> 2     1     2     Piet     Kees FALSE
#> 3     2     1  Greetje     Kees FALSE
#> 4     2     2      Jan     Piet FALSE
#> 5     3     1  Greetje     Piet FALSE
#> 6     3     2     Kees      Jan FALSE
```
