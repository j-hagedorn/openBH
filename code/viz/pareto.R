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
         yaxis = list(title = "Number of deaths"),
         yaxis2 = list(overlaying = "y", side = "right",
                       ticksuffix = "%", showticklabels = F),
         legend = list(xanchor = "right", yanchor = "top", x = 1, y = 1, 
                       font = list(size = 10)))

## Barchart with benchmark

drug_death %>%
  filter(year == "2014"
         & cause == "opioid") %>%
  ungroup() %>% droplevels() %>%
  arrange(desc(deaths_per_100k)) %>%
  mutate(avg_rate = round(sum(deaths, na.rm = T)/sum(TotalPop, na.rm = T)*100000,
                          digits = 1)) %>%
  plot_ly(x = county, y = deaths_per_100k, type = "bar", 
          color = deaths, colors = "Greys",
          name = "Rate per 100k") %>%
  add_trace(x = county, 
            y = rep(avg_rate, each = nlevels(as.factor(county))), 
            type = "line",
            name = "Average Rate", 
            yaxis = "y") %>%
  layout(xaxis = list(title = "County", showticklabels = F,
                      categoryarray = county, categoryorder = "array"),
         yaxis = list(title = "Deaths per 100,000 population"),
         legend = list(xanchor = "right", yanchor = "top", x = 1, y = 1, 
                       font = list(size = 10)))