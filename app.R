require(shiny)
require(ggplot2)
NHL <- read.delim("NHL.txt")
require(plotly)


# Define UI for application that draws a histogram
ui <- shinyUI(fluidPage(
    titlePanel("Most Efficient NHL Players 15-16"),
    fixedRow(width = 12,
      column(9, align = "center",
             tabsetPanel(
               tabPanel("Compare", plotlyOutput("plot5"),dataTableOutput("table2")),
               tabPanel("Center", plotlyOutput("plot1"),dataTableOutput("table3")),
               tabPanel("Left Wing", plotlyOutput("plot2")),
               tabPanel("Right Wing", plotlyOutput("plot3")),
               tabPanel("Defense", plotlyOutput("plot4"))
              )
            )
          )
        )
      )

server <- shinyServer(function(input, output) {
  
  LeftW <- NHL[which(NHL$Position == 'F(LW)'),]
  RightW <- NHL[which(NHL$Position == 'F(RW)'),]
  Center <- NHL[which(NHL$Position == 'F(C)'),]
  Defense <- NHL[which(NHL$Position == 'D'),]
  
  CenterPlot <- ggplot(data = Center, aes(x=Pts, y = TimePerGame)) + geom_point(aes(text = paste(Center$FirstLast,Center$Team,sep = ": ")), alpha = .5) + geom_smooth(aes(colour = "green", fill = "green" )) + facet_wrap(~ Position) + labs(x = "Points", y = "Time Per Game") + theme(plot.margin = unit(c(.5,.1,.5,.45), "in"),legend.position = "none", aspect.ratio = 1, legend.background = element_rect(color = 'black'), plot.background = element_rect(colour = "black", size = 1))
  LeftPlot <-ggplot(data = LeftW, aes(x=Pts, y = TimePerGame)) + geom_point(aes(text = paste(FirstLast,LeftW$Team,sep = ": ")), alpha = .5) + geom_smooth(aes(colour = Position, fill = Position)) + facet_wrap(~ Position) + labs(x = "Points", y = "Time Per Game") + theme(plot.margin = unit(c(.5,.1,.5,.45), "in"),legend.position = "none", aspect.ratio = 1, legend.background = element_rect(color = 'black'), plot.background = element_rect(colour = "black", size = 1))
  RightPlot <-ggplot(data = RightW, aes(x=Pts, y = TimePerGame)) + geom_point(aes(text = paste(FirstLast,RightW$Team,sep = ": ")), alpha = .5) + geom_smooth(aes(colour = Position, fill = Position)) + facet_wrap(~ Position) + labs(x = "Points", y = "Time Per Game") + theme(plot.margin = unit(c(.5,.1,.5,.45), "in"),legend.position = "none", aspect.ratio = 1, legend.background = element_rect(color = 'black'), plot.background = element_rect(colour = "black", size = 1))
  DefensePlot <-ggplot(data = Defense, aes(x=Pts, y = TimePerGame)) + geom_point(aes(text = paste(FirstLast,Defense$Team,sep = ": ")), alpha = .5) + geom_smooth(aes(colour = Position, fill = Position)) + facet_wrap(~ Position) + labs(x = "Points", y = "Time Per Game") + theme(plot.margin = unit(c(.5,.1,.5,.45), "in"),legend.position = "none", aspect.ratio = 1, legend.background = element_rect(color = 'black'), plot.background = element_rect(colour = "black", size = 1))
  TPG <-ggplot(data = NHL, aes(x=Pts, y = TimePerGame)) + geom_point(aes(text = paste(FirstLast,NHL$Team,sep = ": ")), alpha = .5) + geom_smooth(aes(colour = Position, fill = Position)) + facet_wrap(~ Position) + labs(x = "Points", y = "Time Per Game") + theme(plot.margin = unit(c(.5,.1,.5,.1), "in"), legend.position = "none",aspect.ratio = .75, legend.background = element_rect(color = 'black'), plot.background = element_rect(colour = "black", size = 1))
  
  output$plot1 <- renderPlotly({
     CenterPlot
   })
  output$plot2 <- renderPlotly({
    LeftPlot
  })
  output$plot3 <- renderPlotly({
    RightPlot
  })
  output$plot4 <- renderPlotly({
    DefensePlot
  })
  output$plot5 <- renderPlotly({
    TPG
  })
  output$table1 <- renderDataTable({
    NHL
  })
  output$table2 <- renderDataTable({
    NHL
  })
  output$table3 <- renderDataTable({
    Center
  })
})

shinyApp(ui = ui, server = server)

