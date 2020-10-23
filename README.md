
<!-- README.md is generated from README.Rmd. Please edit that file -->

# semanticscholar

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The goal of `semanticscholar` is to offer data access to data from
Semantic Scholar through their lightweight API which can provide data on
publications and authors.

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
library(purrr)

# get a paper using an identifier
paper <- S2_paper("arXiv:1705.10311", include_unknown_refs = TRUE)

# find authors on that paper
authors <- 
  paper$authors %>% map_df(as_tibble)

authors
#> # A tibble: 3 x 3
#>   authorId name       url                                            
#>   <chr>    <chr>      <chr>                                          
#> 1 3324024  Junjie Bai https://www.semanticscholar.org/author/3324024 
#> 2 2053652  Abhay Shah https://www.semanticscholar.org/author/2053652 
#> 3 47150187 X. Wu      https://www.semanticscholar.org/author/47150187

# for one of the authors
author_ids <- authors$authorId
author <- S2_author(author_ids[1])

# list all the papers
papers <- 
  author$papers %>% 
  map_df(as_tibble) %>% 
  select(title, year)

knitr::kable(papers %>% head(5))
```

| title                                                                                                                     | year |
| :------------------------------------------------------------------------------------------------------------------------ | ---: |
| Optimal Multiple Surface Segmentation With Shape and Context Priors                                                       | 2013 |
| Optimal Co-Segmentation of Tumor in PET-CT Images With Context Information                                                | 2013 |
| Error-Tolerant Scribbles Based Interactive Image Segmentation                                                             | 2014 |
| Dimensional music emotion recognition by valence-arousal regression                                                       | 2016 |
| Young children’s affective decision-making in a gambling task: Does difficulty in learning the gain/loss schedule matter? | 2009 |

## Data source attribution

When data from `semanticscholar` is displayed publicly, this attribution
also needs to be displayed:

Data source: Semantic Scholar API
<https://api.semanticscholar.org/?utm_source=api> Data license
agreement:
<http://s2-public-api-prod.us-west-2.elasticbeanstalk.com/license/>
