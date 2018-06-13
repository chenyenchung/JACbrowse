#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(markdown)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("JAC Browse"),
  
  # Navigation panel
  navbarPage(title = "", id = "navbar",
             tabPanel("TRAP-seq Query",
                       sidebarLayout(
                         sidebarPanel(
                           textInput(inputId = "trap_genename", value = "Chat", label = "Gene to query"),
                           actionButton("trap_go", label = "Search"),
                           selectInput(inputId = "trap_filetype", choices = c("pdf","png"), selected = "pdf",
                                       label = "File type for download"),
                           downloadButton(outputId = "trap_download", label = "Download Graph")
                         ),
                         mainPanel(
                           includeMarkdown("trap_info.md"),
                           tabsetPanel(id = "trap_tabplot",
                             tabPanel(title = "Raw Count Per Million (CPM)",
                                      plotOutput("trap_rawPlot")),
                             tabPanel(title = "Translation Enrichment",
                                      plotOutput("trap_scorePlot"))
                           )
                         )
                       )
             ),
             tabPanel("In vitro HMC Dev Query",
                      sidebarLayout(
                        sidebarPanel(
                          sliderInput(inputId = "hmc_nofgene",min = 1, max = 12,
                                      value = 1, step = 1,
                                      label = "Number of genes to compare"),
                          selectInput(inputId = "hmc_normalization", label = "Normalization",
                                      choices = c("FPKM", "Z-score"), selected = "FPKM"),
                          bootstrapPage(uiOutput("genetext")),
                          actionButton(inputId = "hmc_go", label = "Search"),
                          selectInput(inputId = "hmc_filetype", choices = c("pdf","png"), selected = "pdf",
                                      label = "File type for download"),
                          downloadButton(outputId = "hmc_download", label = "Download Graph")
                        ),
                        mainPanel(
                          includeMarkdown("hmc_info.md"),
                          tabsetPanel(id = "hmc_plot",
                                      tabPanel("Line Plot",
                                               plotOutput("hmc_linePlot")),
                                      tabPanel("Heatmap",
                                               plotOutput("hmc_hmPlot"))
                                      
                          )
                        )
                      )
             )
             ),
  hr(),
  div(class = "footer", "JAC Lab @ Academia Sinica 2018", align = "center")
))
