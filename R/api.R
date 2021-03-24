#file.edit("~/.Renviron")
#readRenviron("~/.Renviron")

cfg <- function() {

  res <- list(
    S2_api = "https://api.semanticscholar.org/",
    S2_ratelimit = round((5 * 60) / (100 - 1), digits = 2)
  )

  if (Sys.getenv("SEMANTICSCHOLAR_API") != "") {
    res$S2_key <- Sys.getenv("SEMANTICSCHOLAR_API")
    res$S2_api <- "https://partner.semanticscholar.org/"
    res$S2_ratelimit <- 1 / (100 - 1) # for approx 100 requests per second
  }

  return (res)
}

#' Endpoint used for requests to Semantic Scholar API
#'
#' When environment variable SEMANTICSCHOLAR_API is set to a valid API key this
#' value differs as endpoints allowing higher rate limits are being used.
#' @export
S2_api <- function()
  cfg()$S2_api

#' Rate limit for API calls
#'
#' The minimum interval in seconds between requests to the API.
#'
#' When environment variable SEMANTICSCHOLAR_API is set to a valid API key this
#' value can be approx 0.01 (for 100 requests per second) but if no API key is
#' used, the default value will be around 3.5 (allowing a maximum of 100 requests per 5 minutes)
#' @export
S2_ratelimit <- function()
  cfg()$S2_ratelimit

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
    "Data source: Semantic Scholar API\n%s?utm_source=api\n%s", S2_api(), "\n",
    "Data license agreement: http://s2-public-api-prod.us-west-2.elasticbeanstalk.com/license/")
}

#' Retrieve paper information
#'
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
#'
#' S2 is an abbreviation for Semantic Scholar
#' MAG is an abbreviation for Microsoft Academic Graph
#'
#' @return list representing S2 paper object
#' @examples
#' \dontrun{
#'  S2_paper("fb5d1bb23724d9a5a5eae036a2e3cf291cac2c1b")
#'  }
#' @importFrom httr GET content status_code
#' @importFrom jsonlite fromJSON
#' @export
S2_paper <- function(identifier, include_unknown_refs = FALSE) {

  q <- NULL

  if (include_unknown_refs)
    q <- list(include_unknown_refs = "true")

  key <- cfg()$S2_key
  api <- S2_api()

  if (!is.null(key) && nchar(key) > 10) {
    res <- httr::GET(url = api, httr::add_headers(`x-api-key` = key),
      path = sprintf("v1/paper/%s", identifier), query = q)
  } else {
    res <- httr::GET(url = api,
      path = sprintf("v1/paper/%s", identifier), query = q)
  }

  if (status_code(res) == 200) {
    res <- jsonlite::fromJSON(
      httr::content(res, as = "text", encoding = "utf-8"),
      simplifyDataFrame = TRUE
    )
    class(res$references) <- c("tbl_df", "tbl", "data.frame")
    return(res)
  }

  if (status_code(res) == 429)
    stop("HTTP status 429 Too Many Requests (> 100 in 5 mins). Please wait 5 minutes.")

  stop("HTTP status", status_code(res))

  # list(
  #   abstract = purrr::pluck(x, "abstract"),
  #   authors = purrr::pluck(x, "authors") %>% purrr::map_df(dplyr::as_tibble),
  #   citations_authors = purrr::pluck(x, "citations", "authors") %>% purrr::map_df(dplyr::as_tibble)
  # )
}


#' Retrieve author information
#'
#' This function retrieves Semantic Scholar data for
#' an author given the S2Author identifier
#' @param S2AuthorId string with author identifier
#' @details
#' Example of Accessible Paper Identifiers:
#' - S2 Author ID : 1741101
#' @return list representing author object
#' @examples
#' \dontrun{
#'  S2_author(1741101)
#'  }
#' @importFrom httr GET status_code content
#' @importFrom jsonlite fromJSON
#' @export
S2_author <- function(S2AuthorId) {

  identifier <- S2AuthorId
  key <- cfg()$S2_key
  api <- S2_api()

  if (!is.null(key) && nchar(key) > 10) {
    res <- httr::GET(url = api, httr::add_headers(`x-api-key` = key),
                     path = sprintf("v1/author/%s", identifier))
  } else {
    res <- httr::GET(url = S2_api(),
                     path = sprintf("v1/author/%s", identifier))
  }

  if (status_code(res) == 200)
    return(jsonlite::fromJSON(httr::content(res, as = "text", encoding = "utf-8")))

  if (status_code(res) == 429)
    stop("HTTP status 429 Too Many Requests (> 100 in 5 mins). Please wait 5 minutes.")

  stop("HTTP status", status_code(res))

}

