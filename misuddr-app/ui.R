
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
      uiOutput("select_cmh"),
      sliderInput(
        "year", 
        "Select year(s)", 
        min = min(as.integer(drug_death$year)), 
        max = max(as.integer(drug_death$year)), 
        value = c(min(as.integer(drug_death$year)),
                  max(as.integer(drug_death$year))), 
        step = 1,
        ticks = F, 
        sep = "", 
        dragRange = T
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
              tabBox(
                tabPanel(
                  "Pareto",
                  selectInput(
                    "cause",
                    label = "Select cause of death:",
                    choices = c("Heroin overdoses",
                                "Opioid overdoses",
                                "All overdose deaths"), 
                    selected = "Opioid overdoses"
                  ),
                  plotlyOutput("death_bar")
                )
              )
            )
          )
        )
      )
    )
  )
)
