function(input, output, session) {

  
  observe({
    updateSelectInput(session, "Team_1_picks", choices = nfl_draft_order%>%
                        filter(Team == input$Team_1,
                               future_pick %in% c('Not', input$Half_or_Full))%>%
                        .$Pick_Name%>%
                        sort()
    )
  })
  
  observe({
    updateSelectInput(session, 
                      "Team_2_picks", 
                      choices = nfl_draft_order%>%
                      filter(Team == input$Team_2,
                             future_pick %in% c('Not', input$Half_or_Full))%>%
                      .$Pick_Name%>%sort()
    )
  })
  

    output$distPlot <- renderPlot({

        nfl_draft_order%>%
        filter(Team %in% c(input$Team_1, input$Team_2), 
               future_pick %in% c('Not', input$Half_or_Full)
               )%>%
        # filter(Team %in% c('CHI', 'IND'))
        transmute(Pick_number, 
                  gave = Team, 
               received = ifelse(gave == input$Team_1, input$Team_2, input$Team_1),
               # received = ifelse(Team == 'CHI', 'IND', 'CHI'),
               Round, Year, stuart, johnson, hill, otc, pff, CBS, Pick_Name)%>%
        filter(Pick_Name %in% c(input$Team_1_picks, input$Team_2_picks))%>%
        mutate(trade_id = 40000)%>%
        group_by(trade_id, gave, received)%>%
        summarise(stuart = sum(stuart),
                 johnson = sum(johnson),
                 hill = sum(hill),
                 otc = sum(otc),
                 pff = sum(pff),
                 cbs = sum(CBS),
                 min_pick_ev = min(Pick_number),
                 trade_results = paste(sort(Pick_Name), collapse = ', '))%>%
        ungroup()%>%
        gather(chart_type, amount, stuart:cbs)%>%
        left_join(., ., by = c("gave"="received", 
                                     "chart_type" = "chart_type"))%>%
        transmute(trade_id = trade_id.x,
                  gave, 
                  received,
                  pick_number = min_pick_ev.x,
                  chart_type, 
                  amount_given = amount.x,
                  amount_received = amount.y,
                  given = trade_results.x,
                  offered = trade_results.y)%>%
        group_by(chart_type)%>%
        filter(pick_number == min(pick_number))%>%
        mutate(difference = amount_given-amount_received,
               given_percentage = (amount_given-amount_received)/amount_given,
               received_percentage = (amount_received-amount_given)/amount_received,
               season = format(Sys.Date(), "%Y")%>%as.numeric(),
               trade_date = '2023-04-01',
               position = 'Suggested trade',
               pfr_name = 'Suggested trade'
               )%>%
        ungroup() -> suggested_trade
        
        summary_set%>%
        filter(amount_received > 0, 
               amount_given > 0,
               between(pick_number, input$Pick_num[1], input$Pick_num[2]),
               # between(pick_number, 1, 32),
               between(season, input$bins[1], input$bins[2]),
               # between(season, 2011, 2022),
               gave %in% input$Gave,
               received %in% input$Received,
               future_pick %in% c('Not', input$Half_or_Full)
               )%>%
        bind_rows(suggested_trade)%>%
        mutate(Difference = -difference,
               Percentage_gain = -given_percentage,
               Ratio = amount_received/amount_given
               # ,
               # position = ifelse(trade_id == 1648, 'Jameson Williams trade', position)
               )%>%
        mutate(chart_type = tools::toTitleCase(chart_type))%>%
        ggplot(aes(x = pick_number, 
                   # y = aes_string(input$Trade_Metric)
                   y = Ratio
                   )
               )+
        geom_point(size = 3.5, aes(color = position, shape = position))+
        # geom_point(data = suggested_trade, aes(x = pick_number ,y = difference, color = 'blue'))+
        geom_vline(xintercept = 1)+
        geom_hline(yintercept = 1)+
        # geom_hline(yintercept = 0)+
        geom_smooth(se= FALSE, color = 'black')+
        # theme_bw()+
        theme_wsj()+
        facet_wrap(. ~ chart_type, 
                   scale = 'free')+
        labs(x = '\nPick #', 
             y= 'Expected % received\n')+
        # xlab(TeX('$Pick\.number$'))+
        # ylab(TeX('$E(Additional amount received in return)$'))+
        ggtitle('\nPick # vs Draft value received\n\n')+
        theme(legend.position = c(0.7, 1.25), 
              legend.background = element_rect(fill = "white", colour = NA),
              legend.title = element_blank(),
              text = element_text(size=20),
              axis.title=element_text(size=30),
              strip.text = element_text(size = 20),
              plot.title = element_text(color="#993333", size=30, face="bold"),
              axis.title.x = element_text(color="#993333", size=30, face="bold"),
              axis.title.y = element_text(color="#993333", size=30, face="bold")
              )+
        scale_y_continuous(labels = scales::percent)
    })
    
    output$data <- renderTable({
      
      nfl_draft_order%>%
        filter(Team %in% c(input$Team_1, input$Team_2), 
               future_pick %in% c('Not', input$Half_or_Full)
              )%>%
        # filter(Team %in% c('CHI', 'IND'))
        transmute(Pick_number, 
                  gave = Team, 
                  received = ifelse(gave == input$Team_1, input$Team_2, input$Team_1),
                  # received = ifelse(Team == 'CHI', 'IND', 'CHI'),
                  Round, Year, stuart, johnson, hill, otc, pff, CBS, Pick_Name)%>%
        filter(Pick_Name %in% c(input$Team_1_picks, input$Team_2_picks))%>%
        mutate(trade_id = 40000)%>%
        group_by(trade_id, gave, received)%>%
        summarise(stuart = sum(stuart),
                  johnson = sum(johnson),
                  hill = sum(hill),
                  otc = sum(otc),
                  pff = sum(pff),
                  cbs = sum(CBS),
                  min_pick_ev = min(Pick_number),
                  trade_results = paste(sort(Pick_Name), collapse = ', '))%>%
        ungroup()%>%
        gather(chart_type, amount, stuart:cbs)%>%
        left_join(., ., by = c("gave"="received", 
                               "chart_type" = "chart_type"))%>%
        transmute(trade_id = trade_id.x,
                  gave, 
                  received,
                  pick_number = min_pick_ev.x,
                  chart_type, 
                  amount_given = amount.x,
                  amount_received = amount.y,
                  given = trade_results.x,
                  offered = trade_results.y)%>%
        group_by(chart_type)%>%
        filter(pick_number == min(pick_number))%>%
        mutate(difference = amount_given-amount_received,
               given_percentage = (amount_given-amount_received)/amount_given,
               received_percentage = (amount_received-amount_given)/amount_received,
               season = format(Sys.Date(), "%Y")%>%as.numeric(),
               trade_date = '2023-04-01',
               position = 'Suggested trade',
               pfr_name = 'Suggested trade'
        )%>%
        ungroup() -> suggested_trade
      
      summary_set%>%
        filter(amount_received > 0, 
               amount_given > 0,
               between(pick_number, input$Pick_num[1], input$Pick_num[2]),
               # between(pick_number, 1, 32),
               between(season, input$bins[1], input$bins[2]),
               # between(season, 2011, 2022),
               gave %in% input$Gave,
               received %in% input$Received,
               future_pick %in% c('Not', input$Half_or_Full)
        )%>%
        bind_rows(suggested_trade)%>%
        mutate(Difference = -difference,
               Percentage_gain = -given_percentage,
               Ratio = amount_received/amount_given
               # ,
               # position = ifelse(trade_id == 1648, 'Jameson Williams trade', position)
        )%>%
        mutate(chart_type = tools::toTitleCase(chart_type))%>%
        # select(trade_id:amount_received, ratio, season:pfr_name)%>%
        brushedPoints(., input$plot_brush, xvar = "pick_number", yvar = "Ratio")
    })
    
    # output$download <- downloadHandler(
    #   
    #   filename = function(){"table.csv"}, 
    #   content = function(fname){
    #     write.csv(thedata(), fname)
    #   }
    # )

}
