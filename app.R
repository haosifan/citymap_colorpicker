#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(colourpicker)
library(ggplot2)
library(readr)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            colourInput(inputId = "color_river", label = "Farbe River", value = "#0000FF"),
            colourInput(inputId = "color_bigstreet", label = "Farbe große Straße", value = "#000000")
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    big_streets <- reactive({
        read_rds("data/big_streets.Rdata")
    })
    
    river <- reactive({
        read_rds("data/river.Rdata")
    })

    output$distPlot <- renderPlot({
        ggplot() +
            geom_sf(data = river()$osm_lines,
                    inherit.aes = FALSE,
                    color = input$color_river,
                    size = .8,
                    alpha = .3) +
            geom_sf(data = big_streets()$osm_lines,
                    inherit.aes = FALSE,
                    color = input$color_bigstreet,
                    size = .5,
                    alpha = .6)+
        coord_sf(xlim = c(7.0, 7.4), 
                 ylim = c(51.24, 51.32),
                 expand = FALSE)+
        theme_void()+
            theme(plot.title = element_text(size = 20, face="bold", hjust=.5),
                  plot.subtitle = element_text(size = 8, hjust=.5, margin=margin(2, 0, 5, 0))) +
        labs(title = "WUPPERTAL", subtitle = "51.26212°N / 7.129968°E")
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
