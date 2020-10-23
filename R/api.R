S2_api <- function()
  "https://api.semanticscholar.org/"

#' Attribution
#'
#' Use this attribution whenever data from the API is publicly displayed
#'
#' @details Semantic Scholar provides a RESTful API for convenient linking
#' to Semantic Scholar pages and pulling information about individual records
#' on demand. When publicly displaying data from this API,
#' please incorporate the Semantic Scholar name and logo and point back to
#' Semantic Scholar at https://www.semanticscholar.org/ with
#' a utm_source=api UTM parameter.
#' @export
S2_attribution <- function() {
  sprintf(
    "Data source: Semantic Scholar API\n%s?utm_source=api\n%s", S2_api(),
    "Data license agreement: http://s2-public-api-prod.us-west-2.elasticbeanstalk.com/license/")
}

#' Retrieve paper information
#' This function retrieves Semantic Scholar data for a paper
#' given its identifier
#' @param identifier string with identifier
#' @param include_unknown_refs logical, Default: FALSE
#' @details
#' Example of Accessible Paper Identifiers:
#' - S2 Paper ID : 0796f6cd7f0403a854d67d525e9b32af3b277331
#' - DOI : 10.1038/nrn3241
#' - ArXiv ID : arXiv:1705.10311
#' - MAG ID : MAG:112218234
#' - ACL ID : ACL:W12-3903
#' - PubMed ID : PMID:19872477
#' - Corpus ID : CorpusID:37220927
#' @return list representing S2 paper object
#' @importFrom httr GET
#' @export
S2_paper <- function(identifier, include_unknown_refs = FALSE) {

  q <- NULL

  if (include_unknown_refs)
    q <- list(include_unknown_refs = "true")

  res <- httr::GET(url = S2_api(),
    path = sprintf("v1/paper/%s", identifier), query = q)

  x <- httr::content(res)

  x
  # list(
  #   abstract = purrr::pluck(x, "abstract"),
  #   authors = purrr::pluck(x, "authors") %>% purrr::map_df(dplyr::as_tibble),
  #   citations_authors = purrr::pluck(x, "citations", "authors") %>% purrr::map_df(dplyr::as_tibble)
  # )
}


#' Retrieve author information
#' This function retrieves Semantic Scholar data for
#' an author given the S2Author identifier
#' @param S2AuthorId string with author identifier
#' @details
#' Example of Accessible Paper Identifiers:
#' - S2 Author ID : 1741101
#' @return list representing author object
#' @importFrom httr GET
#' @export
S2_author <- function(S2AuthorId) {

  identifier <- S2AuthorId

  res <- httr::GET(url = S2_api(),
    path = sprintf("v1/author/%s", identifier))

  httr::content(res)

}
