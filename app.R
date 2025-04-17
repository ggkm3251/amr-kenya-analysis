library(shiny)
library(readr)
library(dplyr)
library(ggplot2)

# Load data
amr_data <- read_csv("data/amr_data.csv") %>%
  mutate(
    resistant = ifelse(resistant == "Yes", 1, 0),
    sample_date = as.Date(sample_date)
  )

ui <- fluidPage(
  titlePanel("Kenya Antimicrobial Resistance Dashboard"),

  sidebarLayout(
    sidebarPanel(
      selectInput("county", "Select County:", 
                  choices = c("All", unique(amr_data$county))),
      selectInput("pathogen", "Select Pathogen:", 
                  choices = c("All", unique(amr_data$pathogen)))
    ),

    mainPanel(
      plotOutput("resistancePlot"),
      br(),
      tableOutput("summaryTable")
    )
  )
)

server <- function(input, output) {
  # Filtered dataset
  filtered_data <- reactive({
    data <- amr_data
    if (input$county != "All") {
      data <- data[data$county == input$county, ]
    }
    if (input$pathogen != "All") {
      data <- data[data$pathogen == input$pathogen, ]
    }
    data
  })

  # Resistance plot
  output$resistancePlot <- renderPlot({
    data <- filtered_data()
    if (nrow(data) == 0) return(NULL)

    data %>%
      group_by(pathogen) %>%
      summarise(resistance_rate = mean(resistant)) %>%
      ggplot(aes(x = reorder(pathogen, resistance_rate), y = resistance_rate)) +
      geom_col(fill = "#2C7BB6") +
      coord_flip() +
      labs(
        title = "Resistance Rate by Pathogen",
        x = "Pathogen",
        y = "Resistance Rate"
      ) +
      theme_minimal()
  })

  # Summary table
  output$summaryTable <- renderTable({
    head(filtered_data())
  })
}

shinyApp(ui = ui, server = server)
