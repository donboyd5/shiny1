library(shiny)
library(tidyverse)

ui <- fluidPage(
  sliderInput(inputId = "num", 
    label = "Choose a number", 
    value = 35, min = 1, max = 100),
  plotOutput("hist")
)

server <- function(input, output) {
  # output$hist <- renderPlot({
  #   hist(rnorm(input$num))
  # })
  output$hist <- renderPlot({
    df <- tibble(x=rnorm(input$num))
    df %>%
      ggplot(aes(x)) + 
      geom_histogram(fill="blue") + # binwidth=2, 
      ggtitle("Don's test") +
      theme_bw()
  })
  
}

shinyApp(ui = ui, server = server)