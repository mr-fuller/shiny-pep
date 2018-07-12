#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
lucas <- api_download_plot(19)
wood <- api_download_plot(21)
monroe <- api_download_plot(23)
ottawa <- api_download_plot(25)
sandusky <- api_download_plot(27)
# Define UI for application that draws a histogram
ui <- navbarPage("TMACOG Area County Population Pyramids",
  tabPanel("Lucas",fluidRow(column(6,offset = 3, plotlyOutput("lucas")))),
  tabPanel("Wood",fluidRow(column(6, offset = 3, plotlyOutput("wood")))),
  tabPanel("Monroe",fluidRow(column(6,offset = 3, plotlyOutput("monroe")))),
  tabPanel("Ottawa",fluidRow(column(6,offset = 3, plotlyOutput("ottawa")))),
  tabPanel("Sandusky",fluidRow(column(6,offset = 3, plotlyOutput("sandusky"))))
)
   
   

# Define server logic required to draw a histogram
server <- function(input, output) {
   
  output$lucas <- renderPlotly({
    print(lucas)
  })
  output$wood <- renderPlotly({
    print(wood)
  })
  output$monroe <- renderPlotly({
    print(monroe)
  })
  output$ottawa <- renderPlotly({
    print(ottawa)
  })
  output$sandusky <- renderPlotly({
    print(sandusky)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

