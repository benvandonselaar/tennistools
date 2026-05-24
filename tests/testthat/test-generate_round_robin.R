test_that("generate_round_robin() Generate a Round-Robin Match Schedule", {
  expected <- data.frame(
    round    = c(1, 1, 2, 2, 3, 3),
    match    = c(1, 2, 1, 2, 1, 2),
    player_1 = c("Greetje", "Jan",     "Piet",    "Greetje", "Jan",  "Piet"),
    player_2 = c("(bye)",   "Piet",    "(bye)",   "Jan",     "(bye)", "Greetje"),
    bye      = c(TRUE, FALSE, TRUE, FALSE, TRUE, FALSE),
    stringsAsFactors = FALSE
  )

  expect_equal(generate_round_robin(c("Jan", "Piet", "Greetje"), shuffle = FALSE), expected)
})
