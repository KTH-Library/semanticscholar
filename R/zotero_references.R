#' @title References for zotero
#' @description Given a vector of identifiers, extract data for use in Zotero
#' @param identifiers a character vector of identifiers
#' @return a list with results
#' @details See https://github.com/giocomai/zoteroR for working with Zotero from R
#' @examples
#' \dontrun{
#' if(interactive()){
#'  ids <- c("10.1038/nrn3241", "CorpusID:37220927")
#'  zotero_references(ids)
#'  }
#' }
#' @seealso
#'  \code{\link[humaniformat]{parse_names}}
#' @export
#' @importFrom dplyr tibble as_tibble mutate select `%>%`
#' @importFrom humaniformat parse_names
#' @importFrom rlang .data
#' @importFrom purrr possibly map
zotero_references <- function(identifiers) {

  zotero <- function(identifier) {

    p1 <- S2_paper(identifier)

    journalArticle <-
      with(p1, dplyr::tibble(
        title = title,
        DOI = doi,
        URL = url,
        abstractNote = abstract,
        publicationTitle = venue,
        date = year
      ))

    authors <- p1$authors$name

    creators <-
      humaniformat::parse_names(authors) %>%
      dplyr::as_tibble() %>%
      dplyr::mutate(creatorType = "author") %>%
      dplyr::rename(
        firstName = .data$first_name,
        lastName = .data$last_name
      ) %>%
      dplyr::select(
        "creatorType",
        "firstName",
        "lastName"
      )

    list(
      S2_paper = p1$paperId,
      journalArticle = journalArticle,
      creators = creators
    )

  }

  z <- purrr::possibly(zotero, NULL)

  identifiers %>% purrr::map(z)
}

