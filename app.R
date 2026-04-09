library(shiny)
library(knitr)
library(grid)

ui <- fluidPage(
  titlePanel("Child mortality estimates"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "set_choice",
        "Country:",
        choices = c("Kenya", "Brazil", "Estonia", "Syrian Arab Republic")
      ),
      tags$p(
        "Based on methods described in [enter citation of paper here].",
        style = "margin-top: 10px; font-size: 14px; color: #555;"
      )
    ),
    
    mainPanel(
      uiOutput("png_display")
    )
  )
)

server <- function(input, output, session) {
  
  get_files <- function(country) {
    file_roots <- c("-mrs.png", "-pars-ll.png", "-pars-pe.png", "-comp-to-dh.png")
    files <- paste0("www/", country, "/", country, file_roots)
    files <- files[file.exists(files)]
    files <- gsub("www/", "", files)
    return(files)
  }
  countries <- basename(setdiff(list.dirs("www"), "www"))
  png_sets <- list()
  for (i in 1:length(countries)) {
    png_sets[i] <- list(get_files(countries[i]))
  }
  names(png_sets) <- countries
  
  output$png_display <- renderUI({
    req(input$set_choice)
    
    files <- png_sets[[input$set_choice]]
    titles <- c("Mortality rate estimates over time",
                "Parameter estimates (log-logistic survival model)",
                "Parameter estimates (piecewise-exponential survival model)",
                "Comparison of survival models")[1:length(files)]
    
    tagList(
      lapply(seq_along(files), function(i) {
        tagList(
          tags$h4(titles[i], style = "margin-top:20px; margin-bottom:5px;"),
          tags$img(
            src = files[i],
            width = "100%",
            style = "margin-bottom: 30px;"
          )
        )
      })
    )
  })
}

shinyApp(ui, server)