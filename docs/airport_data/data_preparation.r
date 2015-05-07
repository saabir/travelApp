# prepare data from countries, airports and routes to use it for the 
# TravelApp iOS application

### WEATHER DATA ---------------------------------------------------------------

# read weather data aggregated from weatherbase.com
dta.weather <- read.table(file="weather.csv", header=FALSE, sep=";")
                          
# set names of the dataset
names(dta.weather) <- c("country", "type", "month", "value")                          

# reshape the data to the following format
# country, month, average, average_high, average_low, precipitation
dta.weather <- reshape(dta.weather, direction="wide", timevar="type", idvar=c("country","month"))

# remove row.names
row.names(dta.weather) <- NULL

# set column names correctly
names(dta.weather) <- c("country", "month", "average", "average_high", "average_low", "precipitation")

# save file to disk
write.csv2(dta.weather, file="weather_formatted.csv", row.names=FALSE)
                          
# clean-up
rm(dta.weather)



### COUNTRY & AIRPORT DATA -----------------------------------------------------

### load countries (www.ourairports.com)
dta.countries <- read.csv(file="countries.csv")

# load latitude longitude from google geocoding
dta.coordinates <- read.csv2(file="geocodes_countries.txt")

# drop index column
dta.coordinates$index <- NULL

# generate country dataset
dta.countries.base <- dta.countries[, c("code", "name", "continent")]


# add coordinates to countries
dta.countries.base <- merge(dta.countries.base, dta.coordinates, by="code", all.x = TRUE)

# save data in csv file
write.csv2(dta.countries.base, file="countries_import.csv")

# get only wikipedia info
dta.countries.wiki <- dta.countries[, c("code", "wikipedia_link")]

# rename columns
names(dta.countries.wiki) <- c("country_iso_code", "value")

# add type of information (sorting not needed)
dta.countries.wiki$type <- "wikipedia_link"

# save file
#write.csv2(dta.countries.wiki, file="countries_wiki_link.csv")

# clean-up
rm(dta.countries.wiki)

### 1. load data files

# load airports (www.ourairports.com)
dta.airports_info <- read.csv(file="airports.csv")

# load airtports (www.openflights.org)
dta.airports <- read.table(file="airports.dat.txt", header=FALSE, sep=",")

# set column headers for airports
names(dta.airports) <- c("airport_id", "name", "city", "country", "iata", "icao", "latitude", "longitude", "altitude", "timezone", "dst")

# load airlines (www.openflights.org)
dta.airlines <- read.table(file="airlines.dat.txt", header=FALSE, sep=",")

# set column headers for airlines
names(dta.airlines) <- c("airline_id", "name", "alias", "iata", "icao", "callsign", "country", "active")

# load routes (www.openflights.org)
dta.routes <- read.table(file="routes.dat.txt", header=FALSE, sep=",")

#set column headers for routes
names(dta.routes) <- c("airline","airline_id", "source_airport", "source_airport_id", "destination_airport", "destination_airport_id", "codeshare", "stops", "equipment")


### 2. reshape data

# remove all airports from airports_info that are not in the airports list
dta.airports_info <- subset(dta.airports_info, iata_code %in% dta.airports$iata)

# add new rows to the airport list
dta.airports$type <- NA
dta.airports$iso_country <- NA

# convert iata-columns from factor to characters
dta.airports_info$iata_code <- as.character(dta.airports_info$iata_code)
dta.airports_info$iso_country <- as.character(dta.airports_info$iso_country)
dta.airports_info$type <- as.character(dta.airports_info$type)
dta.airports$iata <- as.character(dta.airports$iata)

# combine airport info with airport list (the hard way)
for (i in 1:nrow(dta.airports)) {
  # get a subset of the airport-info data (matching airport)
  tmp <- subset(dta.airports_info, iata_code == dta.airports$iata[i])
  
  # check if any results were returned (airport found)
  if (nrow(tmp) > 0) {
    # add type and iso_country information
    dta.airports$type[i] <- tmp$type[1]
    dta.airports$iso_country[i] <- tmp$iso_country[1]
  }
  
  # clean-up
  rm(tmp)
  
}

# clean-up
rm(i)

# get only country codes
dta.iso_countries <- dta.countries[, c("code", "name")]

# merge country code to airport (matching by country name)
dta.airports2 <- merge(dta.airports, dta.iso_countries, by.x="country", by.y="name", all.x = TRUE)

# save the data in a csv file (we still have to replace the country iso code for
# some airports (not found in dta.airports_info)
write.csv2(dta.airports, file="airports_preformatted2.csv", row.names=FALSE)

### 3. edit routes and calculate distances

dta.routes2 <- subset(dta.routes, (source_airport_id %in% dta.airports$airport_id) & (destination_airport_id %in% dta.airports$airport_id))

# calculate distances

# write routes
write.csv2(dta.routes2, file="routes_import.csv")