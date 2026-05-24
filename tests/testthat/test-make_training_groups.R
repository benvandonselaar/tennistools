test_that("make_training_groups() Divide Players into Training Groups", {
  expected <- list(
    "Group 1" = c("Piet", "Joke", "Kees"),
    "Group 2" = c("Greetje", "Herma", "Jan")
  )
  expect_equal(
    make_training_groups(c("Jan", "Piet", "Kees", "Greetje", "Joke", "Herma"),
                         group_size = 3,
                         levels = c(9, 4, 8, 5, 7, 6)),
    expected
  )
})
