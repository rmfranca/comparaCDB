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
  
  p("Compare o rendimento líquido ao ano de um CDB e de uma LCI/LCA"),
  
  sidebarLayout(
    sidebarPanel(
      dateInput(
        "cdb_dt_inicio",
        "Data da aplicação do CDB",
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
        "Data do vencimento do CDB",
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
        5,
        20,
        value = 10,
        step = 0.05,
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
      
      h3("O CDB equivale a uma LCI/LCA com taxa igual a:"),
      h4(textOutput("taxa"))
      
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  
  dc <- reactive({as.integer(input$cdb_dt_venc - input$cdb_dt_inicio)})
  du <- reactive({as.integer(bizdays(input$cdb_dt_inicio, input$cdb_dt_venc -1, "Brazil/ANBIMA"))})
  cdb_taxapre <- reactive({input$cdb_taxapre})
  
  imposto <- reactive({
    if(dc()<=180){
      22.5
    } else if(dc()>180&&dc()<=360){
      20
    } else if(dc()>360&&dc()<=720){
      17.5
    } else{
      15
    }
    
  })
  
  output$imposto <- output$taxa <- renderText({
    paste(imposto(),"%",sep="")
  })
  
  lci_taxapre <- reactive({((1+((1+cdb_taxapre()/100)^(du()/252)-1)*(1-imposto()/100))^(252/du())-1)*100})
  
  output$taxa <- renderText({
    paste(round(lci_taxapre(),2),"%",sep="")
  })
  
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)
