#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  theme = "cerulean.css",
  # Application title
  titlePanel("COBIApp2 - Completar datos de monitoreo con listas de especies"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(h2("Lista de especies"),
                 fileInput(inputId ="lista",
                           label = "Seleccionar archivo",
                           accept = ".csv"),
                 h2("Base de datos"),
                 fileInput(inputId ="datos",
                           label = "Seleccionar archivo",
                           accept = ".csv"),
                 selectInput(inputId = "completer",
                             label = "Completar base de datos por:",
                             choices = c("Región",
                                         "Localidad"),
                             selected = "Región"),
                 h2("Ejemplos de Formatos"),
                 downloadButton('downloadA',
                                'Lista'),
                 downloadButton('downloadB',
                                'Base'),
                 p("Si requiere convertir los datos al formato específico, puede usar la siguiente aplicación:"),
                 a("COBIApp", href="https://jcvd.shinyapps.io/COBIApp/", target="_blank")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(h2("Vista Previa de Datos de Salida"),                                               
              sliderInput(inputId="filas",
                          label="Indique número de filas",
                          min=0,
                          max=100,
                          value=20),
              tableOutput("table"),
              downloadButton('downloadData',
                             'Descargar'))
  )
)

# Define server logic required to draw a histogram
server <- shinyServer(function(input, output) {})

# Run the application 
shinyApp(ui = ui, server = server)

