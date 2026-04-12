# Projekt: Analys av försäkringskostnader
# Kurs: R programmering för dataanalys
# Läs in data
data <- read.csv("insurance_costs.csv")

# Visa de första raderna
head(data)

# Visa struktur av data
str(data)

# Sammanfattning av data
summary(data)

# Antal rader och kolumner
dim(data)

# Kontrollera saknade värden
colSums(is.na(data))

# Fyll saknade värden i bmi med medelvärde
data$bmi[is.na(data$bmi)] <- mean(data$bmi, na.rm = TRUE)

# Fyll saknade värden i annual_checkups med median
data$annual_checkups[is.na(data$annual_checkups)] <- median(data$annual_checkups, na.rm = TRUE)

# Kontroll igen
colSums(is.na(data))
# Histogram över försäkringskostnader
hist(data$charges,
     main = "Fördelning av försäkringskostnader",
     xlab = "Charges",
     col = "lightblue")
# Tolkning:
# De flesta försäkringskostnader ligger mellan 5000 och 15000.
# Fördelningen är högerskev, vilket innebär att några kunder har mycket höga kostnader.

# Standardisera smoker (ta bort mellanrum + små bokstäver)
data$smoker <- trimws(tolower(data$smoker))

# Boxplot: kostnad beroende på rökning
boxplot(charges ~ smoker, data = data,
        main = "Försäkringskostnader och rökning",
        xlab = "Smoker",
        ylab = "Charges",
        col = c("lightgreen", "salmon"))

# Tolkning:
# Rökare har betydligt högre försäkringskostnader än icke-rökare.
# Skillnaden är tydlig, vilket visar att rökning är en viktig faktor.

# Punktdiagram: ålder och försäkringskostnad
plot(data$age, data$charges,
     main = "Ålder och försäkringskostnad",
     xlab = "Age",
     ylab = "Charges",
     col = "darkblue",
     pch = 16)

# Tolkning:
# Det finns en positiv tendens mellan ålder och försäkringskostnad.
# Äldre kunder verkar generellt ha högre kostnader än yngre kunder.

# Punktdiagram: BMI och försäkringskostnad
plot(data$bmi, data$charges,
     main = "BMI och försäkringskostnad",
     xlab = "BMI",
     ylab = "Charges",
     col = "purple",
     pch = 16)

# Tolkning:
# Det finns en viss positiv relation mellan BMI och försäkringskostnad.
# Personer med högre BMI tenderar att ha något högre kostnader.

# Linjär regression
model1 <- lm(charges ~ age + bmi + smoker + children, data = data)

# Visa resultat
summary(model1)

# Tolkning av regression:
# Rökning är den starkaste faktorn som påverkar försäkringskostnaden.
# Rökare betalar i genomsnitt cirka 8000 mer än icke-rökare.
# Ålder och BMI har också en positiv effekt på kostnaden.
# Antal barn verkar däremot inte ha någon signifikant påverkan.
# Modellen förklarar cirka 54% av variationen i kostnaderna, vilket anses vara relativt bra.

# Andra modell
model2 <- lm(charges ~ age + bmi + smoker + children + exercise_level + chronic_condition, data = data)

summary(model2)

# Jämförelse mellan modeller:
# Modell 2 har ett högre R-squared (cirka 0.70) jämfört med modell 1 (cirka 0.54),
# vilket innebär att modell 2 förklarar en större del av variationen i kostnaderna.

# Tolkning:
# Rökning och kroniska sjukdomar är de starkaste faktorerna som påverkar kostnaden.
# Ålder och BMI har också en positiv påverkan.
# Variabeln exercise_level verkar däremot ha en svag eller osäker effekt.


# Slutsats:
# Modell 2 är bättre än modell 1 eftersom den förklarar en större del av variationen i kostnaderna.

# Sammanfattning:
# Analysen visar att rökning, kroniska sjukdomar, ålder och BMI är de viktigaste faktorerna bakom högre försäkringskostnader.