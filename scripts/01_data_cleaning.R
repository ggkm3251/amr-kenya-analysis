library(readr)
library(dplyr)

amr <- read_csv("data/amr_data.csv")

# Convert date
amr <- amr %>% 
  mutate(sample_date = as.Date(sample_date),
         resistant = ifelse(resistant == "Yes", 1, 0))

# Quick glimpse
glimpse(amr)
