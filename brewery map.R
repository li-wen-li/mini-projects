library(uszipcodes)
library(leaflet)
library(stringr)
library(dplyr)
library(htmltools)

beers <- read.csv("~/Downloads/breweries_us.csv")
colnames(beers)
raw_zip <- get_zip(beers$address)
sum(contain_letter(raw_zip))
beers$Zip <- as.integer(clean_zip(raw_zip))
tail(beers)
beer_location <- inner_join(beers, zip_table[ , c(1,4,5)])



content <- paste(sep = "\n",
                 beer_location$brewery_name,
                 beer_location$website
)

beer_icon <- makeIcon(
  iconUrl = "~/Downloads/beer.png",
  iconWidth = 28, iconHeight = 30,
  iconAnchorX = 0, iconAnchorY = 0
)

beer_map <- leaflet(beer_location) %>%
  setView(lng = -98.583, lat = 39.833, zoom = 4) %>% 
  addTiles() %>% 
  addProviderTiles(providers$Wikimedia) %>% 
  addMarkers(
    clusterOptions = markerClusterOptions(),
    popup = htmlEscape(content),
    icon = beer_icon
  )


