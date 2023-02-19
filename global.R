setwd("~/NFL draft/NFL_draft_app")
library(shiny)
library(shinyWidgets)
library(tidyverse)
library(scales)
library(latex2exp)
library(sqldf)

# the only tables we need

summary_set <- read.csv('draft_trade_evals.csv')
nfl_draft_order <- read.csv('NFLdraftorder2023_values.csv')%>%
                   bind_rows(read.csv('NFLdraftorder2024_and_2025_values.csv'))%>%
                   mutate(Pick_Name = paste(Team, " ", Year, " ", ordinal(Round), " (#", Pick_number, ")", sep = ""))


# Run to create draft_trade_evals.csv
# 
draft_values <- read_csv("https://raw.githubusercontent.com/leesharpe/nfldata/master/data/draft_values.csv")
# draft_picks <- read_csv("https://raw.githubusercontent.com/leesharpe/nfldata/master/data/draft_picks.csv")
# trades <- read_csv("https://raw.githubusercontent.com/leesharpe/nfldata/master/data/trades.csv")
# draft_picks%>%
#   select(pfr_id, position)%>%
#   filter(!is.na(pfr_id), position == 'QB')%>%
#   unique() -> pfr_positions
# 
# trade_value_base <- trades%>%
#   group_by(trade_id)%>%
#   mutate(n = n(),
#          draft_picks = ifelse(any(is.na(pick_season)), 0, n()))%>%
#   ungroup()%>%
#   mutate(draft_pick_EV = ifelse(season != pick_season, (pick_round-1)*32+32, pick_number))%>%
#   filter(n == draft_picks)%>%
#   left_join(., draft_values, by = c("draft_pick_EV"="pick"))%>%
#   left_join(., pfr_positions, by = c("pfr_id"="pfr_id"))%>%
#   select(trade_id: pick_number, position, draft_pick_EV:pff)%>%
#   mutate(position = ifelse(position == 'QB', 'QB', 'non-QB'))
# 
# trade_value_all <- trade_value_base%>%
#   group_by(trade_id, gave, received)%>%
#   summarise(stuart = sum(stuart),
#             johnson = sum(johnson),
#             hill = sum(hill),
#             otc = sum(otc),
#             pff = sum(pff))%>%
#   gather(chart_type, amount, stuart:pff)
# 
# trade_value_base%>%
#   group_by(trade_id)%>%
#   filter(draft_pick_EV == min(draft_pick_EV))%>%
#   select(trade_id, season, trade_date, gave, received, pick_number) -> information
# 
# trade_value_base%>%
#   group_by(trade_id, gave, received)%>%
#   summarise(trade_results = paste(sort(pick_number), collapse = ', ')) -> picks
# 
# con <- DBI::dbConnect(RSQLite::SQLite(), dbname = "NFL_draft.sqlite")
# dbWriteTable(con,"trade_value_all", trade_value_all, overwrite = TRUE)
# dbWriteTable(con,"trade_value_base", trade_value_base, overwrite = TRUE)
# dbWriteTable(con,"information", information, overwrite = TRUE)
# dbWriteTable(con,"picks", picks, overwrite = TRUE)
# dbWriteTable(con,"draft_picks", draft_picks, overwrite = TRUE)
# 
# query = "select a.trade_id, a.gave, a.received, a.chart_type,
#          a.amount as amount_given,
#          b.amount as amount_received,
#          a.amount-b.amount as difference,
#          (a.amount-b.amount)/a.amount as given_percentage,
#          (a.amount-b.amount)/b.amount as received_percentage,
#          c.season, c.trade_date, c.pick_number,
#          case when f.position = 'QB' then 'QB'
#          else 'non-QB' end as position,
#          d.trade_results as given,
#          e.trade_results as offered,
#          f.pfr_name
#          from trade_value_all as a
#          left join trade_value_all as b on a.trade_id = b.trade_id and a.chart_type = b.chart_type and a.gave != b.gave
#          inner join information as c on a.trade_id = c.trade_id and a.gave = c.gave and a.received = c.received
#          inner join picks as d on a.trade_id = d.trade_id and a.gave = d.gave
#          inner join picks as e on a.trade_id = e.trade_id and a.gave = e.received
#          left join draft_picks as f on c.season = f.season and c.pick_number = f.pick
#          where b.amount > 0 and a.amount > 0
#          order by 1, a.chart_type
#         "
# summary_set <- sqldf(query)
# 
# write.csv(summary_set, 'draft_trade_evals.csv')

##Run below to create NFLdraftorder2024_and_2025_values.csv

# nfl_draft_order <- read.csv('NFLdraftorder2023.csv')
# nfl_draft_order%>%
# mutate(Round = ifelse(between(Pick_number, 1, 32), 1,
#                       ifelse(between(Pick_number, 33, 64), 2,
#                              ifelse(between(Pick_number, 65, 103), 3,
#                                     ifelse(between(Pick_number, 104, 137), 4,
#                                            ifelse(between(Pick_number, 138, 178), 5,
#                                                   ifelse(between(Pick_number, 179, 220), 6,
#                                                          7
#                                                   )
#                                            )
#                                     )
#                              )
#                       )
# )
#                              )%>%
# filter(Pick_number != 21)%>%
# mutate(Pick_number = row_number(), Year = 2023)%>%
# left_join(., draft_values, by = c("Pick_number"="pick"))%>%
# select(Pick_number, Team, Round, Year, stuart:pff)%>%
# write.csv(., "NFLdraftorder2023_values.csv", row.names = FALSE)
# 
# 
# teams = nfl_draft_order$Team%>%unique()
# pick_num = c(16, 16+32, 16+64, 16+96, 16+96+32, 16+96+64, 16+96+96)+16
# year = c(2024, 2025)
# expand.grid(teams, year, pick_num)%>%
# magrittr::set_colnames(c('Team', 'Year', 'Pick_number'))%>%
# left_join(., draft_values, by = c("Pick_number"="pick"))%>%
# left_join(., data.frame(pick_num= pick_num, Round = 1:7), by = c("Pick_number"="pick_num"))%>%
# write.csv(., "NFLdraftorder2024_and_2025_values.csv", row.names = FALSE)
# 
