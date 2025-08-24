# Ensure Shiny is available
if (!requireNamespace("shiny", quietly = TRUE)) {
  install.packages("shiny", repos = "https://cloud.r-project.org")
}

options(shiny.launch.browser = TRUE)

# Set working directory -----
try({
  this_file <- if (!interactive()) {
    # When run via Rscript
    normalizePath(commandArgs(trailingOnly = FALSE) |>
                    sub("^--file=", "", x = _, perl = TRUE) |>
                    Filter(function(z) grepl("\\.R$", z, ignore.case = TRUE), _)[1])
  } else {
    # When run inside RStudio
    getOption("rstudio.notebook.executing", FALSE)
    rstudioapi::getSourceEditorContext()$path
  }
  if (!is.na(this_file) && nzchar(this_file)) {
    setwd(dirname(this_file))
  }
}, silent = TRUE)

# Packages ----------

library(shiny)

# Run app ---------
ui <- fluidPage(
  titlePanel("Hello Shiny!"),
  sidebarLayout(
    sidebarPanel(helpText("This is a minimal Shiny app.")),
    mainPanel(h2("Hello, world!"))
  )
)

server <- function(input, output) {}

# If run in RStudio or interactively, this is enough:
if (interactive()) {
  shinyApp(ui, server)
} else {
  # If run via Rscript (e.g., from a .bat file), do this:
  shiny::runApp(list(ui = ui, server = server), launch.browser = TRUE)
}
