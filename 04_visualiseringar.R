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
#Tolkning:
#Returgraden är högst för Fashion och Home, medan Sports har lägst. 
#Detta tyder på att vissa produktkategorier är mer benägna att returneras.

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

#Tolkning:
#Grafen visar ett tydligt positivt samband mellan leveranstid och returgrad. 
#Längre leveranstider verkar öka risken för att kunder returnerar sina produkter.


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

#Tolkning:
#Sambandet mellan leveranstid och retur varierar mellan kategorier. 
#Effekten är särskilt tydlig för Fashion, medan den är svagare för andra kategorier.


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
#Tolkning:
#Sambandet varierar mellan regioner och kundsegment, 
#men resultaten bör tolkas försiktigt då antal datapunkter kan påverka kvalitén av tolkningen.

# Ordervärde per rabattnivå

data %>%
  group_by(discount_group) %>%
  summarise(
    medel_order = mean(order_value, na.rm = TRUE)
  ) %>%
  ggplot(aes(x = discount_group, y = medel_order)) +
  geom_col(fill = "steelblue") +
  labs(
    title = "Genomsnittligt ordervärde per rabattnivå",
    x = "Rabattgrupp",
    y = "Ordervärde"
  ) +
  theme_minimal()

#Tolkning:
#Ordervärdet är högst för ordrar utan rabatt. 
#Rabatter verkar inte leda till högre ordervärde i detta dataset.

data %>%
  group_by(discount_group) %>%
  summarise(
    returgrad = mean(returned_binary, na.rm = TRUE)
  ) %>%
  ggplot(aes(x = discount_group, y = returgrad)) +
  geom_col(fill = "steelblue") +
  scale_y_continuous(labels = scales::percent_format()) +
  labs(
    title = "Returgrad per rabattnivå",
    x = "Rabattgrupp",
    y = "Returgrad"
  ) +
  theme_minimal()

#Tolking: 
#Returgraden är tydligt högre vid höga rabatter, vilket tyder på att rabatter kan öka risken för returer.



# Så vad säger den här datan oss? 
# Om vi kan så BÖR vi fokusera på att dra ner leveranstiden särkilt för:
# 1. Small business i norr och väst
# 2. Konsumenter i öst
# 3. Företag i syd och väst
# 4. Klädprodukter, Hemprodukter och sportprodukter
