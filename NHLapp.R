require(shiny)
require(ggplot2)
NHL2 <- read.delim("NHL2.txt")
require(plotly)

Twitter <- tags$a(href="https://twitter.com/realest8agent", "Twitter")
Email <- tags$a(href="mailto:kieferjsmith7@gmail.com", "Email")

ui <- shinyUI(fluidPage(
    titlePanel("NHL Players 15-16: Time on Ice vs. Points"),
        fluidRow(width = 12,
                 column(12, align = "center",
                        tabsetPanel(
                          tabPanel("Compare", plotlyOutput("plot5", width = "75%", height = "100%"), textOutput("text1"), Twitter, Email),
                          tabPanel("Center", plotlyOutput("plot1",width = "75%", height = "100%"),textOutput("text2")),
                          tabPanel("Left Wing", plotlyOutput("plot2",width = "75%", height = "100%"),textOutput("text5")),
                          tabPanel("Right Wing", plotlyOutput("plot3",width = "75%", height = "100%"),textOutput("text4")),
                          tabPanel("Defense", plotlyOutput("plot4",width = "75%", height = "100%"),textOutput("text3"))
              )
            )
          )
        )
      )

server <- shinyServer(function(input, output) {
  
  LeftW <- NHL2[which(NHL2$Pos== 'F(LW)'),]
  RightW <- NHL2[which(NHL2$Pos == 'F(RW)'),]
  Center <- NHL2[which(NHL2$Pos == 'F(C)'),]
  Defense <- NHL2[which(NHL2$Pos == 'D'),]
  
  CenterPlot <- ggplot(data = Center, aes(x=Pts, y = TimePerGame)) + geom_point(aes(text = paste(Center$FirstLast,Center$Team,sep = ": ")), alpha = .5) + geom_smooth(color = "#7CAE00", fill = "#7CAE00") + facet_wrap(~ Pos) + labs(x = "Points", y = "Time Per Game") + theme(plot.margin = unit(c(.1,.1,.5,.45), "in"),legend.position = "none", aspect.ratio = 1, legend.background = element_rect(color = 'black'), plot.background = element_rect(colour = "black", size = 1))
  LeftPlot <-ggplot(data = LeftW, aes(x=Pts, y = TimePerGame)) + geom_point(aes(text = paste(FirstLast,LeftW$Team,sep = ": ")), alpha = .5) + geom_smooth(colour = "#00BFC4", fill = "#00BFC4") + facet_wrap(~ Pos) + labs(x = "Points", y = "Time Per Game") + theme(plot.margin = unit(c(.1,.1,.5,.45), "in"),legend.position = "none", aspect.ratio = 1, legend.background = element_rect(color = 'black'), plot.background = element_rect(colour = "black", size = 1))
  RightPlot <-ggplot(data = RightW, aes(x=Pts, y = TimePerGame)) + geom_point(aes(text = paste(FirstLast,RightW$Team,sep = ": ")), alpha = .5) + geom_smooth(colour = "#C77CFF", fill = "#C77CFF") + facet_wrap(~ Pos) + labs(x = "Points", y = "Time Per Game") + theme(plot.margin = unit(c(.1,.1,.5,.45), "in"),legend.position = "none", aspect.ratio = 1, legend.background = element_rect(color = 'black'), plot.background = element_rect(colour = "black", size = 1))
  DefensePlot <-ggplot(data = Defense, aes(x=Pts, y = TimePerGame)) + geom_point(aes(text = paste(FirstLast,Defense$Team,sep = ": ")), alpha = .5) + geom_smooth(colour = "#F8766D", fill = "#F8766D") + facet_wrap(~ Pos) + labs(x = "Points", y = "Time Per Game") + theme(plot.margin = unit(c(.1,.1,.5,.45), "in"),legend.position = "none", aspect.ratio = 1, legend.background = element_rect(color = 'black'), plot.background = element_rect(colour = "black", size = 1))
  TPG <-ggplot(data = NHL2, aes(x=Pts, y = TimePerGame)) + geom_point(aes(text = paste(FirstLast, Team,sep = ": ")), alpha = .5) + geom_smooth(aes(colour = Pos, fill = Pos)) + facet_wrap(~ Pos) + labs(x = "Points", y = "Time Per Game") + theme(plot.margin = unit(c(.1,.1,.5,.5), "in"), legend.position = "none",aspect.ratio = .75, legend.background = element_rect(color = 'black'), plot.background = element_rect(colour = "black", size = 1))
  
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
  output$text1 <- renderText({
    "This graph compares the data from 678 National Hockey League players during the 2015-2016 season.  Obviously, more time on the ice (dislpayed on the Y-axis) should, in theory, yeild more points (shown on the X-axis) for any given player.
    An interesting result from this visualization is the vague similarity of the graphs to that of a poverty trap.  In short, this means that netting more points affects a player's playtime
    to a greater degree than that of someone who scores more.  The change in slope may be due to constraints on how much a player is physically able to play per game, and the effect does not take into account a player's performance in context.
    Players under the fitted lines were more efficient (points-wise) with their time than those on or above the lines."
    })
  output$text2 <- renderText({
    "No surprise that Sidney Crosby leads the Centers in playtime and points.  I hope The Penguins are getting their $12 million worth!  Kuznetsov should negotiate a raise - last year he earned 2.2 mil."
  })
  output$text3 <- renderText({
    "Defenseman play more and score less than other positions (note heavy skewness to the right).  The median amount of time a Defensive player played was 15.3, about 4 minutes more than the median Left Winger.  Excluding Erik Karlsson changes the mean points earned for the other 239 Defenseman by .19, a change of 1%."
  })
  output$text4 <- renderText({
    "It's lonely at the top: Kane, Jagr, Wheeler, and Tarasenko account for 10% of points scored by Right Wingers."
  })
  output$text5 <- renderText({
    "Being on the Left Wing seems to be the toughest job among the forwards - they score less on average and have a lower point ceiling. "
  })
})

shinyApp(ui = ui, server = server)

