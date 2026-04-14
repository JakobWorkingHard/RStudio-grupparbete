# Läser in data
df <- read.csv('ecommerce_orders.csv')

# Visar antal rader och kolumer
dim(df)

# Visar kolumnamn
names(df)

# Visar struktur
str(df)

# Visar saknade värden per kolumn
colSums(is.na(df))

# Visar ett antal rader från datasetet
head(df)

# Visar unika värden i viktiga variabler
table(df$returned)
table(df$product_category)
table(df$region)
table(df$customer_type)

# En sammanfattning av numeriska variabler
summary(df[, c('quantity', 'unit_price', 'discount_pct', "shipping_days")])