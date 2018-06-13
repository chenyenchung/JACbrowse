#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# install.packages(c("shiny", "ggplot2", "tidyr", "dplyr",
#                   "cowplot", "markdown", "data.table", "Sushi"))





ui <- fluidPage(
  titlePanel("JAC Browse"),
  navbarPage("",
             tabPanel("TRAP-seq Query",
                      sidebarLayout(
                        sidebarPanel(
                          textInput(inputId = "genename", value = "Chat", label = "Gene to query"),
                          actionButton("go", label = "Search"),
                          selectInput(inputId = "filetype", choices = c("pdf","png"), selected = "pdf",
                                      label = "File type for download"),
                          downloadButton(outputId = "download", label = "Download Graph")
                        ))))
)



ui <- fluidPage(
   # Application title
   titlePanel("TRAP-seq Query"),
   sidebarLayout(
      sidebarPanel(
        textInput(inputId = "genename", value = "Chat", label = "Gene to query"),
        actionButton("go", label = "Search"),
        selectInput(inputId = "filetype", choices = c("pdf","png"), selected = "pdf",
                    label = "File type for download"),
        downloadButton(outputId = "download", label = "Download Graph")
      ),
      
      mainPanel(
        tabsetPanel(
          tabPanel("TRAP-seq",
                   fluidRow(
                     column(
                       width = 4,
                       includeMarkdown("info.md"),
                       plotOutput("rawPlot"),
                       plotOutput("scorePlot")
                     ),
                    
                   )
          )
        )
      )
   ),
   hr(),
   div(class = "footer", "JAC Lab @ Academia Sinica 2018", align = "center")
)

# Define server logic required to draw a histogram

# Run the application 
shinyApp(ui = ui, server = server)

