test_that("Getting data for a paper works", {
  r1 <- S2_paper("arXiv:1705.10311", include_unknown_refs = TRUE)
  is_valid <- r1$paperId == "47be321bff23f73c71d7e5716cd107ead087c3ae"
  expect_true(is_valid)
})

test_that("Getting data for some papers works", {

  identifiers <- c(
    "0796f6cd7f0403a854d67d525e9b32af3b277331",
    "10.1038/nrn3241",
    "arXiv:1705.10311",
    "MAG:112218234",
    "ACL:W12-3903",
    "PMID:19872477",
    "CorpusID:37220927"
  )

  pid <- function(x) {
    Sys.sleep(S2_ratelimit())
    S2_paper(x)$paperId
  }
  ids <- vapply(identifiers, pid, character(1))
  is_valid <- all(nchar(ids) == 40)

  expect_true(is_valid)
})

test_that("Getting data for an author works", {
  r1 <- S2_author("1741101")
  is_valid <- r1$authorId == "1741101"
  expect_true(is_valid)
})
