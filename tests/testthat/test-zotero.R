test_that("assembling references for use in Zotero works", {
  ids <- c("10.1038/nrn3241", "CorpusID:37220927")
  refs <- zotero_references(ids)
  is_valid <- length(refs) == 2
  expect_true(is_valid)
})
