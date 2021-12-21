test_that("Paper search with paging works", {
  res <- S2_search_papers("covid vaccination", offset = 100, limit = 3)
  is_valid <- nrow(res$data) == 3 && (res$offset == 100) && (res$total > 6e5)
  expect_true(is_valid)
})

test_that("Paper search includes a set of fields", {
  res <- S2_search_papers("covid", fields = "url,abstract,authors")
  n_authors <- vapply(res$data$authors, nrow, integer(1))
  has_fields <- all(c("url", "abstract", "authors") %in% names(res$data))
  is_valid <- all(n_authors > 0) && has_fields
  expect_true(is_valid)
})

test_that("Paper search for garbage term is empty", {
  res <- S2_search_papers("totalGarbageNonsense")
  is_valid <- (res$total == 0) && (res$offset == 0) && (length(res$data) == 0)
  expect_true(is_valid)
})

test_that("Paper with authors, year and url", {
  res <- S2_paper2("649def34f8be52c8b66281af98ae884c09aef38b", fields = "url,year,authors")
  is_valid <- (res$url == "https://www.semanticscholar.org/paper/649def34f8be52c8b66281af98ae884c09aef38b") &&
    (res$year == 2018) && (nrow(res$authors) > 20)
  expect_true(is_valid)
})

test_that("Paper with citations with authors", {
  # TODO: double check this test
  # https://api.semanticscholar.org/graph/v1/paper/649def34f8be52c8b66281af98ae884c09aef38b/citations?fields=authors&offset=1500&limit=500
  # Returns with offset=1500, and data is a list of the last 100 citations.
  # Each citation has a citingPaper which contains its paperId plus a list of authors
  # The authors under each citingPaper has their authorId and name.
  res <- S2_paper2("649def34f8be52c8b66281af98ae884c09aef38b", fields = "citations.authors")
  is_valid <- all(vapply(res$citations$authors, nrow, integer(1)) >= 0)
  expect_true(is_valid)
})

test_that("Paper with list of twentythree authors", {
  res <- S2_paper2("649def34f8be52c8b66281af98ae884c09aef38b", details = "authors", limit = 50)
  is_valid <- nrow(res$data) >= 23
  expect_true(is_valid)
})

test_that("Paper with authors and their affiliations and papers", {

  res <- S2_paper2("649def34f8be52c8b66281af98ae884c09aef38b",
    details = "authors", fields = "affiliations,papers.paperId", limit = 20)

  is_valid <- length(res$data$affiliations) == 20
  expect_true(is_valid)
})

test_that("Paper with authors and their url, years and authors", {

  res <- S2_paper2("649def34f8be52c8b66281af98ae884c09aef38b",
                   details = "authors", fields = "url,papers.year,papers.authors", offset = 2)

  is_valid <- length(res$data$url) == 10 && all(nchar(res$data$url) > 10)
  expect_true(is_valid)
})


test_that("Paper with 100 citations works", {

  res <- S2_paper2("649def34f8be52c8b66281af98ae884c09aef38b",
                   details = "citations", limit = 100)

  is_valid <- length(res$data$citingPaper$paperId) == 100 &&
    all(nchar(res$data$citingPaper$paperId) > 10)

  expect_true(is_valid)
})

test_that("Paper with 100 citations works", {

  res <- S2_paper2("649def34f8be52c8b66281af98ae884c09aef38b",
                   details = "citations", fields = "contexts,intents,isInfluential,abstract",
                  offset=20, limit = 10)
  is_valid <- (res$offset == 20) && !is.null(res$data)

  expect_true(is_valid)
})

test_that("Paper with references and paging works", {

  res <- S2_paper2("649def34f8be52c8b66281af98ae884c09aef38b",
                   details = "references", fields = "contexts,intents,isInfluential,abstract",
                   offset = 20, limit = 10)

  is_valid <- (res$offset == 20) && !is.null(res$data)

  expect_true(is_valid)
})

test_that("Author with fields for aliases and papers works", {

  res <- S2_author2(1741101,
    fields = "aliases,papers",
    offset = 20, limit = 10)

  is_valid <- all(c("paperId", "title") %in% names(res$papers))
  expect_true(is_valid)

})

test_that("Author with fields for paper abstracts and authors works", {

  res <- S2_author2(1741101,
                    fields = "url,papers.abstract,papers.authors",
                    offset = 20, limit = 10)

  # TODO: check the paging! why does not offset and limit appear in the result?

  is_valid <- all(c("paperId", "abstract", "authors") %in% names(res$papers))
  expect_true(is_valid)

})

test_that("Author with various paper fields and paging works", {

  res <- S2_author2(1741101, details = "papers",
    fields = "url,year,authors", limit = 2)

  is_valid <- all(c("paperId", "url", "year") %in% names(res$data)) && (nrow(res$data) == 2)
  expect_true(is_valid)

})

test_that("Author with various paper fields and paging works", {

  res <- S2_author2(1741101, details = "papers", fields = "citations.authors",
                    offset = 260)

  is_valid <- all(c("paperId", "citations") %in% names(res$data)) && (nrow(res$data) >= 4)
  expect_true(is_valid)

})


test_that("Author with fields for paperCount, citationCount, hIndex works", {

  res <- S2_author2(1741101,
                    fields = "url,paperCount,citationCount,hIndex",
                    #fields = "url,paperCount",
                    offset = 20, limit = 10)

  is_valid <- all(c("authorId", "url", "paperCount", "citationCount", "hIndex") %in% names(res))
  expect_true(is_valid)

})

test_that("Paper TLDR can be returned", {
  tldr <- S2_paper2(identifier = "649def34f8be52c8b66281af98ae884c09aef38b", fields="tldr")$tldr$text
  is_valid <- nchar(tldr) > 20
  expect_true(is_valid)
})

