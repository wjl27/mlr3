context("mlr_resampling_holdout")

test_that("holdout has no duplicated ids", {
  r = rsmp("holdout")
  expect_identical(r$duplicated_ids, FALSE)
})

test_that("stratification", {
  data = data.table(y = factor(rep(letters[1:2], times = c(90, 10))), x1 = runif(100), x2 = rep(LETTERS[1:2], times = c(50, 50)))
  b = as_data_backend(data)
  task = TaskClassif$new("stratify_data", b, target = "y")
  task$col_roles$stratum = task$target_names

  r = rsmp("holdout", ratio = .5)
  r$instantiate(task)

  i = 1L
  expect_equal(task$data(r$train_set(i))[y == "a", .N], 45)
  expect_equal(task$data(r$train_set(i))[y == "b", .N], 5)
  expect_equal(task$data(r$test_set(i))[y == "a", .N], 45)
  expect_equal(task$data(r$test_set(i))[y == "b", .N], 5)
})

test_that("grouping", {
  r = rsmp("holdout")
  expect_grouping_works(r)
})
