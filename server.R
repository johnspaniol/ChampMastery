# server.R


shinyServer(
        function(input, output) {
                
                output$text1 <- renderText({ 
                        paste("Hello, ", input$var, "!")
                })
                
                GetSummID <- function(SName)
                        
                {
                        suppressWarnings(library("stringr"))
                        
                        SummName <- str_replace(SName,pattern = " ",replacement = "%20")
                        
                        RiotURLStart <- "https://na.api.pvp.net/api/lol/na/v1.4/summoner/by-name/" 
                        RiotURLEnd <- "?api_key=e6774a60-1df0-43b6-9ff6-f0ff41378447"
                        RiotURLCombine <- paste(RiotURLStart,SummName,RiotURLEnd,sep = "")
                        
                        SummInfo <- jsonlite::fromJSON(RiotURLCombine)
                        
                        SummInfo2 <- unlist(SummInfo[[1]][1])
                        
                        SummonerID <- SummInfo2[[1]][1]
                        
                        return(SummonerID)
                }
                
                GetChampName <- function(ChampID)
                        
                {  
                        RiotURLStart2 <- "https://global.api.pvp.net/api/lol/static-data/na/v1.2/champion/" 
                        RiotURLEnd2 <- "?champData=info&api_key=e6774a60-1df0-43b6-9ff6-f0ff41378447"
                        RiotURLCombine2 <- paste(RiotURLStart2,ChampID,RiotURLEnd2,sep = "")
                        
                        ChampName <- jsonlite::fromJSON(RiotURLCombine2)
                        
                        return(ChampName$name)
                }
                
                CurrentSumm <- function(summname)
                {
                        require(curl)
                        require(plyr)
                        
                        SummonerID <- GetSummID(summname)
                        
                        RiotURLStart2 <- "https://na.api.pvp.net/championmastery/location/NA1/player/"
                        RiotURLEnd2 <- "/champions?api_key=e6774a60-1df0-43b6-9ff6-f0ff41378447"
                        RiotURLCombine2 <- paste(RiotURLStart2,SummonerID,RiotURLEnd2,sep = "")
                        
                        CurrentSummoner <- jsonlite::fromJSON(RiotURLCombine2)
                        
                        CurrentSummoner$championId <- sapply(X = CurrentSummoner$championId,GetChampName)
                        
                        CurrentSummoner$playerId <- NULL
                        
                        CurrentSummoner$championPointsSinceLastLevel <- NULL
                        
                        CurrentSummoner$lastPlayTime <- NULL 
                                #tried to add this but errored out in shiny only. Works fine in r-studio.
                                #opted to just remove due to short timeframe
                                #as.POSIXct(x = CurrentSummoner$lastPlayTime/1000,origin = "1970-01-01")
                        
                        colnames(CurrentSummoner) <- c("Champion","Mastery Lvl","Points","Points to Next Lvl","Granted Chest","Tokens")
                        
                        CurrentSummoner <- CurrentSummoner[ order(CurrentSummoner[input$RadioB1]
                                                                  , decreasing = (if(input$RadioB1 %in% "Points") {TRUE} else {FALSE})), ]
                        
                        return (CurrentSummoner)
                }
                
                
                datasumm <- reactive({CurrentSumm(input$var)})
                
                output$data1 <- renderTable(datasumm())
        
        }
)