## server.R ##

shinyServer(function(input, output) {
  
  ## REACTIVE DATA
  
  deaths <- reactive({
    
    pihp_filt <- if (input$select_pihp == "All") {
      levels(drug_death$CMHSP)
    } else input$select_pihp

    cmh_filt <- if (input$select_cmh == "All") {
      levels(drug_death$CMHSP)
    } else input$select_cmh

    deaths <-
    drug_death %>%
      filter(PIHPname %in% pihp_filt
             & CMHSP %in% cmh_filt
             & year >= input$year[1] 
             & year <= input$year[2])
    
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
  
  deaths_summary <- reactive({
    
    deaths() %>%
      group_by()
    
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
  
  output$death_bar <- renderPlotly({
    
    cause_filt <- if (input$cause == "Heroin overdoses") {
      c("heroin")
    } else if (input$cause == "Opioid overdoses") {
      c("opioid")
    } else c("alldrug")
      
    deaths() %>%
      filter(cause == cause_filt) %>%
      ungroup() %>% droplevels() %>%
      arrange(desc(deaths)) %>%
      mutate(cum_pct = cumsum(pct_deaths)) %>%
      plot_ly(x = group, y = deaths, type = "bar", 
              color = cause, colors = "Set3",
              name = "Count") %>%
      add_trace(x = group, y = cum_pct, type = "line",
                name = "Cumulative %", 
                yaxis = "y2") %>%
      layout(xaxis = list(title = "Group", showticklabels = F,
                          categoryarray = group, categoryorder = "array"),
             yaxis = list(title = "Number of deaths"),
             yaxis2 = list(overlaying = "y", side = "right",
                           ticksuffix = "%", showticklabels = F),
             legend = list(xanchor = "right", yanchor = "top", x = 1, y = 1, 
                           font = list(size = 10)))
    
  })
  
})
