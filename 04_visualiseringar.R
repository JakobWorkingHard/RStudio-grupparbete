library(tidyverse)
library(scales)

source("03_statistiska_summeringar.R")

# Visualiseringar med Jakob

# Skapar en barchart där vi jämför 
data %>%
  group_by(product_category) %>%
  summarise(
    returgrad = mean(returned == "Yes", na.rm = TRUE),
    antal = n()
  ) %>%
  ggplot(aes(x = reorder(product_category, returgrad), y = returgrad)) +
  geom_col(fill = "steelblue") + 
  coord_flip() + 
  scale_y_continuous(labels = percent_format(accuracy = 1)) + 
  labs(
    title = "Returgrad per produktkategori",
    subtitle = "Visar andelen av totala ordrar som returnerats",
    x = "Produktkategori",
    y = "Returgrad"
  ) + 
  theme_minimal()

# Trendlinje med scatterplot för hur leveranstider påverkar returgraden
data %>%
  group_by(shipping_days) %>%
  summarise(
    returgrad = mean(returned == "Yes", na.rm = TRUE),
    antal = n()
  ) %>%
  filter(antal > 20) %>% # Väljer att filtrera bort en rad med endast 6st som hade en leveranstid på 8 dagar (lite data med extremt hög leveranstid) litet
  ggplot(aes(x = shipping_days, y = returgrad)) +
  geom_point(size = 3, color = "darkgray") +
  geom_smooth(method = "lm", se = TRUE, color = "red") + 
  scale_y_continuous(labels = percent_format(accuracy = 1)) +
  labs(
    title = "Påverkar leveranstiden risken för retur?",
    x = "Leveranstid (dagar)",
    y = "Returgrad"
  ) +
  theme_minimal()


# Samma som ovan (trendlinje för att se hur leveranstiden påverkar andelen returer)
# Men med 5 olika plottar indelad i olika kategorier 
data %>%
  group_by(product_category, shipping_days) %>%
  summarise(
    returgrad = mean(returned == "Yes", na.rm = TRUE),
    antal = n(),
    .groups = "drop" 
  ) %>%
  filter(antal > 10) %>% # Sänkt gräns eftersom datan är mer uppdelad
  ggplot(aes(x = shipping_days, y = returgrad)) +
  geom_point(size = 2, color = "darkgray", alpha = 0.7) +
  geom_smooth(method = "lm", se = TRUE, color = "red") + 
  facet_wrap(~product_category) + 
  scale_y_continuous(labels = percent_format(accuracy = 1)) +
  labs(
    title = "Hur påverkar leveranstid returgraden per produktkategori?",
    x = "Leveranstid (dagar)",
    y = "Returgrad"
  ) +
  theme_minimal() +
  theme(strip.text = element_text(face = "bold")) 


# Grupperar datan baserat på 3 variabler (leveranstid, region och kundtyp)
# Detta är dock lite riskabelt då det kan vara alldenes för få datapunkter i respektive kategori
data %>%
  group_by(customer_segment, region, shipping_days) %>%
  summarise(
    returgrad = mean(returned == "Yes", na.rm = TRUE),
    antal = n(),
    .groups = "drop"
  ) %>%
  filter(antal > 5) %>% # Sänkt ytterligare då vi kan anta att det blir lågt antal i varje grupp
  ggplot(aes(x = shipping_days, y = returgrad)) +
  geom_point(size = 1.5, color = "darkgray", alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE, color = "steelblue") + 
  facet_grid(region ~ customer_segment) + 
  scale_y_continuous(labels = percent_format(accuracy = 1)) +
  labs(
    title = "Returgrad vs Leveranstid: Uppdelat på Region och Kundsegment",
    x = "Leveranstid (dagar)",
    y = "Returgrad"
  ) +
  theme_bw() 


# Så vad säger den här datan oss? 
# Om vi kan så BÖR vi fokusera på att dra ner leveranstiden särkilt för:
# 1. Small business i norr och väst
# 2. Konsumenter i öst
# 3. Företag i syd och väst
# 4. Klädprodukter, Hemprodukter och sportprodukter
