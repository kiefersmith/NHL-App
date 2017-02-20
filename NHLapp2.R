require(shiny)
require(ggplot2)
require(plotly)
require(httr)

NHL2 <- read.delim("NHL2.txt")


Twitter <- tags$a(href="https://twitter.com/realest8agent", "Twitter")
Email <- tags$a(href="mailto:kieferjsmith7@gmail.com", "Email")

ui <- shinyUI(fluidPage(
    titlePanel("Season 16-17"),
        fluidRow(width = 12,
                 column(12, align = "center",
                        tabsetPanel(
                          tabPanel("Compare", plotlyOutput("plot5", width = "75%", height = "100%"), Twitter, Email),
                          tabPanel("Center", plotlyOutput("plot1",width = "75%", height = "100%")),
                          tabPanel("Left Wing", plotlyOutput("plot2",width = "75%", height = "100%")),
                          tabPanel("Right Wing", plotlyOutput("plot3",width = "75%", height = "100%")),
                          tabPanel("Defense", plotlyOutput("plot4",width = "75%", height = "100%")
              )
            )
          )
        )
      )
    )

server <- shinyServer(function(input, output) {
  
  LeftW <- dat[which(dat$Pos == 'L'),]
  RightW <- dat[which(dat$Pos == 'R'),]
  Center <- dat[which(dat$Pos == 'C'),]
  Defense <- dat[which(dat$Pos == 'D'),]
  
  CenterPlot <- ggplot(data = Center, aes(x=GF, y = TOIDec)) + geom_point(aes(text = paste(Center$Player_Name,Center$Team,sep = ": ")), alpha = .5) + geom_smooth(color = "#7CAE00", fill = "#7CAE00") + facet_wrap(~ Pos) + labs(x = "Points", y = "Time Per Game") + theme(plot.margin = unit(c(.1,.1,.5,.45), "in"),legend.position = "none", aspect.ratio = 1, legend.background = element_rect(color = 'black'), plot.background = element_rect(colour = "black", size = 1))
  LeftPlot <-ggplot(data = LeftW, aes(x=GF, y = TOIDec)) + geom_point(aes(text = paste(Player_Name,LeftW$Team,sep = ": ")), alpha = .5) + geom_smooth(colour = "#00BFC4", fill = "#00BFC4") + facet_wrap(~ Pos) + labs(x = "Points", y = "Time Per Game") + theme(plot.margin = unit(c(.1,.1,.5,.45), "in"),legend.position = "none", aspect.ratio = 1, legend.background = element_rect(color = 'black'), plot.background = element_rect(colour = "black", size = 1))
  RightPlot <-ggplot(data = RightW, aes(x=GF, y = TOIDec)) + geom_point(aes(text = paste(Player_Name,RightW$Team,sep = ": ")), alpha = .5) + geom_smooth(colour = "#C77CFF", fill = "#C77CFF") + facet_wrap(~ Pos) + labs(x = "Points", y = "Time Per Game") + theme(plot.margin = unit(c(.1,.1,.5,.45), "in"),legend.position = "none", aspect.ratio = 1, legend.background = element_rect(color = 'black'), plot.background = element_rect(colour = "black", size = 1))
  DefensePlot <-ggplot(data = Defense, aes(x=GF, y = TOIDec)) + geom_point(aes(text = paste(Player_Name,Defense$Team,sep = ": ")), alpha = .5) + geom_smooth(colour = "#F8766D", fill = "#F8766D") + facet_wrap(~ Pos) + labs(x = "Points", y = "Time Per Game") + theme(plot.margin = unit(c(.1,.1,.5,.45), "in"),legend.position = "none", aspect.ratio = 1, legend.background = element_rect(color = 'black'), plot.background = element_rect(colour = "black", size = 1))
  TPG <-ggplot(data = dat, aes(x=GF, y = TOIDec)) + geom_point(aes(text = paste(Player_Name, Team,sep = ": ")), alpha = .5) + geom_smooth(aes(colour = Pos, fill = Pos)) + facet_wrap(~ Pos) + labs(x = "Points", y = "Time Per Game") + theme(plot.margin = unit(c(.1,.1,.5,.5), "in"), legend.position = "none",aspect.ratio = .75, legend.background = element_rect(color = 'black'), plot.background = element_rect(colour = "black", size = 1))
  
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
})

shinyApp(ui = ui, server = server)

