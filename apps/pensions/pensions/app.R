#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Pension Simulation Model"),
    
    textInput("intext", "Enter the text to display below:"),
    textOutput("text"),

    tabsetPanel(              
      tabPanel(title = "Main",
               # plotOutput("norm"),
                actionButton("run", "Run")
      ),
      tabPanel(title = "Benefits",
               # plotOutput("norm"),
               # actionButton("renorm", "Resample")
      ),
      tabPanel(title = "Funding policy",
               # plotOutput("unif"),
               # actionButton("reunif", "Resample")
      ),
      tabPanel(title = "Investment environment",
               # plotOutput("chisq"),
               # actionButton("rechisq", "Resample")
      )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$text <- renderText({ input$intext })

    # output$distPlot <- renderPlot({
    #     # generate bins based on input$bins from ui.R
    #     x    <- faithful[, 2]
    #     bins <- seq(min(x), max(x), length.out = input$bins + 1)
    # 
    #     # draw the histogram with the specified number of bins
    #     hist(x, breaks = bins, col = 'darkgray', border = 'white')
    # })
}

# Run the application 
shinyApp(ui = ui, server = server)
