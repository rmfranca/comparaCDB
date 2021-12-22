#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(bizdays)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel('Comparador de CDB e LCI/LCA'),
    
    p("Informações do CDB"),
    
    sidebarLayout(
      sidebarPanel(
        dateInput(
          "cdb_dt_inicio",
          "Data da aplicação",
          format = "dd-M-yyyy",
          startview = "month",
          weekstart = 0,
          language = "pt-BR",
          width = NULL,
          autoclose = TRUE,
          datesdisabled = NULL,
          daysofweekdisabled = NULL
        ),
        dateInput(
          "cdb_dt_venc",
          "Data do vencimento",
          format = "dd-M-yyyy",
          startview = "month",
          weekstart = 0,
          language = "pt-BR",
          width = NULL,
          autoclose = TRUE,
          datesdisabled = NULL,
          daysofweekdisabled = NULL
        ),
        sliderInput(
          "cdb_taxapre",
          "Selecione a taxa pré-fixada do CDB",
          0,
          25,
          value = 10,
          step = 0.01,
          round = FALSE,
          ticks = TRUE,
          animate = TRUE,
          post = " %",
          timeFormat = NULL,
          timezone = NULL,
          dragRange = TRUE
        )
      ),
      mainPanel(
        
      )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  observe({   
    
    cdb_dt_inicio <- input$cdb_dt_inicio
    cdb_dt_venc <- input$cdb_dt_venc
    
    du <- bizdays(cdb_dt_inicio, cdb_dt_venc -1, "Brazil/ANBIMA")
   
  })

}

# Run the application 
shinyApp(ui = ui, server = server)
