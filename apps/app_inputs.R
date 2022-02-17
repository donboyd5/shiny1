#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

animals <- c("dog", "cat", "mouse", "bird", "other", "I hate animals")

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),
    
    textInput("name", label=NULL, placeholder = "What's your name?"),
    fluidRow(
      actionButton("click2", "Click me!", class = "btn-danger"),
      actionButton("drink2", "Drink me!", class = "btn-lg btn-success")
    ),
    fluidRow(
      actionButton("eat", "Eat me!", class = "btn-block")
    ),
    
    passwordInput("password", "What's your password?"),
    checkboxGroupInput("animals", "What animals do you like?", animals),
    
    selectInput("state", "What's your favourite state?", state.name),
    
    actionButton("click", "Click me!"),
    actionButton("drink", "Drink me!", icon = icon("cocktail")),
    
    selectInput(
      "states", "Pick multiple states?", state.name,
      multiple = TRUE
    ),
    
    radioButtons("animal", "What's your favourite animal?", animals),
    
    checkboxInput("cleanup", "Clean up?", value = TRUE),
    checkboxInput("shutdown", "Shutdown?"),
    
    sliderInput("rng", "Range", value = c(10, 20), min = 0, max = 100),
    sliderInput("date", "date?", value = as.Date("2022-02-15"), min = as.Date("2022-02-01"), max = as.Date("2022-02-28")),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

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
