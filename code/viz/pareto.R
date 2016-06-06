## MAKE PARETO CHART

library(plotly)

drug_death %>%
  filter(year == "2014"
         & cause == "opioid") %>%
  ungroup() %>% droplevels() %>%
  arrange(desc(deaths)) %>%
  mutate(cum_pct = cumsum(pct_deaths)) %>%
  plot_ly(x = county, y = deaths, type = "bar", 
          color = cause, colors = "Set3",
          name = "Count") %>%
  add_trace(x = county, y = cum_pct, type = "line",
            name = "Cumulative %", 
            yaxis = "y2") %>%
  layout(xaxis = list(title = "County", showticklabels = F,
                      categoryarray = county, categoryorder = "array"),
         yaxis = list(title = "Deaths"),
         yaxis2 = list(overlaying = "y", side = "right",
                       ticksuffix = "%"),
         legend = list(xanchor = "right", yanchor = "top", x = 1, y = 1, 
                       font = list(size = 10)))