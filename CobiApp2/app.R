################################################################################################################
# ESPAÑOL
# COBIApp - 
#
# EL CÓDIGO
# El código que permite que la aplicación se desarrolle está escrito en R. El paquete `shiny` permite escribir
# en lenguaje común de R y transforma lo que diseñamos en lenguaje html. El código se compone de 3 partes
# principales: ui, server y shinyApp. En ui se diseña la "user interface". Aquí solamente entran en juego bloques
# de programación que dan la apariencia a la aplicación y crean los diversos campos de entrada y salida. Esta
# sección solamente genera el ambiente de trabajo que ve el usuario. server es la sección del código que hace
# los cálculos, manipulaciones y procesos necesarios. En este caso, la transformación de formatos se lleva a
# a cabo en esta sección. Finalmente, la sección de shinyApp "conecta" al ambiente de trabajo con los procesos
# que debe realizar. El código se comenta en inglés.
#
# LA APLICACIÓN
# 
#
# CRÉDITOS
# Desarrollada y mantenida por Juan Carlos Villaseñor Derbez (jvillasenor@bren.ucsb.edu)
#
# LICENCIA
# Licencia tipo MIT (https://github.com/turfeffect/COBIApp2/blob/master/LICENSE)
# 
# 
# ENGLISH
# COBIApp - 
# 
# CODE
# This code is writen in R. The package `shiny` allows you to write in simple R languaje and then transforms it
# to html code. The code is made up by three main parts: ui, server, and shinyApp. ui is where we design the user
# interface. Here we just provide the building blocks that give the appearance to our app by creating the input
# and output fields.This section only generates the workplace that the user sees. server is the section of code
# that makes the calculations, manipulations, and processes. In this case, the transformation of formates takes
# place in this section. Finaly, the shinyApp section connects the user interface and the processes (ui and
# server).
# 
# THIS APP
# 
# CREDITS
# Developed and maintained by: Juan Carlos Villaseñor Derbez (jvillasenor@bren.ucsb.edu)
# 
# LICENSE
# Licensed under MIT (https://github.com/turfeffect/COBIApp2/blob/master/LICENSE)
#
################################################################################################################

library(shiny)
library(tidyr)
library(dplyr)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  theme = "cerulean.css",
  # Application title
  titlePanel("COBIApp2 - Completar datos de monitoreo con listas de especies"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(img(src="cobi.jpg", width="60px"),
                 img(src="turf.jpg", width="60px"),
                 h2("Lista de especies"),
                 fileInput(inputId ="list",
                           label = "Seleccionar archivo",
                           accept = ".csv"),
                 selectInput(inputId='sepinl',
                             label='Separador',
                             choices=c("Coma"=',',
                                       "Punto y coma"=';',
                                       "Tabulación"='\t',
                                       "Espacio"=" "),
                             selected = ','),
                 
                 h2("Base de datos"),
                 fileInput(inputId ="dataset",
                           label = "Seleccionar archivo",
                           accept = ".csv"),
                 selectInput(inputId='sepind',
                             label='Separador',
                             choices=c("Coma"=',',
                                       "Punto y coma"=';',
                                       "Tabulación"='\t',
                                       "Espacio"=" "),
                             selected = ','),
                 
                 selectInput(inputId = "completer",
                             label = "Completar abundancias por:",
                             choices = c("Región" = "R",
                                         "Localidad" = "L"),
                             selected = "R"),
                 h2("Ejemplos de Formatos"),
                 downloadButton('downloadA',
                                'Lista'),
                 downloadButton('downloadB',
                                'Base'),
                 p("Si requiere convertir los datos al formato específico, puede usar la siguiente aplicación:"),
                 a("COBIApp", href="https://jcvd.shinyapps.io/COBIApp/", target="_blank"),
                 p(),
                 a("Ver el manual", href="http://jcvdav.github.io/COBIApp_Manual.pdf", target="_blank"),
                 p(),
                 p("Juan Carlos Villaseñor-Derbez:"),
                 a("jvillasenor@bren.ucsb.edu", href="jvillasenor@bren.ucsb.edu", target="_blank"),
                 p(),
                 a("Licensed under MIT", href="https://github.com/turfeffect/COBIApp/blob/master/LICENSE", target="_blank")
    ),
    
    # Show a preview of the table
    mainPanel(h2("Vista Previa de Datos de Salida"),                                        
              textOutput(outputId = "texto1"),
              tableOutput("table"),
              downloadButton('downloadData',
                             'Descargar'))
  )
)

# Define server
server <- shinyServer(function(input, output) {
  
  if (input$completer == "R"){
    # Completar por región
    
    listInput <- reactive({
      inFile <- input$list
      if (is.null(inFile)){
        return(NULL)}
      
      list <- read.csv(inFile$datapath, sep = input$sepinl) %>%
        select(Region = Región, GeneroEspecie = Genero...Especie) %>%
        mutate(Dia = NA, #Set proper column names to avoid weird characters
               Mes = NA,
               Ano = NA,
               Estado = NA,
               Comunidad = NA,
               Sitio = NA,
               Latitud = NA,
               Longitud = NA,
               Habitat = NA,
               Zonificacion = NA,
               TipoDeProteccion = NA,
               ANP = NA,
               BuzoMonitor = NA,
               HoraInicialBuceo = NA,
               HoraFinalBuceo = NA,
               ProfundidadInicial_m = NA,
               ProfundidadFinal_m = NA,
               Temperatura_C = NA,
               Visibilidad_m = NA,
               Corriente = NA,
               Transecto = 9999,
               Genero = NA,
               Especie = NA,
               Sexo = NA,
               Talla = NA,
               PromedioDeTalla = NA,
               Abundancia = 0) %>%
        select(Dia, #Set proper column names to avoid weird characters
               Mes,
               Ano,
               Estado,
               Comunidad,
               Sitio,
               Latitud,
               Longitud,
               Habitat,
               Zonificacion,
               TipoDeProteccion,
               ANP,
               BuzoMonitor,
               HoraInicialBuceo,
               HoraFinalBuceo,
               ProfundidadInicial_m,
               ProfundidadFinal_m,
               Temperatura_C,
               Visibilidad_m,
               Corriente,
               Transecto,
               Genero,
               Especie,
               GeneroEspecie,
               Sexo,
               Talla,
               PromedioDeTalla,
               Abundancia) %>%
        mutate(Id=paste(Dia, Mes, Ano, Estado, Comunidad, Sitio, Latitud, Longitud, sep="-")) %>%
        select(Id, GeneroEspecie, Talla, PromedioDeTalla, Abundancia)
    })
    
    datasetInput=reactive({
      inFile <- input$dataset
      if (is.null(inFile))
        return(NULL)
      dataset <- read.csv(inFile$datapath, sep = input$sepind)
      colnames(dataset) <- c('Dia', #Set proper column names to avoid weird characters
                             'Mes',
                             'Ano',
                             'Estado',
                             'Comunidad',
                             'Sitio',
                             'Latitud',
                             'Longitud',
                             'Habitat',
                             'Zonificacion',
                             'TipoDeProteccion',
                             'ANP',
                             'BuzoMonitor',
                             'HoraInicialBuceo',
                             'HoraFinalBuceo',
                             'ProfundidadInicial_m',
                             'ProfundidadFinal_m',
                             'Temperatura_C',
                             'Visibilidad_m',
                             'Corriente',
                             'Transecto',
                             'Genero',
                             'Especie',
                             'GeneroEspecie',
                             'Sexo',
                             'Talla',
                             'PromedioDeTalla',
                             'Abundancia')
      dataset <- dataset %>%
        mutate(Id=paste(Dia, Mes, Ano, Estado, Comunidad, Sitio, Latitud, Longitud, sep="-"))
      
      dataset2 <- dataset %>%
        select(Id, GeneroEspecie, Talla, PromedioDeTalla, Abundancia) %>%
        rbind(list) %>%
        complete(Id, GeneroEspecie, fill = list(Abundancia = 0)) %>%
        left_join(dataset, by="Id") %>%
        filter(!Transecto == 999) %>%
        select(-c(1:5))
      
      colnames(dataset2) <- c('Dia', #Set proper column names to avoid weird characters
                              'Mes',
                              'Ano',
                              'Estado',
                              'Comunidad',
                              'Sitio',
                              'Latitud',
                              'Longitud',
                              'Habitat',
                              'Zonificacion',
                              'TipoDeProteccion',
                              'ANP',
                              'BuzoMonitor',
                              'HoraInicialBuceo',
                              'HoraFinalBuceo',
                              'ProfundidadInicial_m',
                              'ProfundidadFinal_m',
                              'Temperatura_C',
                              'Visibilidad_m',
                              'Corriente',
                              'Transecto',
                              'Genero',
                              'Especie',
                              'GeneroEspecie',
                              'Sexo',
                              'Talla',
                              'PromedioDeTalla',
                              'Abundancia')
      
    })
    
  }
  
  if (input$completer == "L"){
    # Completar por localidad
    
    listInput=reactive({
      inFile <- input$list
      if (is.null(inFile))
        return(NULL)
      list=read.csv(inFile$datapath, sep = input$sepinl)
    })
    
    datasetInput=reactive({
      inFile <- input$dataset
      if (is.null(inFile))
        return(NULL)
      dataset=read.csv(inFile$datapath, sep = input$sepind)
    })
    
  }
  
  
  output$texto1 <- renderText(exp="Se muestran las primeras 25 filas del documento")
  
  output$table <- renderTable({
    head(datasetInput(), 25)
  })
  
  output$downloadData <- downloadHandler(
    filename = function(){paste(input$dataset)},
    content = function(file) {
      write.csv(datasetInput(), file, row.names=F)
    }
  )
  
})

# Run the application 
shinyApp(ui = ui, server = server)

