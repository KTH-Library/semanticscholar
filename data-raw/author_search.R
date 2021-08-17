library(httr)
library(rvest)

search1 <- function(author)
  GET(sprintf("https://www.semanticscholar.org/search?q=%s&sort=relevance", URLencode(author)))

search2 <- function(author)
  POST("https://www.semanticscholar.org/api/1/search",
     body = list(queryString = author),
     content_type("application/json"))



# markus@sphere:~/repos/semcor$ time cat s2-corpus-000 | jq -r '.authors[] | ({author: .name, id: .ids[]}) | [.author, .id] | @csv' > authors-000.csv
#
# real	0m30,024s
# user	0m29,477s
# sys	0m2,822s


#remotes::install_github("cwida/duckdb/tools/rpkg",  build = FALSE)
library(DBI)
library(duckdb)
library(dplyr)
library(arrow)

authors <-
  arrow::read_csv_arrow("~/repos/semcor/authors-000.csv",
  col_names = c("author_name", "author_id"))

arrow::write_parquet(authors, "~/repos/semcor/authors.parquet")

con <- dbConnect(duckdb::duckdb(), dbdir = ":memory:", read_only = FALSE)

if (dbExistsTable(con, "authors")) dbRemoveTable(con, "authors")
dbWriteTable(con, "authors", as.data.frame(authors))

dbSendStatement(con, "PRAGMA threads=10;")
dbGetQuery(con, "SELECT count(*) from authors")

sql <- "CREATE VIEW authorsp AS SELECT author_name, author_id FROM
  parquet_scan('/home/markus/repos/semcor/authors.parquet');"

dbSendQuery(con, sql)

# row count
con %>% tbl("authorsp") %>% count()

tictoc::tic()
dbGetQuery(con, "SELECT * FROM authors where author_name like 'Gerald Q. Ma%'")
tictoc::toc()

# slightly faster against parquet file
tictoc::tic()
dbGetQuery(con, "SELECT * FROM authorsp where author_name like 'Gerald Q. Ma%'")
tictoc::toc()

# same when index for author_name
dbExecute(con, "CREATE INDEX author_idx ON authors (author_name);")

#dbExecute(con, "EXPORT DATABASE '/home/markus/repos/semcor/' (FORMAT PARQUET)")

dbDisconnect(con, shutdown = TRUE)
