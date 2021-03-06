#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
options(repos = BiocInstaller::biocinstallRepos())

library(shiny)
library(ggplot2)
library(tidyr)
library(dplyr)
library(cowplot)
source("./preprocess/trapseq_preprocess.R")
source("./preprocess/hmc_preprocess.R")
source("./preprocess/a4v_preprocess.R")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  # TRAP-seq
  # Start processing until go button is clicked
  trap_name <- eventReactive(input$trap_go,
                              {input$trap_genename})
  
  # Ploting raw CPM
  trap_plotRaw <- function() {
    # Convert everything to lower case to ignore case
    name_filter <- tolower(trap_name())
    
    # Filter genes that are asked
    raw_df <- filter(count, tolower(external_gene_name) == name_filter)
    
    # Barplot with enlarged text
    ggplot(raw_df, aes(x = assay, y = count, group = ab, fill = ab)) +
      geom_bar(stat = "identity", position = position_dodge()) +
      theme(text = element_text(size = 20),
            axis.text = element_text(size = 15),
            axis.title = element_text(size = 15),
            plot.title = element_text(size = 20)) +
      ggtitle(raw_df$external_gene_name) +
      labs(x = "", y = "CPM", fill = "Cell Type")
  }
  
  # Ploting enrichment score (TRAP over input ratio)
  trap_plotScore <- function() {
    # Convert everything to lower case to ignore case
    name_filter <- tolower(trap_name())
    disp_df <- filter(trap_disp, tolower(gene) == name_filter)
    ggplot(disp_df, aes(x = type, y = score, color = type)) +
      geom_point(size = 5) +
      theme(text = element_text(size = 20),
            axis.text = element_text(size = 15),
            axis.title = element_text(size = 15),
            plot.title = element_text(size = 20)) +
      ggtitle(disp_df$gene) +
      labs(x = "", y = "Enrichment over Input\n(TRAP CPM/Input CPM)") +
      guides(colour = FALSE)
  }
  
  # Defining output for TRAPseq
  output$trap_rawPlot <- renderPlot({
    plot(trap_plotRaw())
  })
  output$trap_scorePlot <- renderPlot({
    plot(trap_plotScore())
  })
  output$trap_download <- downloadHandler(
    filename = function() {paste0("Trapseq.",input$trap_filetype)},
    content = function(file) {
      # Save the current active tab
      if(input$trap_tabplot == "Translation Enrichment") {
        ggsave(file, plot = trap_plotScore(),
               width = 297, height = 210, units = "mm")
      } else {
        ggsave(file, plot = trap_plotRaw(),
               width = 297, height = 210, units = "mm")
      }
    }
  )
  
  # HMC RNA-seq
  
  # Dynamic input textbox
  # output$hmc_genetext <- renderUI({
  #   # The number of text input is defined by the selection slider
  #   # https://stackoverflow.com/questions/19130455/create-dynamic-number-of-input-elements-with-r-shiny
  #   num_text <- as.integer(input$hmc_nofgene)
  #   lapply(seq(num_text), function(x) {
  #     div(style = "display:inline-block",
  #         textInput(inputId = paste0("gene",x),
  #               label = "Gene", width = 180))
  #   })
  # })
  
  # Dynamically retrieve the number of genes to check
  ###### Remove in next update ########
  # hmc_name <- eventReactive(input$hmc_go, {
  #   if (nchar(input$hmcbatchlist) < 1) {
  #     queryname <- vector(length = input$hmc_nofgene,
  #                         mode = "character")
  #     for (i in seq(input$hmc_nofgene)) {
  #       queryname[i] <- input[[paste0("gene", i)]]
  #     }
  #     return(queryname)
  #   } else {
  #     list <- input$hmcbatchlist
  #     list <- gsub(pattern = "[^A-Za-z0-9,]*", replacement = "", x = list)
  #     list <- unlist(strsplit(x = list, split = ","))
  #     return(list)
  #   }
  # })
  
  hmc_name <- eventReactive(input$hmc_go, {
      list <- input$hmcbatchlist
      list <- gsub(pattern = "[^A-Za-z0-9,]*", replacement = "", x = list)
      list <- unlist(strsplit(x = list, split = ","))
      return(list)
  })
  
  # Line Plot
  hmc_lineplot <- function() {
    # Convert everything to lower case to ignore case
    name_filter <- sapply(hmc_name(), function(x) tolower(x))
    # Filter out genes that are asked
    if(input$hmc_normalization == "FPKM") {
      disp_df <- filter(hmc_rawl, tolower(symbol) %in% name_filter)
    } else {
      disp_df <- filter(hmc_zl, tolower(symbol) %in% name_filter)
    }
    
    # Plot
    ggplot(disp_df, aes(x = variable, y = value, color = symid, group = symid)) +
      geom_point() + geom_line() +
      labs(x = "Day after differentiaion", y = input$hmc_normalization, color = "Gene") +
      theme(text = element_text(size = 20),
            axis.text = element_text(size = 15),
            axis.title = element_text(size = 15),
            plot.title = element_text(size = 20))
  }
  
  # Heatmap
  hmc_hm <- function() {
    # Convert everything to lower case to ignore case
    name_filter <- sapply(hmc_name(), function(x) tolower(x))
    # Filter out genes that are asked
    disp_df <- filter(hmc_zl, tolower(symbol) %in% name_filter)
    
    # Plot
    ggplot(disp_df, aes(x = variable, y = symid, fill = value)) +
      geom_tile() +
      scale_fill_gradientn(colors = c("blue", "white", "red")) +
      labs(x = "Day after differentiaion", y = "", fill = "Z-score") +
      theme(text = element_text(size = 20),
            axis.text = element_text(size = 15),
            axis.title = element_text(size = 15),
            plot.title = element_text(size = 20))
  }
  
  # Defining output for HMC RNA-seq
  output$hmc_linePlot <- renderPlot({
    plot(hmc_lineplot())
  })
  
  output$hmc_hmPlot <- renderPlot({
    plot(hmc_hm())
  })
  
  # Download Button
  output$hmc_download <- downloadHandler(
    filename = function() {paste0("HMC_development.",input$hmc_filetype)},
    content = function(file) {
      # Save the current active tab
      if(input$hmc_plot == "Line Plot") {
        ggsave(file, plot = hmc_lineplot(),
               width = 297, height = 210, units = "mm")
      } else {
        ggsave(file, plot = hmc_hm(),
               width = 297, height = 210, units = "mm")
      }
    }
  )
  
  # hSOD1-A4V RNA-seq

  ####### Remove in next update ########
  # Dynamic input textbox
  # output$a4v_genetext <- renderUI({
  # # The number of text input is defined by the selection slider
  # # https://stackoverflow.com/questions/19130455/create-dynamic-number-of-input-elements-with-r-shiny
  # num_text <- as.integer(input$a4v_nofgene)
  # lapply(seq(num_text), function(x) {
  #   div(style = "display:inline-block",
  #       textInput(inputId = paste0("gene",x),
  #                 label = "Gene", width = 180))
  #   })
  # })
  
  # Dynamically retrieve the number of genes to check
  # a4v_name <- eventReactive(input$a4v_go, {
  #   if (is.null(input$a4vbatchlist)) {
  #     queryname <- vector(length = input$a4v_nofgene,
  #                         mode = "character")
  #     for (i in seq(input$a4v_nofgene)) {
  #       queryname[i] <- input[[paste0("gene", i)]]
  #     }
  #     return(queryname)
  #   } else {
  #     list <- input$a4vbatchlist
  #     list <- gsub(pattern = "[^A-Za-z0-9,]*", replacement = "", x = list)
  #     list <- unlist(strsplit(x = list, split = ","))
  #     return(list)
  #   }
  # })
  
  a4v_name <- eventReactive(input$a4v_go, {
      list <- input$a4vbatchlist
      list <- gsub(pattern = "[^A-Za-z0-9,]*", replacement = "", x = list)
      list <- unlist(strsplit(x = list, split = ","))
      return(list)
  })
  
  # Line Plot
  a4v_barplot <- function() {
    # Convert everything to lower case to ignore case
    name_filter <- sapply(a4v_name(), function(x) tolower(x))
    # Filter out genes that are asked
    disp_df <- filter(a4v_l, tolower(hgnc_symbol) %in% name_filter)
    
    # Plot
    ggplot(disp_df, aes(x = hgnc_symbol, y = count, fill = sample, group = sample)) +
      geom_bar(stat = "identity", position = position_dodge()) +
      labs(x = "Sample Type", y = "Counts", fill = "Sample Type") +
      theme(text = element_text(size = 20),
            axis.text = element_text(size = 15),
            axis.title = element_text(size = 15),
            plot.title = element_text(size = 20))
  }
  
  # Heatmap
  a4v_hm <- function() {
    # Convert everything to lower case to ignore case
    name_filter <- sapply(a4v_name(), function(x) tolower(x))
    # Filter out genes that are asked
    disp_df <- filter(a4v_l, tolower(hgnc_symbol) %in% name_filter)
    
    # Plot
    ggplot(disp_df, aes(x = sample, y = hgnc_symbol, fill = count)) +
      geom_tile() +
      scale_fill_gradientn(colors = c("blue", "white", "red")) +
      labs(x = "", y = "", fill = "Count Number") +
      theme(text = element_text(size = 20),
            axis.text = element_text(size = 15),
            axis.title = element_text(size = 15),
            plot.title = element_text(size = 20))
  }
  
  # Defining output for HMC RNA-seq
  output$a4v_barPlot <- renderPlot({
    plot(a4v_barplot())
  })
  
  output$a4v_hmPlot <- renderPlot({
    plot(a4v_hm())
  })
  
  # Download Button
  output$a4v_download <- downloadHandler(
    filename = function() {paste0("SOD1_A4V_hiPS.",input$hmc_filetype)},
    content = function(file) {
      # Save the current active tab
      if(input$a4v_plot == "Bar Plot") {
        ggsave(file, plot = hmc_lineplot(),
               width = 297, height = 210, units = "mm")
      } else {
        ggsave(file, plot = hmc_hm(),
               width = 297, height = 210, units = "mm")
      }
    }
  )
  
  ### End of server chunk
})
