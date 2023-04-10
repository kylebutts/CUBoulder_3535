library(data.table)
library(ggplot2)
library(tikzDevice)

df <- tibble::tribble(
  ~source, ~mc, ~gwh, ~fill,
  "Solar", 1, 200, "pink",
  "Wind", 3, 250, "pink",
  "Hydro", 7, 200, "pink",
  "Nuclear", 10, 500, "pink",
  "Coal", 60, 200, "grey50",
  "Gas", 80, 250, "grey50",
  "Oil", 120, 100, "grey50",
  "Diesel", 130, 50, "grey50"
)
df$xmax <- cumsum(df$gwh)
df$xmin <- df$xmax - df$gwh

tikzDevice::tikz(
  file = "Resources/merit_order_curve.tex",
  width = 6.5, height = 3
)

(p <- ggplot(df) +
  geom_rect(
    aes(
      xmin = xmin, xmax = xmax,
      ymin = 0, ymax = mc,
      fill = fill
    )
  ) +
  geom_text(
    aes(
      x = (xmin + xmax) / 2,
      y = mc + 10,
      label = source,
    ),
    size = 3,
    hjust = 0.5, fontface = "bold"
  ) +
  labs(
    x = "Capacity (gWh)",
    y = "Marginal Cost (\\$ per gWh)",
    fill = "Energy Source"
  ) +
  scale_y_continuous(
    breaks = c(0, 10, 60, 80, 120, 130)
  ) +
  scale_fill_identity() +
  guides(
    fill = guide_legend(ncol = 4)
  ) +
  kfbmisc::theme_kyle(base_size = 9) +
  theme(
    legend.position = c(0.2, 0.75),
    panel.grid.minor.y = element_blank()
  ))

plot(p)

dev.off()
