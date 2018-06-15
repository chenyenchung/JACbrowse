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
                           includeMarkdown("./intro/trap_info.md"),
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
                          # sliderInput(inputId = "hmc_nofgene",min = 1, max = 12,
                          #             value = 1, step = 1,
                          #             label = "Number of genes to compare"),
                          selectInput(inputId = "hmc_normalization", label = "Normalization",
                                      choices = c("FPKM", "Z-score"), selected = "FPKM"),
                          textInput(inputId = "hmcbatchlist",
                                    label = "List of gene name to query",
                                    placeholder = '"Mnx1", "Chat", "Slc18a3"'),
                          # bootstrapPage(uiOutput("hmc_genetext")),
                          actionButton(inputId = "hmc_go", label = "Search"),
                          selectInput(inputId = "hmc_filetype", choices = c("pdf","png"), selected = "pdf",
                                      label = "File type for download"),
                          downloadButton(outputId = "hmc_download", label = "Download Graph")
                        ),
                        mainPanel(
                          includeMarkdown("./intro/hmc_info.md"),
                          tabsetPanel(id = "hmc_plot",
                                      tabPanel("Line Plot",
                                               plotOutput("hmc_linePlot")),
                                      tabPanel("Heatmap",
                                               plotOutput("hmc_hmPlot"))
                                      
                          )
                        )
                      )
             ),
             tabPanel("hSOD1-A4V Query",
                      sidebarLayout(
                        sidebarPanel(
                          # sliderInput(inputId = "a4v_nofgene",min = 1, max = 12,
                          #             value = 1, step = 1,
                          #             label = "Number of genes to compare"),
                          # bootstrapPage(uiOutput("a4v_genetext")),
                          textInput(inputId = "a4vbatchlist",
                                    label = "List of gene name to query",
                                    placeholder = '"Mnx1", "Chat", "Slc18a3"'),
                          actionButton(inputId = "a4v_go", label = "Search"),
                          selectInput(inputId = "a4v_filetype", choices = c("pdf","png"), selected = "pdf",
                                      label = "File type for download"),
                          downloadButton(outputId = "a4v_download", label = "Download Graph")
                        ),
                        mainPanel(
                          includeMarkdown("./intro/a4v_info.md"),
                          tabsetPanel(id = "a4v_plot",
                                      tabPanel("Bar Plot",
                                               plotOutput("a4v_barPlot")),
                                      tabPanel("Heatmap",
                                               plotOutput("a4v_hmPlot"))
                                      
                          )
                        )
                      )
             )
             ),
  hr(),
  div(class = "footer", "JAC Lab @ Academia Sinica 2018", align = "center")
))
