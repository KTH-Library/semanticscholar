test_that("assembling references for use in Zotero works", {
  skip_on_ci()

  # TODO: fix this

  # # get data from several identifiers for importing into Zotero
  # ids <- c("10.1038/nrn3241", "CorpusID:37220927")
  # my_refs <- zotero_references(ids)

  # # this data can now be imported via the Zotero API using https://github.com/giocomai/zoteroR
  # # showing data form the first record
  # my_refs[[1]]$journalArticle %>% glimpse()
  # my_refs[[2]]$creators %>% knitr::kable()

  ids <- c("10.1038/nrn3241", "CorpusID:37220927")
  refs <- zotero_references(ids)
  is_valid <- length(refs) == 2
  expect_true(is_valid)
})
