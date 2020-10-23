library(httr)
library(rvest)

search1 <- function(author)
  GET(sprintf("https://www.semanticscholar.org/search?q=%s&sort=relevance", URLencode(author)))

search2 <- function(author)
  POST("https://www.semanticscholar.org/api/1/search",
     body = list(queryString = author),
     content_type("application/json"))
