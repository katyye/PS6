library(shiny)
library(tidyverse)

data <- read.delim("UAH-lower-troposphere-long.csv")

ui <- fluidPage(
  mainPanel(
    tabsetPanel(
      tabPanel("About",
               fluidPage(
                 p("This app uses satellite temperature data from ",
                   strong("UAH")),
                 br(),
                 p("Temperature ", em("temp "),
                      "is measured as deviation (deg C) from 1978-2023 baseline"),
                 p("The dataset contains",nrow(data),"observations and",
                      ncol(data),"variables"),
                 p("Here is a small (random) sample of data:")
                ),
               mainPanel(
                 tableOutput("sample")
               )
      ),
      
      tabPanel("Plots",
               sidebarLayout(
                 sidebarPanel(
                   p("You can analyze the global temperature for different regions. 
                            Select the regions you are interested in. 
                            You see a monthly scatterplot and the corresponding trend lines."),
                   br(),
                   checkboxInput("display_trends", "Display trend(s)"),
                   br(),
                   radioButtons("palettes", "Choose a palette:",
                                choices = c("Spectral" = "Spectral",
                                            "PuOr" = "PuOr"),
                                selected = "Spectral"),
                   br(),
                   uiOutput("checkboxes")
                 ),
                 mainPanel(
                   plotOutput("plot"),
                   textOutput("plot_text")
                 )
               )
      ),
      
      tabPanel("Tables",
               sidebarLayout(
                 sidebarPanel(
                   p("This panel displays average temperature over different time periods:",
                      em("months") , ",",em("years"), "and", em("decades")),
                   br(),
                   radioButtons("time", "Average over:",
                                choices = c("month" = "month",
                                            "year" = "year",
                                            "decade" = "decade"),
                                selected = "month")
                 ),
                 mainPanel(
                   textOutput("Tables_text"),
                   tableOutput("Tables")
                 )
               )
      )
    )
  )
)


server <- function(input, output) {
  output$sample <- renderTable({
      sample_n(data,5)
  })
  output$checkboxes <- renderUI({
    checkboxGroupInput(
      "region","Select the region(s) to display",
      choices = unique(data$region),
      selected = "globe")
  })

  plots <- reactive({
    data%>%
      filter(region %in% input$region)
  })
  output$plot <- renderPlot({
    gg <- plots() %>%
      ggplot(aes(x=year, y=temp, color=region))+
        geom_point()+
        labs(x="Year", y="temparature")+
        scale_color_brewer(palette = input$palettes)
    if(input$display_trends){
      gg <- gg+
        geom_smooth(formula= y~x, method = "lm", se = FALSE)
    }
    gg
  })
  output$plot_text <- renderText({
      paste("Time period 1978-2023. In total", nrow(plots()),"non-missing observations")
  })

  tableSample <- reactive({
    if(input$time == "month"){
      data%>%
        group_by(year,month)%>%
        summarize(temp = mean(temp), .groups = "drop")
    } else if (input$time == "year"){
      data%>%
        group_by(year)%>%
        summarize(temp = mean(temp))
    } else{
      data%>%
        mutate(decade = 10*floor(year/10))%>%
        group_by(decade)%>%
        summarize(temp = mean(temp))
    }
  })
  output$Tables <- renderTable({
    tableSample()
  })
  output$Tables_text <- renderText({
    temp_sample <- tableSample()$temp
    paste("Temperature range",round(min(temp_sample), digits = 2) ,"-",
          round(max(temp_sample), digits = 2))
  })
}

shinyApp(ui = ui, server = server)
