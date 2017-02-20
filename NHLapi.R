require(httr)
require(jsonlite)
require(tidyverse)

#OFFICIAL NHL STATS (TEAM) http://www.nhl.com/stats/rest/grouped/team/basic/season/teamsummary?cayenneExp=seasonId=20162017%20and%20gameTypeId=2&factCayenneExp=gamesPlayed%3E=1&sort=[{%22property%22:%22teamFullName%22,%22direction%22:%22DESC%22}]

#Get data from Puckalytics.com (Thanks!)
requestURL <- GET("http://puckalytics.com/php/getplayerdata2.php?season=201617&sit=all&minutes=50&info=1&goal=1&corsi=1&pcts=1&pctteam=1&individual=1&faceoffs=1&")
bin <- content(requestURL, "text")
dat <- fromJSON(bin)
vec <- c('First_Name', 'Last_Name', 'Team', 'Pos', 'TOI', 'TOIDec', 'GP', 'igoals', 'iassists', 'ipoints')
hockey <- dat %>%
select_(.dots = vec)

hockey$Team <- as.factor(hockey$Team)
hockey$Pos <- as.factor(hockey$Pos)
hockey$GP <- as.numeric(hockey$GP)
hockey$igoals <- as.numeric(hockey$igoals)
hockey$iassists <- as.numeric(hockey$iassists)
hockey$ipoints <- as.numeric(hockey$ipoints)

http://www.nhl.com/stats/rest/grouped/team/basic/season/goalsbystrength?cayenneExp=seasonId=20162017%20and%20gameTypeId=2&sort=[{%22property%22:%22goalsFor5on3%22,%22direction%22:%22DESC%22}]
http://www.nhl.com/stats/rest/grouped/team/basic/season/goalsbystrength?cayenneExp=seasonId=20162017%20and%20gameTypeId=2&sort=[{%22property%22:%22teamFullName%22,%22direction%22:%22ASC%22}]