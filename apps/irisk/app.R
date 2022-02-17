library(shiny)
library(tidyverse)
library(glue)
# library(bdata)

# data(package="bdata")
# glimpse(iris)
# glimpse(sgtax.a)
# summary(sgtax.a)
# summary(spop.a)
# count(sgtax.a, item, desc) %>% print(n=35)

#  create the data
# vars <- c("C105", "T09", "T40", "T41", "T10", "T16", "T50", "T53", "T99")
# vlabs <- c("tottax", "gst", "iit", "cit",  "abt", "tpt", "egt", "sevtax", "other")
# df <- sgtax.a %>%
#   filter(item %in% vars, year==2020) %>%
#   mutate(name=factor(item, levels=vars, labels=vlabs)) %>%
#   select(stabbr, name, value) %>%
#   left_join(spop.a %>%
#               filter(year==2020) %>%
#               select(stabbr, pop=value),
#             by="stabbr") %>%
#   mutate(value=value / pop * 1000) %>%
#   pivot_wider(values_fill = 0)
# saveRDS(df, here::here("apps", "irisk", "df.rds"))

df <- readRDS(here::here("apps", "irisk", "df.rds")) %>%
  filter(stabbr != "US") %>%
  mutate(pop=log(pop))

# vars <- c("tottax", "gst", "iit", "abt", "tpt")
vars <- setdiff(names(df), "stabbr")

# k-means only works with numerical variables,
# so don't give the user the option to select
# a categorical variable
# vars <- setdiff(names(iris), "Species")

ui <- pageWithSidebar(
  headerPanel('k-means clustering'),
  sidebarPanel(
    selectInput('xcol', 'X Variable', vars,  selected = vars[[1]]),
    selectInput('ycol', 'Y Variable', vars, selected = vars[[2]]),
    selectInput('zcol', 'Unseen', vars,  selected = vars[[3]]),
    numericInput('clusters', 'Cluster count', 3, min = 1, max = 9)
  ),
  mainPanel(
    plotOutput('plot1')
  )
)



server <- function(input, output, session) {
  
  # Combine the selected variables into a new data frame
  selectedData <- reactive({
    df[, c("stabbr", input$xcol, input$ycol, input$zcol)]
  })
  
  clusters <- reactive({
    kmeans(selectedData()[, -1], input$clusters)
  })
  
  output$plot1 <- renderPlot({
    # browser()
    # print(str(clusters()$cluster))
    # cat(file=stderr(), "clusters: ", input$clusters, "\n")
   # cat(file=stderr(), selectedData()[, input$xcol])
    range <- max(selectedData()[[input$xcol]]) - min(selectedData()[[input$xcol]])
    xmdn <- median(selectedData()[[input$xcol]])
    ymdn <- median(selectedData()[[input$ycol]])
    
    gtitle <- glue("States clustered by {input$xcol}, {input$ycol}, and unseen {input$zcol}")
    
    selectedData() %>%
      mutate(group=as.factor(clusters()$cluster)) %>%
      ggplot(aes(.data[[input$xcol]], .data[[input$ycol]], colour=group)) +
      geom_point(size=1.5) +
      geom_text(aes(label=stabbr), nudge_x = range / 80, size=2) +
      geom_hline(yintercept = ymdn) +
      geom_vline(xintercept = xmdn) +
      theme_bw() +
      ggtitle(gtitle)
  })
  
  # output$plot1 <- renderPlot({
  #   palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
  #             "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))
  # 
  #   par(mar = c(5.1, 4.1, 0, 1))
  #   plot(selectedData()[, -1],
  #        col = clusters()$cluster,
  #        pch = 20, cex = 3)
  #   points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
  # })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

# shiny::runApp(display.mode="showcase")
