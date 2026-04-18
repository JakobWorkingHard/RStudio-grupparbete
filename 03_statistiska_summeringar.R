# Statistical summary by Salam

library(tidyverse)

source("02_datastädning.R")

data <- df

data <- data %>%
  mutate(order_value = quantity * unit_price)
# Antal rader (antal ordrar)
nrow(data)

# Medelvärde av ordervärde
mean(data$order_value, na.rm = TRUE)

# Median av ordervärde
median(data$order_value, na.rm = TRUE)
# Jämförelse av ordervärde mellan kundsegment
data %>%
  group_by(customer_segment) %>%
  summarise(
    medel_order = mean(order_value, na.rm = TRUE),
    median_order = median(order_value, na.rm = TRUE),
    antal = n()
  )
# Returgrad per produktkategori
data %>%
  group_by(product_category) %>%
  summarise(
    returgrad = mean(returned == "Yes", na.rm = TRUE),
    antal = n()
  )

# Jämförelse av ordervärde beroende på rabatt
data %>%
  group_by(discount_pct) %>%
  summarise(
    medel_order = mean(order_value, na.rm = TRUE),
    antal = n()
  )

