# Grupparbete – E-handel: Dataanalys i R

## Syfte
Syftet med projektet är att analysera orderdata från ett e-handelsföretag för att identifiera mönster i returer, kundbeteende och leveranser. Analysen ska ge underlag för affärsbeslut.

---

## Frågeställningar
Projektet fokuserar på följande frågor:

1. Hur skiljer sig returgrad mellan olika produktkategorier?  
2. Finns det tecken på att längre leveranstid hänger ihop med fler returer?  
3. Hur påverkar rabattnivå returgraden? *(egen frågeställning)*  

---

## Dataset
Projektet baseras på `ecommerce_orders.csv`, som innehåller data om ordrar, kunder, produktkategorier, rabatter, leveranstider och returer.

---

## Metod
Arbetet genomfördes i följande steg:

1. Dataförståelse  
2. Datastädning och förberedelse  
3. Statistiska sammanfattningar  
4. Visualisering  
5. Tolkning och slutsatser  

---

## Projektstruktur
RStudio-grupparbete/
│
├── 01_dataförståelse.R # Inläsning och första analys
├── 02_datastädning.R # Datastädning och förberedelse
├── 03_statistiska_summeringar.R # Statistiska analyser
├── 04_visualiseringar.R # Visualiseringar
│
├── The_project.R # Huvudfil för att köra hela analysen
├── ecommerce_orders.csv # Dataset
│
├── Rapport.pdf # Skriftlig rapport
├── Presentation_grupp5.pptx # Presentation
├── README.md # Projektbeskrivning
│
├── RStudio-grupparbete.Rproj # RStudio-projektfil
├── .gitignore # Git-konfiguration
├── .RData / .Rhistory # Lokala filer (ej nödvändiga för analysen)

---

## Arbetsfördelning
- Repository: Jakob
- Dataförståelse: Miralem
- Datastädning: Elza
- Statistiska analyser: Salam
- Visualisering: Jakob
- Tolkning & rapport: Tim
- Presentation: Eliesa
- README: Elza

---

## Reproducerbarhet
1. Klona eller ladda ner projektet från GitHub  
2. Öppna filen `RStudio-grupparbete.Rproj` i RStudio  
3. Installera nödvändiga paket (vid behov):
   ```r
   install.packages(c("tidyverse", "janitor", "scales"))
   ```
4. Öppna filen `The_project.R`
5. Kör hela scriptet genom att klicka på “Source”

---

## Viktigaste resultat
- Returgraden varierar tydligt mellan produktkategorier  
  - *Fashion* och *Home* har högst returgrad (~16%)  
- Längre leveranstider är associerade med högre returgrad  
- Höga rabatter är kopplade till:
  - högre returgrad (~19% vs ~13%)
  - lägre genomsnittligt ordervärde  
- Rabatter verkar inte öka ordervärdet i detta dataset  

---

## Begränsningar
- Datasetet innehåller endast 1000 observationer  
- Vissa grupper har få datapunkter  
- Analysen visar samband, inte kausalitet  
- Förenklingar har gjorts vid hantering av saknade värden  

---

## Nästa steg
- Utöka datasetet för ökad statistisk tillförlitlighet  
- Inkludera säsongsvariation i analysen  
- Testa prediktiva modeller för att förutse returer  
- Genomföra djupare analys av *Fashion*-kategorin  