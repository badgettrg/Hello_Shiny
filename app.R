# Ensure Shiny is available
if (!requireNamespace("shiny", quietly = TRUE)) {
  install.packages("shiny", repos = "https://cloud.r-project.org")
}

options(shiny.launch.browser = TRUE)

# Set working directory -----
# ---- Set working directory safely (Posit Cloud + local) ----
try({
  get_script_path <- function() {
    # When run via Rscript: look for --file=... argument
    args <- commandArgs(trailingOnly = FALSE)
    file_arg <- grep("^--file=", args, value = TRUE)
    if (length(file_arg)) {
      return(normalizePath(sub("^--file=", "", file_arg), mustWork = FALSE))
    }
    # When sourced in some environments (not always set in Posit Cloud)
    if (!is.null(sys.frames()[[1]]$ofile)) {
      return(normalizePath(sys.frames()[[1]]$ofile, mustWork = FALSE))
    }
    ""  # fallback: unknown
  }
  
  script_path <- get_script_path()
  if (nzchar(script_path)) {
    setwd(dirname(script_path))
  } else {
    # In Posit Cloud, project root is already correct:
    # getwd() should be "/cloud/project"
    setwd(getwd())
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

# From project root (/cloud/project)
getwd()                       # should show "/cloud/project"
source("app.R", echo = TRUE)  # prints each line before running; shows the line that fails
