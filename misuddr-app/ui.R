
dashboardPage(
  skin = "black",
  dashboardHeader(
    title = "Overdose Deaths"
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem(
        "The epidemic...", 
        tabName = "epidemic", 
        icon = icon("heartbeat")
      ),
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
      menuItem(
        "What next?", 
        tabName = "next", 
        icon = icon("hourglass-end")
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
        tabName = "epidemic",
        fluidRow(
          column(
            width = 12,
            box(
              title = "A National Epidemic", 
              color = "black",
              collapsible = T, 
              width = NULL,
              p(
                "According to the United States' ",
                a(href = "http://www.cdc.gov/drugoverdose/epidemic/index.html",
                  "Centers for Disease Control"),
                ", more people died from drug overdoses in 2014 than any other 
                year on record. Most drug overdose deaths (>60%) involve an 
                opioid, primarily prescription pain relievers and heroin. 
                And the problem is growing.  Since 1999, the rate of overdose 
                deaths involving opioids (including prescription opioid pain 
                relievers and heroin) has nearly quadrupled."
              )
            ),
            box(
              title = "Local Focus", 
              color = "black",
              collapsible = T,
              collapsed = F,
              width = NULL,
              p(
                "Michigan was one of a handful of states to show a statistically 
                significant increase in the rate of drug overdoses between 2013 
                and 2014 (",
                em("Source: "),
                a(href = "http://www.cdc.gov/drugoverdose/data/statedeaths.html",
                  "CDC"), ")."
              ),
              p(
                "In order to better understand the nuanced local variations 
                influencing this statewide trend, we used data from the 
                Michigan Substance Use Data Repository (", 
                a(href = "http://mi-suddr.com/about/",
                  "MI-SUDDR"),
                ") to allow for analysis by county for the years ",
                paste0(min(drug_death$year), " through ",max(drug_death$year)),"."
              ),
              p(
                "Results can also be grouped by Prepaid Inpatient Health Plan 
                (PIHP), since the PIHP acts as the Substance Use Disorder 
                Coordinating Agency to manage services for people with 
                substance use disorders.  Access to substance use services is 
                also coordinated through Community Mental Health (CMH) service 
                providers, and the regional data can be grouped by CMH as well."
              )
            ),
            box(
              title = "Getting Started", 
              color = "black",
              collapsible = T, 
              collapsed = T,
              width = NULL,
              p(
                "Select the ", em("Compare"), " and ", em("Trend"), 
                " tabs on the menu to the left in order to start learning 
                about how this epidemic is affecting communities throughout 
                Michigan."
              ),
              p(
                "The ", em("Group By"), " dropdown allows you to select how you 
                want to aggregate the analysis: by County, CMHSP, or PIHP."
              ),
              p(
                "You can also ", em("Select PIHP")," and ", em("Select CMH"), 
                "in order to focus in on a specific regional grouping of 
                counties ",
                a(href = "https://www.macmhb.org/sites/default/files/attachments/files/COUNTYMAPBYNewPIHP2016.pdf",
                  "by PIHP"), " or ",
                a(href = "http://www.michigan.gov/mdhhs/0,5885,7-339-71550_2941_4868_4899-178824--,00.html",
                  "by CMH")
              )
            ),
            box(
              title = "Data Definitions", 
              color = "black",
              collapsible = T, 
              collapsed = T,
              width = NULL,
              p(
                strong("Drug poisoning deaths"), " are defined as having ICD-10 
                underlying cause of death codes within the following ranges:",
                tags$ul(
                  tags$li("X40-X44 (", em("unintentional"),")"),
                  tags$li("X60-X64 (", em("intentional"),")"),
                  tags$li("X85 (", em("homicide"),")"),
                  tags$li("Y10-Y14 (", em("undetermined intent"),")")
                )
              ),
              p(
                strong("Heroin deaths"), 
                " include those with ICD-10 related cause code T40.1. 
                Heroin-related deaths include: ", 
                tags$ul(
                  tags$li("Heroin without cocaine or opioid"),
                  tags$li("Heroin and cocaine without opioid")
                ) 
              ),
              p(
                strong("Opioid deaths"),
                " include those with ICD-10 related code T40.2-T40.4.  
                Opioid-related deaths include:",
                tags$ul(
                  tags$li("Opioid without heroin or cocaine"),
                  tags$li("Opioid with heroin, without cocaine"),
                  tags$li("Opioid with cocaine, without heroin"),
                  tags$li("Opioid with heroin and cocaine")
                ) 
              ),
              p(
                strong("Data source"),": ",
                em("Michigan Death Certificates, Division for Vital Records and 
                   Health Statistics, Michigan Department of Health and Human 
                   Services")
              )
            )
          )
        )
      ),
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
                choices = c("Heroin overdose deaths",
                            "Opioid overdose deaths",
                            "All overdose deaths"), 
                selected = "Opioid overdoses"
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
                  ),
                  plotlyOutput("death_rate"),
                  br(),
                  h5(textOutput("define_rate"))
                ),
                tabPanel(
                  "About",
                  h4("Calculating Rates"),
                  p(
                    "Calculating rates is a common way to allow for comparisons 
                    across geographic areas with varying population sizes.  
                    Per 100,000 rates are common when reporting deaths.  
                    While there may or may not be 100,000 residents in the 
                    county under review, multiplying the result by 100,000 
                    makes that rate comparable with counties which have more 
                    or less than 100,000 residents.  The formula used is ",
                    code("Number of deaths / Total Population * 100,000"),"."
                  ),
                  h4("Population Data"),
                  p(
                    "Population estimates used in rate calculations are drawn 
                    from the ",
                    a(href = "http://www.census.gov/data/developers/data-sets/acs-survey-5-year-data.html",
                      "Census API"),
                    " and use American Community Survey (ACS) 5-year Estimates ",
                    a(href = "https://www.census.gov/programs-surveys/acs/guidance/estimates.html",
                      "to support increased accuracy.")
                  ),
                  p(
                    "Currently, only years from 2009 onward are available for 
                    download from the Census API."
                  )
                )
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
                  plotlyOutput("death_bar"),
                  br(),
                  h5(textOutput("define_pareto"))
                ),
                tabPanel(
                  "About",
                  h4("Pareto Charts"),
                  p(
                    a(href = "https://en.wikipedia.org/wiki/Pareto_chart",
                      "Pareto charts"),
                    " are a type of mixed bar-and-line diagram which arranges 
                    various factors according to the magnitude of their impact. 
                    The chart is a visual display of the ", 
                    em("Pareto Principle"), 
                    ", which states that a small number of members of a group 
                    often account for the majority of the effect. Using a 
                    Pareto chart can help teams to focus on factors that have 
                    the greatest effect and communicate the reason for their 
                    focus."
                  )
                )
              )
            )
          )
        )
      ),
      tabItem(
        tabName = "trend",
        fluidRow(
          column(
            width = 12,
            box(
              title = "Trending", 
              color = "black",
              collapsible = F, 
              width = NULL,
              tabBox(
                width = NULL,
                tabPanel(
                  "By Cause",
                  plotlyOutput("line_cause"),
                  br(),
                  p(
                    strong("Note:"), "Please be aware that the ",em("Group By"), 
                    "dropdown filter does not impact the chart in this view."
                  )
                ),
                tabPanel(
                  "By Group",
                  selectInput(
                    "cause_line",
                    label = "Select cause of death:",
                    choices = c("Heroin overdose deaths",
                                "Opioid overdose deaths",
                                "All overdose deaths"), 
                    selected = "Opioid overdoses"
                  ),
                  plotlyOutput("line_group")
                )
              )
            )
          )
        )
      ),
      tabItem(
        tabName = "next",
        fluidRow(
          column(
            width = 12,
            p(
              "Each death from the disease of addiction is preventable. 
              Reducing the number of overdose deaths requires that we battle 
              stigma, improve access to care, and ensure that high quality 
              care is provided. Knowledge without action rings hollow. 
              We encourage you to take the information provided here and use 
              it to begin dialogue about how your organization or community 
              can tackle this critical issue.  Here are some thoughts to get 
              started:"
            ),
            p(
              strong("Communicate"),": Share the information with others in 
              your organization or community (", 
              em("e.g. primary care providers, SUD service providers, 
                 hospital systems, Recovery Oriented System of Care groups, 
                 healthcare coalitions, community collaborative groups, 
                 educational systems, public health systems, etc. "),")."
            ),
            p(
              strong("Choose to Act"),": Determine how your organization or 
              other community stakeholders want to take any action in response 
              to this data. You may decide action is needed due to having a 
              higher than average rate of overdose deaths compared to your 
              region or the state. However, even if your catchment area has a 
              lower than average rate of overdose deaths, each of these deaths 
              is preventable and every community can tackle this issue to work 
              towards a reduction in deaths. Responses could include the 
              following (", em("Expand boxes for details"), "):"
            ),
            box(
              title = "Community Collaboration",
              color = "black",
              collapsible = T, 
              collapsed = T,
              width = NULL,
              tags$ul(
                tags$li("Complete a root cause analysis with input from 
                        various community members and stakeholders to 
                        identify possible causes of overdose deaths in 
                        your community"),
                tags$li("Engage in cross-agency prevention and control 
                        initiatives, including data sharing as appropriate 
                        (for one example of a prevention initiative, see ",
                        a(href = "https://www.dea.gov/take-back/takeback-news.shtml",
                          "National Prescription Drug Take Back Day"),")")
              )
            ),
            box(
              title = "Education",
              color = "black",
              collapsible = T, 
              collapsed = T,
              width = NULL,
              tags$ul(
                tags$li("Give providers education around evidence-based 
                        practices (see ",
                        a(href = "http://www.cdc.gov/mmwr/volumes/65/rr/rr6501e1.htm",
                          "CDC Guidelines for Prescribing Opioids for Chronic Pain"), ", ",
                        a(href = "http://www.fda.gov/Drugs/DrugSafety/InformationbyDrugClass/ucm330614.htm",
                          "U.S. FDA notice to all prescribers"), ", ",
                        a(href = "http://store.samhsa.gov/product/Opioid-Overdose-Prevention-Toolkit-Updated-2016/All-New-Products/SMA16-4742",
                          "SAMHSA resources for prescribers"), 
                        " including free courses, mentoring, and Treatment 
                        Improvement Protocols)"),
                tags$li("Provide education to healthcare leaders (see example of 
                        Wisconsin’s efforts in this area:", 
                        a(href = "http://www.wha.org/opioid.aspx",
                          "Hospital Association Resource Page"),")"),
                tags$li("Provide education to community members around opioid 
                        abuse (see ",
                        a(href = "http://store.samhsa.gov/shin/content/SMA16-4742/FactsforCommunityMembers.pdf",
                          "SAMHSA’s Facts for Community Members"),")"),
                tags$li("Engage in anti-stigma efforts ")
              )
            ),
            box(
              title = "Services",
              color = "black",
              collapsible = T, 
              collapsed = T,
              width = NULL,
              tags$ul(
                tags$li("Promote high-quality, outcomes driven SUD services"),
                tags$li("Increase the use of non-pharmacological pain 
                        management interventions"),
                tags$li("Improve access to the full array of SUD services, 
                        including MAT"),
                tags$li("Support access to Naloxone to reduce overdose deaths (see ",
                        a(href = "http://www.integration.samhsa.gov/opioid_toolkit_firstresponders.pdf",
                          "SAMHSA’s 5 Essential Steps for First Responders"),")"),
                tags$li("Implement emergency department care guidelines and/or 
                        patient care plans related to pain management")
              )
            ),
            box(
              title = "Effective Use of Data",
              color = "black",
              collapsible = T, 
              collapsed = T,
              width = NULL,
              tags$ul(
                tags$li("Analyze additional data (e.g. prescribing practices for 
                        opioids by local providers, utilization patterns by 
                        patients, penetration rates for SUD services, 
                        SUD-related emergency department utilization, etc.) 
                        to gather a deep understanding of the issue"),
                tags$li("Continue to monitor the data via a designated forum at 
                        a specific frequency (e.g. annual review by local 
                        healthcare coalition as a part of the community needs 
                        assessment)"),
                tags$li("Track current opioid-related data flow within local 
                        community and complete a gap analysis to determine where 
                        data-sharing is needed"),
                tags$li("Consider implementing quality measures related to 
                        Opioid prescribing practices (see ",
                        a(href = "http://pqaalliance.org/measures/default.asp",
                          "PCA measures)"),")")
              )
            )
          )
        )
      )
    )
  )
)
