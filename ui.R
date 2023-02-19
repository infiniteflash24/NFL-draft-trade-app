fluidPage(

    titlePanel("NFL Draft Trade Charts"), tags$style(type="text/css", ".recalculating {opacity: 1.0;}"),
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "NFL Season range",
                        min = min(summary_set$season),
                        max = max(summary_set$season),
                        value = c(2011, max(summary_set$season))
                        ),
            sliderInput("Pick_num",
                        "Pick number range",
                        min = min(summary_set$pick_number, na.rm = T),
                        max = max(summary_set$pick_number, na.rm = T),
                        value = c(min(summary_set$pick_number, na.rm = T), 
                                  32)
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
            # submitButton("Update plot\n", icon("refresh")),
            
            # selectInput("Trade_Metric", "Metric",
            #             choices = c('Difference', 'Ratio', 'Percentage_Gain'),
            #             selected = 'ratio',
            #             multiple = FALSE),
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
                        multiple = TRUE),
            
        ),

        mainPanel(
            
            plotOutput("distPlot", height = '800px')
        )
        
    )
)
