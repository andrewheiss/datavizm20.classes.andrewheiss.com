pts <- function(x) {
  as.numeric(grid::convertUnit(grid::unit(x, "pt"), "mm"))
}

# Aurora and Frost color palettes from Nord
# https://github.com/arcticicestudio/nord
nord_red <- "#BF616A"  # nord11
nord_orange <- "#D08770"  # nord12
nord_yellow <- "#EBCB8B"  # nord13
nord_green <- "#A3BE8C"  # nord14
nord_purple <- "#B48EAD"  # nord15
nord_lt_blue <- "#81A1C1"  # nord9
nord_dk_blue <- "#5E81AC"  # nord10

theme_econ <- function(base_size = 11, base_family = "Roboto Condensed", axis_line = FALSE) {
  update_geom_defaults("label", list(family = "Roboto Condensed Light"))
  update_geom_defaults("text", list(family = "Roboto Condensed Light"))
  
  ret <- theme_bw(base_size, base_family) +
    theme(axis.title.y = element_text(margin = margin(r = 10)),
          axis.title.x = element_text(margin = margin(t = 10)),
          plot.title = element_text(size = rel(1.4), 
                                    family = "Roboto Condensed Bold", face = "plain"),
          plot.subtitle = element_text(size = rel(1),
                                       family = "Roboto Condensed Light", face = "plain"),
          plot.caption = element_text(size = rel(0.8), color = "grey50",
                                      family = "Roboto Condensed Light", face = "plain"),
          strip.text = element_text(size = rel(1), 
                                    family = "Roboto Condensed Bold", face = "plain"),
          legend.title = element_text(size = rel(0.8)),
          panel.border = element_blank(), 
          axis.ticks = element_blank(),
          strip.background = element_rect(fill = "#ffffff", colour=NA),
          panel.spacing.y = unit(1.5, "lines"),
          legend.key = element_blank(),
          legend.spacing = unit(0.1, "lines"),
          legend.box.margin = margin(t = -0.25, unit = "lines"),
          legend.margin = margin(t = 0))
  
  if (axis_line) {
    ret <- ret + theme(axis.line = element_line(color = "black", size = 0.25))
  }
  
  ret
}
