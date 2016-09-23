## server.R ##

shinyServer(function(input, output) {
  
  ## REACTIVE DATA
  
  deaths <- reactive({
    
    pihp_filt <- if (input$select_pihp == "All") {
      levels(drug_death$PIHPname)
    } else input$select_pihp

    cmh_filt <- if (input$select_cmh == "All") {
      levels(drug_death$CMHSP)
    } else input$select_cmh

    deaths <-
    drug_death %>%
      filter(PIHPname %in% pihp_filt
             & CMHSP %in% cmh_filt)
    
    if (input$group == "County") {
      
      # Calc total pop by CMHSP
      totals_cty <-
        totals %>%
        group_by(county,year) %>%
        summarize(TotalPop = sum(TotalPop)) %>%
        mutate(key = paste0(county,"_",year)) %>%
        ungroup() %>%
        select(key,TotalPop)
      
      deaths %>%
        group_by(PIHPname,CMHSP,county,year,cause) %>%
        summarize(deaths = sum(deaths, na.rm = T)) %>%
        ungroup() %>% droplevels() %>%
        mutate(key = paste0(county,"_",year)) %>%
        left_join(totals_cty, by = "key") %>%
        group_by(year,cause) %>%
        mutate(deaths_per_100k = round(deaths/TotalPop*100000, digits = 1),
               pct_deaths = round(deaths/sum(deaths)*100, digits = 1)) %>%
        rename(group = county)
      
    } else if (input$group == "CMHSP") {
      
      # Calc total pop by CMHSP
      totals_cmh <-
      totals %>%
        group_by(CMHSP,year) %>%
        summarize(TotalPop = sum(TotalPop)) %>%
        mutate(key = paste0(CMHSP,"_",year)) %>%
        ungroup() %>%
        select(key,TotalPop)
      
      deaths %>%
        group_by(PIHPname,CMHSP,year,cause) %>%
        summarize(deaths = sum(deaths, na.rm = T)) %>%
        ungroup() %>% droplevels() %>%
        mutate(key = paste0(CMHSP,"_",year)) %>%
        left_join(totals_cmh, by = "key") %>%
        group_by(year,cause) %>%
        mutate(deaths_per_100k = round(deaths/TotalPop*100000, digits = 1),
               pct_deaths = round(deaths/sum(deaths)*100, digits = 1)) %>%
        rename(group = CMHSP)
      
    } else if (input$group == "PIHP") {
      
      # Calc total pop by PIHP
      totals_pihp <-
        totals %>%
        group_by(PIHPname,year) %>%
        summarize(TotalPop = sum(TotalPop)) %>%
        mutate(key = paste0(PIHPname,"_",year)) %>%
        ungroup() %>%
        select(key,TotalPop)
      
      deaths %>%
        group_by(PIHPname,year,cause) %>%
        summarize(deaths = sum(deaths, na.rm = T)) %>%
        ungroup() %>% droplevels() %>%
        mutate(key = paste0(PIHPname,"_",year)) %>%
        left_join(totals_pihp, by = "key") %>%
        group_by(year,cause) %>%
        mutate(deaths_per_100k = round(deaths/TotalPop*100000, digits = 1),
               pct_deaths = round(deaths/sum(deaths)*100, digits = 1)) %>%
        rename(group = PIHPname)
      
    } else paste0("Group by what? Unrecognized entry.")
    
    
  })
  
  ## REACTIVE FILTERS
   
  output$select_cmh <- renderUI({
    
    filtre <- if (input$select_pihp == "All") {
      levels(drug_death$CMHSP)
    } else 
      levels(droplevels(drug_death$CMHSP[drug_death$PIHPname == input$select_pihp]))
    
    selectInput(
      "select_cmh",
      label = "Select CMH:",
      choices = c("All", filtre), 
      selected = "All"
    )
    
  })
  
  ## DATAVIZ
  
  output$death_rate <- renderPlotly({
    
    cause_filt <- if (input$cause == "Heroin overdose deaths") {
      c("heroin")
    } else if (input$cause == "Opioid overdose deaths") {
      c("opioid")
    } else c("alldrug")
    
    deaths() %>%
      filter(cause == cause_filt
             & year >= input$rate_year[1] 
             & year <= input$rate_year[2]) %>%
      ungroup() %>% droplevels() %>%
      group_by(group,cause) %>%
      summarize(deaths = sum(deaths, na.rm = T),
                TotalPop = sum(TotalPop, na.rm = T)) %>% # add pop across years
      ungroup() %>% droplevels() %>%
      mutate(deaths_per_100k = round(deaths/TotalPop*100000, digits = 1)) %>%
      ungroup() %>% droplevels() %>%
      arrange(desc(deaths_per_100k)) %>%
      mutate(avg_rate = round(sum(deaths, na.rm = T)/sum(TotalPop, na.rm = T)*100000,
                              digits = 1)) %>%
      plot_ly(x = group, y = deaths_per_100k, type = "bar",
              marker = list(color = "#CD5C5C"),
              name = "Rate per 100k") %>%
      add_trace(x = group, 
                y = rep(avg_rate, each = nlevels(as.factor(group))), 
                type = "line",
                line = list(dash = 5),
                marker = list(color = "#555555"),
                name = "Average Rate", 
                yaxis = "y") %>%
      layout(title = paste0("Rate of ",input$cause),
             xaxis = list(title = input$group, showticklabels = F,
                          categoryarray = group, categoryorder = "array"),
             yaxis = list(title = "Deaths per 100,000 population",
                          range = c(0, max(deaths_per_100k,na.rm=F)*1.1)),
             legend = list(xanchor = "right", yanchor = "top", x = 1, y = 1, 
                           font = list(size = 10)))
    
  })
  
  output$define_rate <- renderText({
    
    paste0(
      "The chart above shows the number of ",
      tolower(input$cause), 
      " per 100,000 people in the general population of the region served by ", 
      ifelse(input$select_cmh == "All",
             yes = paste0(tolower(input$select_cmh), " CMHs "),
             no = paste0(" the CMH of ", input$select_cmh,",")), 
      " managed by ",
      ifelse(input$select_pihp == "All",
             yes = paste0(input$select_pihp, " PIHPs "),
             no = paste0(" the PIHP of ", input$select_pihp)),
      ".  Each bar in the chart represents a single ",
      ifelse(input$group == "County",tolower(input$group),input$group), 
      " and includes data for the years of ",
      input$rate_year[1], " through ", input$rate_year[2], ".",
      "  The dotted line overlaid on the bars shows the average rate of ",
      tolower(input$cause), " per 100,000 across the ", 
      ifelse(input$group == "County",tolower(input$group),input$group), 
      " groups selected and the filters applied (i.e. ", 
      ifelse(input$select_cmh == "All",
             yes = paste0(tolower(input$select_cmh), " CMHs "),
             no = paste0(" the CMH of ", input$select_cmh)),
      " within ",
      ifelse(input$select_pihp == "All",
             yes = paste0(input$select_pihp, " PIHPs "),
             no = paste0(" the PIHP of ", input$select_pihp)),")."
    )
    
  })
  
  output$death_bar <- renderPlotly({
    
    cause_filt <- if (input$cause == "Heroin overdose deaths") {
      c("heroin")
    } else if (input$cause == "Opioid overdose deaths") {
      c("opioid")
    } else c("alldrug")
      
    deaths() %>%
      filter(cause == cause_filt
             & year >= input$pareto_year[1] 
             & year <= input$pareto_year[2]) %>%
      group_by(group,cause) %>%
      summarize(deaths = sum(deaths, na.rm = T)) %>%
      ungroup() %>% droplevels() %>%
      mutate(pct_deaths = round(deaths/sum(deaths)*100, digits = 1)) %>%
      ungroup() %>% droplevels() %>%
      arrange(desc(deaths)) %>%
      mutate(cum_pct = cumsum(pct_deaths)) %>%
      plot_ly(x = group, y = deaths, type = "bar", 
              marker = list(color = "#555555"),
              name = "Count") %>%
      add_trace(x = group, y = cum_pct, type = "line",
                marker = list(color = "#CD5555"),
                name = "Cumulative %", 
                yaxis = "y2") %>%
      layout(title = paste0("Frequency of ",input$cause),
             xaxis = list(title = input$group, showticklabels = F,
                          categoryarray = group, categoryorder = "array"),
             yaxis = list(title = "Number of deaths",
                          range = c(0, max(deaths)*1.1)),
             yaxis2 = list(overlaying = "y", side = "right",
                           ticksuffix = "%", showticklabels = F,
                           range = c(0, max(cum_pct)*1.1)),
             legend = list(xanchor = "right", yanchor = "top", x = 1, y = 1, 
                           font = list(size = 10)))
    
  })
  
  output$define_pareto <- renderText({
    
    paste0(
      "The chart above shows the number of ",
      tolower(input$cause), " for the region served by ", 
      ifelse(input$select_cmh == "All",
             yes = paste0(tolower(input$select_cmh), " CMHs "),
             no = paste0(" the CMH of ", input$select_cmh,",")), 
      " managed by ",
      ifelse(input$select_pihp == "All",
             yes = paste0(input$select_pihp, " PIHPs "),
             no = paste0(" the PIHP of ", input$select_pihp)),
      ".  Each bar in the chart represents a single ",
      ifelse(input$group == "County",tolower(input$group),input$group), 
      " and includes data for the years of ",
      input$pareto_year[1], " through ", input$pareto_year[2], ".",
      "  The line chart overlaid on the bars shows the cumulative 
      percentage of all ", tolower(input$cause), 
      " for the selected region (i.e. ",
      ifelse(input$select_cmh == "All",
             yes = paste0(tolower(input$select_cmh), " CMHs "),
             no = paste0(" the CMH of ", input$select_cmh)),
      " within ",
      ifelse(input$select_pihp == "All",
             yes = paste0(input$select_pihp, " PIHPs "),
             no = paste0(" the PIHP of ", input$select_pihp)),
      "), moving from left to right across the chart."
    )
    
  })
  
  output$line_cause <- renderPlotly({
    
    deaths() %>%
      filter(is.na(TotalPop) == F) %>%
      droplevels() %>% ungroup() %>%
      group_by(year,cause) %>%
      summarize(deaths = sum(deaths, na.rm = T),
                TotalPop = sum(TotalPop, na.rm = T)) %>% # add pop across years
      ungroup() %>% droplevels() %>%
      mutate(deaths_per_100k = round(deaths/TotalPop*100000, digits = 1)) %>%
      ungroup() %>% droplevels() %>%
      mutate(cause = recode(cause,
                            "'opioid' = 'Opioids';
                            'heroin' = 'Heroin';
                            'alldrug' = 'Any drug'")) %>%
      plot_ly(x = year, y = deaths_per_100k, color = cause,
              name = "Rate per 100k", 
              text = paste("Number of deaths: ", deaths,
                           "<br>Total population: ", TotalPop),
              line = list(shape = "spline")) %>%
      layout(title = paste0("Trend of overdose deaths by cause"),
             xaxis = list(title = "Year"),
             yaxis = list(title = "Deaths per 100,000 population",
                          range = c(0, max(deaths_per_100k,na.rm=F)*1.1)),
             legend = list(font = list(size = 10)))
    
  })
  
  output$line_group <- renderPlotly({
    
    cause_filt <- if (input$cause_line == "Heroin overdose deaths") {
      c("heroin")
    } else if (input$cause_line == "Opioid overdose deaths") {
      c("opioid")
    } else c("alldrug")
    
    deaths() %>%
      filter(is.na(TotalPop) == F
             & cause %in% cause_filt) %>%
      droplevels() %>% ungroup() %>%
      group_by(year,group) %>%
      summarize(deaths = sum(deaths, na.rm = T),
                TotalPop = sum(TotalPop, na.rm = T)) %>% # add pop across years
      ungroup() %>% droplevels() %>%
      mutate(deaths_per_100k = round(deaths/TotalPop*100000, digits = 1)) %>%
      ungroup() %>% droplevels() %>%
      plot_ly(x = year, y = deaths_per_100k, color = group,
              name = "Rate per 100k",
              text = paste("Number of deaths: ", deaths,
                           "<br>Total population: ", TotalPop),
              line = list(shape = "spline")) %>%
      layout(title = paste0("Trend of ",input$cause_line," by ",input$group),
             xaxis = list(title = "Year"),
             yaxis = list(title = "Deaths per 100,000 population",
                          range = c(0, max(deaths_per_100k,na.rm=F)*1.1)),
             legend = list(font = list(size = 10)))
    
  })
  
})
