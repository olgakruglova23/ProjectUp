library(shiny)
library(ggplot2)

shinyUI(
        navbarPage("IMDB films",
          tabPanel("Data and chart",                   
             sidebarLayout(
                sidebarPanel(
                        sliderInput("rating", 
                                    "Rating:", 
                                    min = min(movies$rating),
                                    max = max(movies$rating),
                                    step = 0.1,
                                    value = c (min(movies$rating), max(movies$rating))), 
                        
                        sliderInput("year", 
                                    "Year:", 
                                    min = min(movies$year), 
                                    max = max(movies$year), 
                                    value = c(min(movies$year), max(movies$year)), sep=""),
                
                        selectInput("genre", 
                                    "Genre:", 
                                     choices = c("All", names(movies[ , c(18:24)])), 
                                     multiple = FALSE),
                        
                        downloadButton('downloadData', 'Download')),
                mainPanel(
                        tabsetPanel(
                                tabPanel(p(icon("table"), "Data"),
                                         dataTableOutput(outputId="table")),
                                tabPanel(p(icon("bar-chart-o"), "Chart"),
                                         plotOutput("bar"),
                                         textOutput("text"),
                                         tags$head(tags$style("#text{color: red;
                                                                font-size: 20px;
                                                                font-style: bold;}")),
                                         dataTableOutput("table10")
                                        )
                                )
                        )
                )
          ),
          tabPanel("About",
                   mainPanel(
                           includeMarkdown("about.md")
                   )
          )
        )
)