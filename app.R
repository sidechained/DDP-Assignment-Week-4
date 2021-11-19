library(shiny)
library(dplyr)
library(leaflet)

# Reading in toilet data:
library("readxl")
toilet_data_url <- 'https://www.berlin.de/sen/uvk/_assets/verkehr/infrastruktur/oeffentliche-toiletten/berliner-toiletten-standorte.xlsx'
tmp <- tempfile()
download.file(toilet_data_url, tmp, mode = "wb")
toilet_data <- read_xlsx(tmp, skip=3)
toilet_data <- toilet_data %>%
    mutate(Longitude = as.numeric(sub(",", ".", Longitude))) %>%
    mutate(Latitude = as.numeric(sub(",", ".", Latitude))) %>%
    mutate(isHandicappedAccessible = as.numeric(isHandicappedAccessible))

# Reading in PostalCode data - used as basis for drop down menu
postcode_data_url <- 'https://launix.de/launix/wp-content/uploads/2019/06/PLZ.csv'
tmp <- tempfile()
download.file(postcode_data_url, tmp, mode = "wb")
plz_data <- read.csv(tmp, sep=";", header=FALSE)
colnames(plz_data) <- c("plz", "city", "lng", "lat")
plz_data <- plz_data %>% filter(city=="Berlin") %>% select(-city)

# Choosing marker icons:
IconSet <- awesomeIconList(
    makeAwesomeIcon(icon= 'venus-mars', library = "fa"),
    makeAwesomeIcon(icon= 'universal-access', library = "fa")
)

# Defining the User Interface and page text:
ui <- fluidPage(title = "Berlin Bathroom Beacon",
                h2("Berlin Bathroom Beacon v1.0"),
                h3("WC Finder: Conveniently find conveniences in your neighbourhood!"),
                h4("Description"),
                "The following is a simple interactive map-based application created using Shiny and Leaflet, that allows users to find public bathroom facilities located within the Berlin municipality. The results are based on an open data set taken from the the berlin.de website",
                a("here.", href="https://daten.berlin.de/datensaetze/standorte-der-öffentlichen-toiletten"),
                "This data is displayed on a map of Berlin provided by the",
                a("Open Street Map", href="https://www.openstreetmap.org/#map=10/52.5072/13.4248"),
                "project.",
                h4("Usage"),
                "The default view shows all public facilities, zoomed out to cover the whole of Berlin. As the map can become very crowded, the three drop-down menu's can be used to filter the results by postcode, cost or accessibility. Some of these attributes are also shown by the kind of icon each marker has, for example facilities suitable for disabled people have an accessibility icon, whilst non-accessible toilets have a male/female icon. In addition, paid toilets have a gold 'coin' at the base of their marker, while fee-free toilets have no coin.",
                p(),
                "Note: You may zoom freely within the bounds of Berlin, but be aware that using any of the drop-down menu's the view will be reset to the initial one (i.e. all of Berlin).",
                h4("Forthcoming improvements in v1.1"),
                HTML("<ul>
                     <li>Allowing search by district as well as postcode (i.e. Mitte, Neukölln)</li>
                     <li>Overlaying district and postcode boundaries on the map (shape datasets exist for this)</li>
                     </ul>"),
                fluidRow(
                    column(4,
                           selectInput(
                               "selectedPostalCode",
                               h3("Postcode"),
                               choices = append("All", plz_data %>% pull(plz)),
                               selected = 1
                           )),
                    column(4,
                           selectInput(
                               "selectedCost",
                               h3("Cost"),
                               choices = c("All", "Free Only", "Paid Only"),
                               selected = 1
                           )),
                    column(4,
                           selectInput(
                               "selectedAccessibility",
                               h3("Accessibility"),
                               choices = c("All", "Accessible Only", "Non-accessible Only"),
                               selected = 1
                           ))
                ),
                leafletOutput("mymap"))

# Server calculation code:
server <- function(input, output) {
    output$mymap <- renderLeaflet({
        toilet_data_toDisplay <- toilet_data
        if (input$selectedPostalCode != "All") {
            toilet_data_toDisplay <-
                toilet_data_toDisplay %>% filter(PostalCode == input$selectedPostalCode)
        }
        if (input$selectedCost == "Free Only") {
            toilet_data_toDisplay <-
                toilet_data_toDisplay %>% filter(Price == "0,00")
        }
        if (input$selectedCost == "Paid Only") {
            toilet_data_toDisplay <-
                toilet_data_toDisplay %>% filter(Price == "0,50")
        }
        if (input$selectedAccessibility == "Accessible Only") {
            toilet_data_toDisplay <-
                toilet_data_toDisplay %>% filter(isHandicappedAccessible == TRUE)
        }
        if (input$selectedAccessibility == "Non-accessible Only") {
            toilet_data_toDisplay <-
                toilet_data_toDisplay %>% filter(isHandicappedAccessible == FALSE)
        }
        leaflet(options = leafletOptions(minZoom = 10)) %>%
            # add different provider tiles
            addProviderTiles("OpenStreetMap",
                             # give the layer a name
                             group = "OpenStreetMap") %>%
            # initial setView for whole of Berlin
            setView(lng = 13.4248,
                    lat = 52.5072,
                    zoom = 10) %>%
            setMaxBounds(
                lng1 = 13.4248 + 0.1,
                lat1 = 52.5072 + 0.1,
                lng2 = 13.4248 - 0.1,
                lat2 = 52.5072 - 0.1
            ) %>%
            addAwesomeMarkers(
                lat = toilet_data_toDisplay$Latitude,
                lng = toilet_data_toDisplay$Longitude,
                icon = IconSet[toilet_data_toDisplay$isHandicappedAccessible +
                                   1]
            ) %>%
            addCircleMarkers(
                lat = toilet_data_toDisplay$Latitude,
                lng = toilet_data_toDisplay$Longitude,
                color = "black",
                opacity = case_when(
                    toilet_data_toDisplay$Price == "0,00" ~ 0,
                    toilet_data_toDisplay$Price == "0,50" ~ 1
                ),
                weight = 2,
                fillColor = "gold",
                fillOpacity = case_when(
                    toilet_data_toDisplay$Price == "0,00" ~ 0,
                    toilet_data_toDisplay$Price == "0,50" ~ 1
                )
            )
    })
}

# Run the application
shinyApp(ui = ui, server = server)