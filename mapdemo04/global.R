library(leaflet)
library(sf)
library(dplyr)
library(htmltools)

mbhg <- readRDS("data/mbhg.rds")
au <- readRDS("data/au.rds")
ta <- readRDS("data/ta.rds")

# make some fake data to plot...
au <- au %>%
  mutate(v1 = rnorm(nrow(au), 65, 1), v2 = rnorm(nrow(au), 6, 0.5))
