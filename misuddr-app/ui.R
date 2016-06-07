
dashboardPage(
  skin = "black",
  dashboardHeader(
    title = "Overdose Deaths"
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem(
        "Compare", 
        tabName = "compare", 
        icon = icon("bar-chart")
      ),
      menuItem(
        "Trend", 
        tabName = "trend", 
        icon = icon("line-chart")
      ),
      selectInput(
        "group",
        label = "Group by:",
        choices = c("County","CMHSP","PIHP"), 
        selected = "County"
      ),
      selectInput(
        "select_pihp",
        label = "Select PIHP:",
        choices = c("All", levels(as.factor(drug_death$PIHPname))), 
        selected = "MSHN"
      ),
      uiOutput(
        "select_cmh"
      )
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "compare",
        fluidRow(
          column(
            width = 12,
            box(
              title = "Compare", 
              color = "black",
              collapsible = F, 
              width = NULL,
              selectInput(
                "cause",
                label = "Select cause of death:",
                choices = c("Heroin overdoses",
                            "Opioid overdoses",
                            "All overdose deaths"), 
                selected = "Opioid overdoses"
              ),
              tabBox(
                tabPanel(
                  "Pareto",
                  sliderInput(
                    "pareto_year", 
                    "Select year(s)", 
                    min = min(as.integer(drug_death$year)), 
                    max = max(as.integer(drug_death$year)), 
                    value = c(min(as.integer(drug_death$year)[is.na(drug_death$TotalPop)==F]),
                              max(as.integer(drug_death$year))), 
                    step = 1,
                    ticks = F, 
                    sep = "", 
                    dragRange = T
                  ),
                  plotlyOutput("death_bar")
                )
              ),
              tabBox(
                tabPanel(
                  "Rates",
                  sliderInput(
                    "rate_year", 
                    "Select year(s)", 
                    min = min(as.integer(drug_death$year[is.na(drug_death$TotalPop)==F])), 
                    max = max(as.integer(drug_death$year[is.na(drug_death$TotalPop)==F])), 
                    value = c(min(as.integer(drug_death$year[is.na(drug_death$TotalPop)==F])),
                              max(as.integer(drug_death$year[is.na(drug_death$TotalPop)==F]))), 
                    step = 1,
                    ticks = F, 
                    sep = "", 
                    dragRange = T
                  )
                )
              )
            )
          )
        )
      )
    )
  )
)
