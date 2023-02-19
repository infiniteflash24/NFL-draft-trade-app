fluidPage(
  tags$head(
    # Note the wrapping of the string in HTML()
    tags$style(HTML("
      @import url('https://fonts.googleapis.com/css2?family=Yusei+Magic&display=swap');
    
        
      body {
        background-color: black;
        color: orange;
      }
      h2 {
        font-family: 'Yusei Magic', sans-serif;
      }
      .shiny-input-container {
        color: #474747;
      }"))
  ),
  
    titlePanel("NFL Draft Trade Charts"), tags$style(type="text/css", ".recalculating {opacity: 1.0;}"),
    sidebarLayout(
        sidebarPanel(
            # style = "background-color: green;",
          
            chooseSliderSkin("Round"),
            tags$h2("Trade History"),
            br(),
            sliderInput("bins",
                        "Season",
                        min = min(summary_set$season),
                        max = max(summary_set$season),
                        value = c(2011, max(summary_set$season)),
                        # ticks = FALSE,
                        round = TRUE
                        ),
            sliderInput("Pick_num",
                        "Pick #",
                        min = min(summary_set$pick_number, na.rm = T),
                        max = max(summary_set$pick_number, na.rm = T),
                        value = c(min(summary_set$pick_number, na.rm = T), 
                                  32),
                        # ticks = FALSE,
                        round = TRUE
                        ),
            pickerInput("Gave","Team trading down", 
                        choices = summary_set$gave%>%unique()%>%sort(),
                        selected = summary_set$gave%>%unique(),
                        options = list(`actions-box` = TRUE),
                        multiple = T),
            pickerInput("Received","Team trading up", 
                        choices = summary_set$received%>%unique()%>%sort(),
                        selected = summary_set$received%>%unique(),
                        options = list(`actions-box` = TRUE),
                        multiple = T),
            br(),
            # submitButton("Update plot\n", icon("refresh")),
            
            # selectInput("Trade_Metric", "Metric",
            #             choices = c('Difference', 'Ratio', 'Percentage_Gain'),
            #             selected = 'ratio',
            #             multiple = FALSE),
            tags$h2("Trade Scenario"),
            
            br(),
            selectInput("Team_1", "Team 1",
                        choices = nfl_draft_order$Team%>%unique()%>%sort(),
                        selected = 'CHI',
                        multiple = FALSE),
            selectInput("Team_1_picks", "Team 1 picks",
                        choices = nfl_draft_order$Pick_Name%>%unique()%>%sort(),
                        selected = 'CHI 2023 1st (#1)',
                        multiple = TRUE),
            selectInput("Team_2", "Team 2",
                        choices = nfl_draft_order$Team%>%unique()%>%sort(),
                        selected = 'IND',
                        multiple = FALSE),
            selectInput("Team_2_picks", "Team 2 picks",
                        choices = nfl_draft_order$Pick_Name%>%unique()%>%sort(),
                        selected = c('IND 2023 1st (#4)', 'IND 2024 1st (#16)', 'IND 2023 2nd (#35)'),
                        multiple = TRUE)
            #, downloadButton('download',"Download table data")
            
        )
    ,

        mainPanel(
            plotOutput("distPlot", height = '700px', brush = 'plot_brush')
            ,
            tags$h2("Table"),
            tableOutput("data")
        )
        
    )
)
