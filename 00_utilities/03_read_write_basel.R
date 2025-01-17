library(tidyverse)

df <- readr::read_csv2("data/basel_fuss_velo/converted_Velo_Fuss_Count.csv")


df_group <-df %>%
  #filter(SiteName=='902 Viaduktstrasse',Year==2019)%>%
  group_by(SiteName,TrafficType,Year,Month,Day)%>%
  summarise(total_cyclists=sum(Total,na.rm = T))%>%
  mutate(year_month=lubridate::make_date(year=Year,month=Month))%>%
  inner_join(df_wetter_basel)

write.csv(df_group,"data/counts_weather_basel.csv")


df_filter <- df %>% filter(Year>2018,Year<2021)
head(df_filter)
# Filter 2019 2020
readr::write_csv(df_filter,"data/basel_fuss_velo/2019_2020_converted_Velo_Fuss_Count.csv" )

# Aggregate the data per day
df_filter_agg <- df %>% filter(Year>2018,Year<2021) %>%
  filter(TrafficType!='Fussgänger')%>%
  dplyr::group_by(SiteCode,SiteName,DirectionName,LaneCode,LaneName,Date,Year,Month,Day,Weekday) %>%
  dplyr::summarise(ValuesApproved=sum(Total,na.rm = T))

# Write the aggregated data per day
readr::write_csv(df_filter_agg,"data/basel_fuss_velo/2019_2020_converted_Velo_Fuss_Count_daily.csv" )

# Write a single example
df_filter_agg_month_viaduct <- df_filter %>% 
  filter(TrafficType!='Fussgänger')%>%
  filter(SiteName=='902 Viaduktstrasse',Year==2019)%>%
  group_by(SiteName,Year,Month)%>%
  summarise(total_cyclists=sum(Total,na.rm = T))%>%
  mutate(year_month=lubridate::make_date(year=Year,month=Month))

# Tableau example

readr::write_csv(df_filter_agg_month_viaduct,"data/basel_fuss_velo/2019_count_viaduct.csv" )


