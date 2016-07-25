# ui.R

shinyUI(fluidPage(
        titlePanel("League of Legends: Champion Mastery"),
        
        sidebarLayout(
                sidebarPanel(
                        helpText("This code takes a minute or so to run after pressing search.
                                 This could be solved with time, which I do not have."),
                        br(),
                        
                        helpText("Please enter a summoner name below."),
                        
                        textInput("var", label = "Summoner:", "TheUnknownYordle"),
                        
                        submitButton(text = "Search"),
                        
                        br(),
                        
                        helpText("Search must be pressed again for sorting. It will take
                                 a minute to run again."),
                        
                        radioButtons("RadioB1",label = "Sort",choices = list(
                                "Points" = "Points",
                                "Champion name" = "Champion",
                                "Mastery Lvl" = "Mastery Lvl",
                                "Granted Chest" = "Granted Chest")
                                     ,selected = "Points")
                           ),
                
                mainPanel(
                        textOutput("text1"),
                        
                        tableOutput("data1")
                )
        )
))