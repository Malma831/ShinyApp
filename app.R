

ui <- fluidPage(
  titlePanel("Population in Linköping"),

    mainPanel(
    tabsetPanel(
      tabPanel("Plot",
        checkboxGroupInput(inputId = "Genders", label = "Select which gender to visualize: ", choices = c("Female" = "K", "Male" = "M", "Total" = "T")),
               plotOutput(outputId = "plot", width = '75%', height = "700px")),

      tabPanel("Tables", fluidRow(column(4, selectInput(inputId = "Year_var1", label="Select the first year", choices=1970:2020, width = '50%')),
                             column(4, offset = 4, selectInput(inputId = "Year_var2", label="Select the second year", choices=1970:2020, width = '50%')),
                fluidRow(column(4, tableOutput(outputId = "table1")), column(4, offset = 4, tableOutput(outputId = "table2"))

                )


    )
  )
)

)
)




server <- function(input, output){

  data <- reactive({
    lab5Rpackage::linkoping_pop()
  })
  Year1<-reactive({
    as.character(input$Year_var1)
  })

  txt_y1 <- renderText(as.character(input$Year_var1))

  output$table1<-renderTable({data()[,c("gender","value")][data()$Year == input$Year_var1,]},
                             caption.placement = "top", caption = "First year")



  output$table2<-renderTable(data()[,c("gender","value")][data()$Year == input$Year_var2,],
                             caption.placement = "top", caption = "Second year")

  output$plot <- renderPlot({
    ggplot2::ggplot(data()[data()$gender %in% input$Genders, ])+
      ggplot2::geom_line(ggplot2::aes(x=Year,y=value,color=gender))+ ggplot2::theme_bw()
    + ggplot2::ylab("Population Count") +
      ggplot2::labs(title = "Linkoping population by gender") + ggplot2::theme(plot.title = element_text(hjust = 0.5))
  })
}

shinyApp(ui = ui, server = server)

