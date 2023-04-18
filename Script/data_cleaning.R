#### Preamble ####
# Purpose: Prepare and clean the matches data from https://oracleselixir.com/tools/downloads, selecting the 2020 Match Data.
# Author: Zhendong Zhang
# Data: December 15th 2020
# Contact:zhendong.zhang@mail.utoronto.ca
# Pre-requisites: 
# - Need to have downloaded the 2020 Match Data from https://oracleselixir.com/tools/downloads save to project/Input/ 


library(readr)
library(tidyverse)

raw_data <- read_csv("./Input/2020_LoL_esports_match_data_from_OraclesElixir_20201203.csv")

data <- raw_data %>%
  filter(league == "LCK" | league == "WCS")
# I want to focus only league "LCK" and "WCS" (World Championship)

local <- data %>%
  filter(league == "LCK")

world <- data %>%
  filter(league == "WCS")
# This would divide the local league and the world championship

world <- world %>%
  filter(world$date > as.Date("2020-09-24"))
# The championship starts at 2020-09-25

winrate <- local %>%
  group_by(team) %>%
  summarise(win_rate = sum(result)/length(result))

winratewld <- world %>%
  group_by(team) %>%
  summarise(win_rate = sum(result)/length(result))
# Calculating winrate for each team in respect to LCK and WCS

local <- local %>%
  left_join(winrate, by = "team")

world <- world %>%
  left_join(winratewld, by = "team")

local <- local %>%
  rename(localwinrate = win_rate)

world <- world %>%
  rename(worldwinrate = win_rate)
# Add winrate varaible into datasets

winslocal <- local %>%
  filter(position == "team") %>%
  group_by(team) %>%
  summarise(local_total_wins = sum(result))

winsworld <- world %>%
  filter(position == "team") %>%
  group_by(team) %>%
  summarise(world_total_wins = sum(result))

local <- local %>%
  left_join(winslocal, by = "team")

world <- world %>%
  left_join(winsworld, by = "team")
# Add total number of matchs won for each team

local <- local %>%
  filter(datacompleteness == "complete")

lck <- local %>%
  select(league, local_total_wins, date,
         position, team, kills, 
         deaths, assists, vspm, 
         golddiffat15, cspm, dragons, 
         opp_dragons, firstherald, barons, 
         `team kpm`, localwinrate, 
         damagetakenperminute, dpm, xpdiffat15, firsttower, damageshare)

wcs <- world %>%
  select(league, world_total_wins, date,
         position, team, kills, deaths, 
         assists, vspm, golddiffat15, cspm, 
         dragons, opp_dragons, firstherald, 
         barons, `team kpm`, worldwinrate, 
         damagetakenperminute, dpm, xpdiffat15, firsttower, damageshare)
# Selecting the needed variables


# LCK data processing Part

## Player level
lckplayer <- lck %>%
  filter(position != "team") 

lckplayer <- lckplayer %>%
  group_by(date, team) %>%
  summarise(total_wins = unique(local_total_wins), 
            localwinrate = round(unique(localwinrate), 3),
            KDA = round((sum(kills) + sum(assists))/sum(deaths), 3), 
            vspm = round(mean(vspm), 3), 
            cspm = round(mean(cspm), 3),
            dms = round(mean(damageshare), 3))
# Processing each variable

## Team level
lckteam <- lck %>%
  filter(position == "team")

lckteam <- lckteam %>%
  group_by(date, team) %>%
  summarise(league = unique(league),
            team_dragons_adv = round(mean(dragons) - mean(opp_dragons), 3),
            firstheraldrate = round(mean(firstherald), 3),
            barons = round(barons, 3),
            team_kpm = round(mean(`team kpm`), 3),
            dtpm = round(mean(damagetakenperminute), 3),
            dpm = round(mean(dpm), 3),
            golddiffat15 = round(mean(golddiffat15), 3), 
            xpdiffat15 = round(mean(xpdiffat15), 3),
            firsttower = round(mean(firsttower), 3))
# Processing each variable

lck <- lckplayer %>%
  left_join(lckteam, by = c("date","team"))

# World data processing part

## Player level
wcsplayer <- wcs %>%
  filter(position != "team") 

wcsplayer <- wcsplayer %>%
  group_by(date, team) %>%
  summarise(total_wins = unique(world_total_wins), 
            worldwinrate = round(unique(worldwinrate), 3),
            KDA = round((sum(kills) + sum(assists))/sum(deaths), 3), 
            vspm = round(mean(vspm), 3), 
            cspm = round(mean(cspm), 3),
            dms = round(mean(damageshare), 3))
# Processing each variable

## Team level
wcsteam <- wcs %>%
  filter(position == "team")

wcsteam <- wcsteam %>%
  group_by(date, team) %>%
  summarise(league = unique(league),
            team_dragons_adv = round(mean(dragons) - mean(opp_dragons), 3),
            firstheraldrate = round(mean(firstherald), 3),
            barons = round(barons, 3),
            team_kpm = round(mean(`team kpm`), 3),
            dtpm = round(mean(damagetakenperminute), 3),
            dpm = round(mean(dpm), 3),
            golddiffat15 = round(mean(golddiffat15), 3), 
            xpdiffat15 = round(mean(xpdiffat15), 3),
            firsttower = round(mean(firsttower), 3))
# Processing each variable

wcs <- wcsplayer %>%
  left_join(wcsteam, by=c("date","team"))

lck$timediff <- round(as.numeric(difftime(as.Date("2020-09-25"), lck$date)),3)
wcs$timediff <- round(as.numeric(difftime(as.Date("2020-09-25"), wcs$date)),3)

lck$KDA[which(!is.finite(lck$KDA))] <- 79
wcs$KDA[which(!is.finite(wcs$KDA))] <- 49

write_csv(lck, path = "./Input/lck_data.csv")
write_csv(wcs, path = "./Input/world_data.csv")



