setwd("~/NFL draft/NFL_draft_app")
library(shiny)
library(shinyWidgets)
library(tidyverse)
library(scales)
library(latex2exp)

# see draft_trade_evals.csv created in NFL_draft.rmd file

summary_set <- read.csv('draft_trade_evals.csv')
nfl_draft_order <- read.csv('NFLdraftorder2023_values.csv')%>%
                   bind_rows(read.csv('NFLdraftorder2024_and_2025_values.csv'))%>%
                   mutate(Pick_Name = paste(Team, " ", Year, " ", ordinal(Round), " (#", Pick_number, ")", sep = ""))
# draft_values <- read_csv("https://raw.githubusercontent.com/leesharpe/nfldata/master/data/draft_values.csv")
# draft_picks <- read_csv("https://raw.githubusercontent.com/leesharpe/nfldata/master/data/draft_picks.csv")

##Run below only if you haven't created the files above

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
# pick_num = c(16, 16+32, 16+64, 16+96, 16+96+32, 16+96+64, 16+96+96)
# year = c(2024, 2025)
# expand.grid(teams, year, pick_num)%>%
# magrittr::set_colnames(c('Team', 'Year', 'Pick_number'))%>%
# left_join(., draft_values, by = c("Pick_number"="pick"))%>%
# left_join(., data.frame(pick_num= pick_num, Round = 1:7), by = c("Pick_number"="pick_num"))%>%
# write.csv(., "NFLdraftorder2024_and_2025_values.csv", row.names = FALSE)

