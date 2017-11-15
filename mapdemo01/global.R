library(leaflet)
library(sf)
library(dplyr)
library(htmltools)

mbhg <- readRDS("data/mbhg.rds")
au <- readRDS("data/au.rds")
ta <- readRDS("data/ta.rds")

rc <- mbhg %>%
  select(regc2013_v1_00, regc2013_v1_00_name) %>%
  unique

rcta <- mbhg %>%
  filter(ta2013_v1_00 != '999' & regc2013_v1_00 != '99') %>%
  group_by(ta2013_v1_00, regc2013_v1_00) %>%
  summarise(n = n()) %>%
  arrange(ta2013_v1_00, desc(n)) %>%
  group_by(ta2013_v1_00) %>%
  filter(row_number() == 1) %>%
  inner_join(rc, by = "regc2013_v1_00") %>%
  inner_join(ta, by = "ta2013_v1_00") %>%
  select(regc2013_v1_00, regc2013_v1_00_name, ta2013_v1_00, ta2013_v1_00_name) %>%
  arrange(regc2013_v1_00, ta2013_v1_00)

ta_choices <- list()
for (region in unique(rcta$regc2013_v1_00_name)){
  tmp <- filter(rcta, regc2013_v1_00_name == region)
  choices <- tmp$ta2013_v1_00
  names(choices) <- tmp$ta2013_v1_00_name
  ta_choices[[region]] <- choices
}

# make some fake data to plot...
au <- au %>%
  mutate(v1 = rnorm(nrow(au), 65, 1), v2 = rnorm(nrow(au), 6, 0.5))
