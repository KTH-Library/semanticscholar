
<!-- README.md is generated from README.Rmd. Please edit that file -->

# semanticscholar

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The goal of `semanticscholar` is to offer data access to data from
Semantic Scholar through their lightweight API which can provide data on
publications and authors. Semantic Scholar is a free, non-profit
academic search and discovery engine whose mission is to empower
researchers.

## Installation

You can install the current version of `semanticscholar` from
[GitHub](https://github.com/kth-library/semanticscholar) with:

``` r
#install.packages("devtools")
devtools::install_github("kth-library/semanticscholar", dependencies = TRUE)
```

## Example

This is a basic example which shows you how to get information for
papers and authors:

``` r
library(semanticscholar)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
suppressPackageStartupMessages(library(purrr))
library(knitr)

# get a paper using an identifier
paper <- S2_paper("arXiv:1705.10311", include_unknown_refs = TRUE)

# authors on that paper
authors <- paper$authors

# for one of the authors
author_ids <- authors$authorId
author <- S2_author(author_ids[1])

# list some of the papers
papers <- 
  author$papers %>% 
  select(title, year)

papers %>% head(5) %>% knitr::kable()
```

| title                                                                                               | year |
|:----------------------------------------------------------------------------------------------------|-----:|
| Optimal Multiple Surface Segmentation With Shape and Context Priors                                 | 2013 |
| Optimal Co-Segmentation of Tumor in PET-CT Images With Context Information                          | 2013 |
| Error-Tolerant Scribbles Based Interactive Image Segmentation                                       | 2014 |
| Dimensional music emotion recognition by valence-arousal regression                                 | 2016 |
| MASCG: Multi-Atlas Segmentation Constrained Graph method for accurate segmentation of hip CT images | 2015 |

``` r
# get data from several identifiers for importing into Zotero
ids <- c("10.1038/nrn3241", "CorpusID:37220927")
my_refs <- zotero_references(ids)

# this data can now be imported via the Zetero API using https://github.com/giocomai/zoteroR
# showing data form the first record
my_refs[[1]]$journalArticle %>% glimpse()
#> Rows: 1
#> Columns: 6
#> $ title            <chr> "The origin of extracellular fields and currents — E…
#> $ DOI              <chr> "10.1038/nrn3241"
#> $ URL              <chr> "https://www.semanticscholar.org/paper/da82f8e6ff009…
#> $ abstractNote     <chr> "Neuronal activity in the brain gives rise to transm…
#> $ publicationTitle <chr> "Nature Reviews Neuroscience"
#> $ date             <int> 2012
my_refs[[2]]$creators %>% knitr::kable()
```

| creatorType | firstName | lastName    |
|:------------|:----------|:------------|
| author      | G.        | Kawchuk     |
| author      | N.        | Prasad      |
| author      | R.        | Chamberlain |
| author      | A.        | Klymkiv     |
| author      | L.        | Peter       |

## Rate limits and endpoints

By default the rate limit allows 100 request per 5 minute period. This
allows for making new requests every 3-4 seconds.

By requesting an API key from Semantic Scholar, this rate can be faster,
such as 100 requests per second. If you want to use an API key provided
by Semantic Scholar, then edit the `~/.Renviron` file to add the key as
a value for an environment variable `SEMANTICSCHOLAR_API`. This R
package will then use API endpoints which are faster, with higher rate
limits than the regular API endpoints.

The rate limit and API base URL endpoint can be verified:

``` r
S2_api()
#> [1] "https://partner.semanticscholar.org/"
S2_ratelimit()
#> [1] 0.01010101
```

## Data source attribution

When data from `semanticscholar` is displayed publicly, this attribution
also needs to be displayed:

Data source: Semantic Scholar API
<https://partner.semanticscholar.org/?utm_source=api>
