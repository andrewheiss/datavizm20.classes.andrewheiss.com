library(gganimate)

plot_health_wealth <- ggplot(gapminder, aes(gdpPercap, lifeExp, size = pop, color = country)) +
  geom_point(alpha = 0.7) +
  scale_size(range = c(2, 12)) +
  scale_x_log10(labels = scales::dollar) +
  guides(size = FALSE, color = FALSE) +
  facet_wrap(~continent) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  # Special gganimate stuff
  labs(title = 'Year: {frame_time}', x = 'GDP per capita', y = 'life expectancy') +
  transition_time(year) +
  ease_aes('linear')

animate(plot_health_wealth, nframes = 210, fps = 30,
        start_pause = 0, end_pause = 60,
        width = 600, height = 480, res = 100, type = "cairo", detail = 2,
        renderer = gifski_renderer("img/03/gapminder.gif"))
