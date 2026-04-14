# Ladda nödvändiga paket
library(tidyverse)
library(janitor)

# Läs in data
df <- read_csv("ecommerce_orders.csv")

# Visa första raderna
head(df)

# Se struktur på datan
glimpse(df)

# Städar kolumnnamn (standardiserar till små bokstäver och underscore)
df <- df %>%
  clean_names()

names(df)

# Kolla antal saknade värden per kolumn
colSums(is.na(df))

# Hantera saknade värden
df <- df %>%
  mutate(
    # Ersätt NA i rabatt med 0 (ingen rabatt)
    discount_pct = replace_na(discount_pct, 0),
    
    # Ersätt kategoriska NA med "Unknown"
    payment_method = replace_na(payment_method, "Unknown"),
    city = replace_na(city, "Unknown"),
    campaign_source = replace_na(campaign_source, "Unknown"),
    
    # Ersätt NA i leveranstid med median
    shipping_days = replace_na(shipping_days, median(shipping_days, na.rm = TRUE))
  )

colSums(is.na(df))

# Konvertera relevanta variabler till faktorer (kategoriska variabler)
# Detta gör gruppering, summeringar och visualiseringar mer korrekta
df <- df %>%
  mutate(
    customer_segment = as.factor(customer_segment),
    customer_type = as.factor(customer_type),
    region = as.factor(region),
    product_category = as.factor(product_category),
    product_subcategory = as.factor(product_subcategory),
    payment_method = as.factor(payment_method),
    campaign_source = as.factor(campaign_source),
    returned = as.factor(returned)
  )

# Skapa binär variabel för retur (1 = Yes, 0 = No)
# Underlättar beräkning av returgrad (t.ex. mean(returned_binary))
df <- df %>%
  mutate(
    returned_binary = ifelse(returned == "Yes", 1, 0)
  )

glimpse(df)

# Kontrollera om det finns dubbletter baserat på order_id
sum(duplicated(df$order_id))

# Kontrollera min och max värden för numeriska variabler
summary(df %>% 
          select(quantity, unit_price, discount_pct, shipping_days))

# Inga orimliga värden identifierades i de numeriska variablerna
# Datan bedöms vara rimlig och redo för vidare analys

# Skapa nya variabler för analys

df <- df %>%
  mutate(
    # Totalt ordervärde före rabatt
    order_value = quantity * unit_price,
    
    # Pris efter rabatt per enhet
    price_after_discount = unit_price * (1 - discount_pct)
  )

# Skapa kategorier för leveranstid
# Underlättar analys av samband mellan leveranstid och returer

df <- df %>%
  mutate(
    shipping_category = case_when(
      shipping_days <= 2 ~ "Fast",
      shipping_days <= 4 ~ "Medium",
      shipping_days >= 5 ~ "Slow"
    )
  )

df$shipping_category <- factor(df$shipping_category, 
                               levels = c("Fast", "Medium", "Slow"))

table(df$shipping_category)

# Skapa grupper för rabatt
# Underlättar analys av hur rabatt påverkar beteende

df <- df %>%
  mutate(
    discount_group = case_when(
      discount_pct == 0 ~ "No discount",
      discount_pct <= 0.10 ~ "Low discount",
      discount_pct > 0.10 ~ "High discount"
    )
  )

# Gör till faktor för bättre visualisering
df$discount_group <- factor(df$discount_group, 
                            levels = c("No discount", "Low discount", "High discount"))

table(df$discount_group)
