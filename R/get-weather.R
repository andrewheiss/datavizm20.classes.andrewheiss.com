library(tidyverse)
library(darksky)
library(lubridate)

now <- get_current_forecast(33.754557, -84.390009)
print(now)

atl_2019_dates <- tibble(day = seq(ymd("2019-01-01"),
                                   ymd("2019-12-31"),
                                   by = "1 day")) %>% 
  mutate(when = paste0(day, "T12:00:00"))

atl_2019_raw <- atl_2019_dates %>% 
  mutate(weather = map(when, ~get_forecast_for(33.754557, -84.390009, .x)))

atl_2019_everything <- atl_2019_raw %>% 
  mutate(hourly = map(weather, ~.x$hourly),
         daily = map(weather, ~.x$daily),
         currently = map(weather, ~.x$currently))

atl_2019_hourly <- atl_2019_everything %>% 
  select(hourly) %>% unnest(hourly)

atl_2019_daily <- atl_2019_everything %>% 
  select(daily) %>% unnest(daily)

atl_2019_currently <- atl_2019_everything %>% 
  select(currently) %>% unnest(currently)

saveRDS(atl_2019_everything, "~/Desktop/atl_2019_everything.rds")
atl_2019_everything <- readRDS("~/Desktop/atl_2019_everything.rds")


write_csv(atl_2019_daily, "~/Downloads/atl-weather-2019.csv")


weather_atl_raw <- atl_2019_daily

weather_atl <- weather_atl_raw %>% 
  mutate(Month = month(time, label = TRUE, abbr = FALSE),
         Day = wday(time, label = TRUE, abbr = FALSE))

ggplot(weather_atl, aes(x = windSpeed)) +
  geom_histogram(binwidth = 1, color = "white")

ggplot(weather_atl, aes(x = windSpeed, fill = Month)) +
  geom_histogram(binwidth = 1, color = "white")

ggplot(weather_atl, aes(x = windSpeed, fill = Month)) +
  geom_histogram(binwidth = 1, color = "white") + 
  guides(fill = FALSE) +
  facet_wrap(vars(Month))


ggplot(weather_atl, aes(x = windSpeed)) +
  geom_density(fill = "#24af53")

ggplot(weather_atl, aes(x = windSpeed, fill = Month)) +
  geom_density() +
  guides(fill = FALSE) +
  facet_wrap(~ Month)

ggplot(weather_atl, aes(x = windSpeed, fill = Month)) +
  geom_density(alpha = 0.4) +
  guides(fill = guide_legend(nrow = 2)) +
  theme(legend.position = "bottom")

library(ggridges)

ggplot(weather_atl, aes(x = windSpeed, y = fct_rev(Month),
                        fill = Month)) +
  geom_density_ridges(scale = 5) +
  guides(fill = FALSE) +
  labs(x = "Wind speed", y = NULL) +
  theme_minimal()

ggplot(weather_atl, aes(x = temperatureHigh, y = fct_rev(Month),
                        fill = Month)) +
  geom_density_ridges(scale = 5, quantile_lines = TRUE, quantiles = 2) +
  guides(fill = FALSE) +
  labs(x = "Wind speed", y = NULL) +
  theme_minimal()


ggplot(weather_atl, aes(x = temperatureHigh, y = Month, fill = ..x..)) +
  geom_density_ridges_gradient(quantile_lines = TRUE, quantiles = 2) + 
  scale_fill_viridis_c(option = "plasma", name = "Temp") +
  theme_minimal()


weather_atl_long <- weather_atl %>% 
  pivot_longer(cols = c(temperatureLow, temperatureHigh),
               names_to = "temp_type",
               values_to = "temp") %>% 
  select(time, temp_type, temp, Month) %>% 
  mutate(temp_type = recode(temp_type, 
                            temperatureHigh = "High",
                            temperatureLow = "Low"))

ggplot(weather_atl_long, 
       aes(x = temp, y = fct_rev(Month), fill = ..x.., linetype = temp_type)) +
  geom_density_ridges_gradient(scale = 3, rel_min_height = 0.01) +
  scale_fill_viridis_c(option = "plasma") +
  guides(linetype = guide_legend(title = NULL, order = 1),
         fill = guide_colorbar(title = NULL), order = 2) +
  labs(x = NULL, y = NULL,
       title = "Low and high temperatures in Atlanta, Georgia",
       subtitle = "January 1, 2019-December 31, 2019",
       caption = "Source: Dark Sky") +
  theme_minimal(base_family = "Roboto Condensed") +
  theme(legend.position = "bottom",
        legend.key.width = unit(3, "lines"),
        legend.key.height = unit(0.5, "lines"))


ggplot(weather_atl,
       aes(y = windSpeed, fill = Day)) +
  geom_boxplot()

ggplot(weather_atl,
       aes(y = windSpeed, x = Day, fill = Day)) +
  geom_violin() +
  geom_point(size = 0.5, position = position_jitter(width = 0.1)) +
  guides(fill = FALSE)

ggplot(weather_atl,
       aes(y = windSpeed, x = Day, fill = Day)) +
  geom_violin() +
  stat_summary(geom = "point", fun = "mean", size = 5, color = "white") +
  geom_point(size = 0.5, position = position_jitter(width = 0.1)) +
  guides(fill = FALSE)

library(gghalves)

ggplot(weather_atl,
       aes(x = fct_rev(Day), y = temperatureHigh)) +
  geom_half_boxplot(aes(color = Day), side = "l") +
  geom_half_point(aes(color = Day), side = "l", size = 0.5) +
  geom_half_violin(aes(fill = Day), side = "r") + 
  coord_flip()
 