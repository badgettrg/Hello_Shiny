# app.R — Hello_Shiny (deploy-friendly)

library(shiny)

ui <- fluidPage(
  titlePanel("Hello Shiny!"),
  sidebarLayout(
    sidebarPanel(helpText("This is a minimal Shiny app.")),
    mainPanel(h2("Hello, world!"))
  )
)

server <- function(input, output) {}

# On shinyapps.io, just call shinyApp — no install.packages(), no runApp(), no browser options
shinyApp(ui = ui, server = server)
