library(shiny)

ui <- fluidPage(
  
  titlePanel("Malaria facility visualisation app"),
  
  sidebarLayout(
    
    sidebarPanel(
      # selector for district
      selectInput(
        inputId = "select_district",
        label = "Select district",
        choices = c(
          "All",
          "Spring",
          "Bolo",
          "Dingo",
          "Barnard"
        ),
        selected = "All",
        multiple = TRUE
      ),
      # selector for age group
      selectInput(
        inputId = "select_agegroup",
        label = "Select age group",
        choices = c(
          "All ages" = "malaria_tot",
          "0-4 yrs" = "malaria_rdt_0-4",
          "5-14 yrs" = "malaria_rdt_5-14",
          "15+ yrs" = "malaria_rdt_15"
        ), 
        selected = "All",
        multiple = FALSE
      )
      
    ),
    
    mainPanel(
      # epicurve goes here
      plotOutput("malaria_epicurve")
    )
    
  )
)


# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # plot_1 <- reactive({
  #   plot_func(param = input_1)
  # })
  # 
  # output$my_plot <- renderPlot({
  #   plot_1()
  # })
}


# Run the application 
shinyApp(ui = ui, server = server)


