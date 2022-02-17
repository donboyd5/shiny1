library(shiny)
library(ggplot2)

dataset <- diamonds

ui <- fluidPage(
  
  title = "Diamonds Explorer",
  
  plotOutput('plot'),
  
  hr(),
  
  fluidRow(
    column(3,
           h4("Diamonds Explorer"),
           sliderInput('sampleSize', 'Sample Size', 
                       min=1, max=nrow(dataset), value=min(1000, nrow(dataset)), 
                       step=500, round=0),
           br(),
           checkboxInput('jitter', 'Jitter'),
           checkboxInput('smooth', 'Smooth')
    ),
    column(4, offset = 1,
           selectInput('x', 'X', names(dataset)),
           selectInput('y', 'Y', names(dataset), names(dataset)[[2]]),
           selectInput('color', 'Color', c('None', names(dataset)))
    ),
    column(4,
           selectInput('facet_row', 'Facet Row', c(None='.', names(dataset))),
           selectInput('facet_col', 'Facet Column', c(None='.', names(dataset)))
    )
  )
)



server <- function(input, output) {
  
  rv <- reactiveValues(
    norm = rnorm(500), 
    unif = runif(500),
    chisq = rchisq(500, 2))
  
  observeEvent(input$renorm, { rv$norm <- rnorm(500) })
  observeEvent(input$reunif, { rv$unif <- runif(500) })
  observeEvent(input$rechisq, { rv$chisq <- rchisq(500, 2) })
  
  output$norm <- renderPlot({
    hist(rv$norm, breaks = 30, col = "grey", border = "white",
         main = "500 random draws from a standard normal distribution")
  })
  output$unif <- renderPlot({
    hist(rv$unif, breaks = 30, col = "grey", border = "white",
         main = "500 random draws from a standard uniform distribution")
  })
  output$chisq <- renderPlot({
    hist(rv$chisq, breaks = 30, col = "grey", border = "white",
         main = "500 random draws from a Chi Square distribution with two degree of freedom")
  })
}

shinyApp(server = server, ui = ui)

