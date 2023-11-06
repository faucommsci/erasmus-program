# Data creation

## Load packages
if (!require("pacman")) install.packages("pacman")
pacman::p_load(
    readr, qs,
    here, tidyverse, 
    glue
)

## Import the raw data
df <- read_delim(
    here("data/universities-geo_locations_de.csv"), 
    delim = ";",
    escape_double = FALSE,
    trim_ws = TRUE
    ) %>%
    # wrangle data
    rownames_to_column(var = "id") %>% 
    mutate(
        lat = str_split(lat_long, ",", simplify = TRUE)[,1], 
        long = str_split(lat_long, ",", simplify = TRUE)[,2],
        across(long, trimws), 
        across(lat:long, as.numeric),
        info = glue(
            "<b><a href='{link}'>{uni}</a></b> <br>
            {places} places each {duration} month <br> Courses in: {languages} <br>"
        )
    ) %>% 
    arrange(country) %>% 
    # drop universities with no active contract
    filter(country != "Polen")

## Export qs-data
qsave(df, file = here("data/universities-geo_locations_de.qs"))