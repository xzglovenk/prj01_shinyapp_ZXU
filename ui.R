library(DT)
library(shiny)
library(shinydashboard)
library(bubbles)
library(dplyr)
library(ggplot2)

shinyUI(dashboardPage(
    dashboardHeader(title = "Stack Overflow Survey: at a Glance", titleWidth = "35%"),
    dashboardSidebar(
        
        sidebarUserPanel("Zhenggang Xu",
                         image = "https://yt3.ggpht.com/-04uuTMHfDz4/AAAAAAAAAAI/AAAAAAAAAAA/Kjeupp-eNNg/s100-c-k-no-rj-c0xffffff/photo.jpg"),
        sidebarMenu(
#            menuItem("Introduction", tabName = "intro",icon = icon("intro")),
            menuItem("Introduction", tabName = "intro2",icon = icon("intro2")),
            menuItem("Respondent Profile", tabName = "profile", icon = icon("profile")),
            menuItem("About Work", tabName = "workstat", icon = icon("workstat")),
            menuItem("Life Style", tabName = "lifeStyle", icon = icon("lifeStyle")),
            menuItem("Summary", tabName = "summary01",icon = icon("summary"))

        )
 
    ),
    dashboardBody(
        tags$head(
            tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
        ),
###################################################        
         tabItems(
## Introduction Page ##
            tabItem(tabName = "intro2",
                    fluidRow(
                      column(7, htmlOutput("introText")),
                      column(5,
                             img(
                               src = "https://images.sunfrogshirts.com/2017/01/17/71560-1484661047587-Gildan-Hoo-Black-_w92_-front.jpg",
                               width = 500,
                               align = "right"
                             )
                    )
                    )
            ),
            # Profile page
            tabItem(tabName = "profile",
                    fluidRow(
                      # Dropdown menu for selecting different factors, use 'Country' as default
                      selectizeInput("distribution1",
                                     "Distribution factor",
                                     choice = c("Country","Gender", "FormalEducation", "UndergradMajor", "YearsCoding"),
                                     selected = "Country"
                      )
                    ),
                    fluidRow(
                      # Title box
                      box(
                        width = 10, status = "info", solidHeader = TRUE,
                        title = "Distribution by different catergory",
                        
                        # Showing different content for different choice users make.
                        # Different object will be passed if 'Country' is selected. So conditional panel is used.
                        conditionalPanel(
                          
                          condition = "input.distribution1 =='Country'",
                        
                          box(
                            title = "Distributed by country",
                            width = 12,
                            # Show both bubble plot and map view for respondent distribution
                            bubblesOutput("distrChart1", width = "100%", height = 600),
                            htmlOutput("map01")
                          )
                        ),
                        # Show plotly object
                        conditionalPanel(
                          condition = "input.distribution1 !='Country'",
                          # uiOutput('chart')
                          plotlyOutput("distrChart2")
                        ) 
                      )
                    )
            ),
######################################################            
            tabItem(tabName = "workstat",
                    fluidRow(
                      # tabBox shows different content for different tab
                      tabBox(
                        title = "About work",
                        # The id lets us use input$tabset1 on the server to find the current tab
                        id = "tabset1", height = "220px",
                        tabPanel("Programming Language",
                                 fluidRow(
                                 selectizeInput("languageStat",
                                                "Choose now or future",
                                                choice = c("LanguageWorkedWith","LanguageDesireNextYear"),
                                                selected = "LanguageWorkedWith"
                                 )
                                 ),
                                 # Again use conditional panel to show different bubble plot
                                 fluidRow(
                                   conditionalPanel(
                                     condition = "input.languageStat == 'LanguageWorkedWith'",
                                     bubblesOutput("LanguageChart1", width = "100%", height = 550)
                                     
                                   ), 
                                   conditionalPanel(
                                  
                                     condition = "input.languageStat == 'LanguageDesireNextYear'",
                                     bubblesOutput("LanguageChart2", width = "100%", height = 550)
                                     
                                     
                                   ) 

                                   
                                 )
                                 
                        ),
                        
                        tabPanel("Salaries! ",
                                 fluidRow(
                                  selectizeInput("factors2",
                                                  "Choose one factor",
                                                  choice = c("Gender", "FormalEducation","CompanySize"),
                                                  selected = "Gender"
                                   )
                                 ),
                                 fluidRow(
                                   box(
                                     width = 12, status = "info", solidHeader = TRUE,
                                     title = "Salary Distributions",
                                     column(12, plotlyOutput("salaryCharts", height = 500))
                                   )
                                 )
                                 
                                 ),
                        
                        
                        tabPanel("Satisfied with your job?",
                                 fluidRow(
                                 selectizeInput("factors",
                                                "Choose one factor",
                                                choice = c("--------", "Gender","SalaryRange", "CompanySize"),
                                                selected = "--------"
                                 )
                                 ),
                                 fluidRow(
                                   # For default the overall distribution of satisfaction score is shown
                                   conditionalPanel(
                                     condition = "input.factors == '--------'",
                                     box(
                                       width = 12, status = "info", solidHeader = TRUE,
                                       title = "Job Satisfaction Distribution",
                                       column(12, plotlyOutput("satisfactionChart1", height = 500))
                                     )
                                     
                                   ), 
                                   # Show the satisfaction distribution
                                   conditionalPanel(
                                     condition = "input.factors != '--------'",
                                     box(
                                       width = 12, status = "info", solidHeader = TRUE,
                                       title = "Job Satisfaction vs. Different Factors",
                                       column(12, plotOutput("satisfactionChart2", height = 700))
                                     )
                                     
                                   ) 
                                   
                                 )
                                 
                                 
                        ),
                        width = 12)
                    )
            ),
            
            tabItem(tabName = "lifeStyle",
                    fluidRow(
                      selectizeInput("attribute1",
                                     "Select an Attribute to Display",
                                     choice = c("SkipMeals","HoursComputer", "Exercise")
                      ),
                      selectizeInput("attribute2",
                                     "Select One More Attribute to Display",
                                     choice = c("--------","SkipMeals","HoursComputer", "Exercise")
                      )
                      
                    ),
                    
                    
                    fluidRow(
                      # for default, only one attribute is selected. Show the bar chart of different life style. 
                      conditionalPanel(
                        condition = "input.attribute2 =='--------'",
                        box(
                          width = 12, status = "info", solidHeader = TRUE,
                          title = "",
                          column(12, plotlyOutput("lifeStyleChart1", height = 500))
                        )
                        
                      ), 
                      # for two attributes, show the association plot. 
                      conditionalPanel(
                        condition = "input.attribute2 !='--------'",
                        
                        column(8, htmlOutput("tableName")),
                        
                        box(
                          width = 12, status = "info", solidHeader = TRUE,
                          title = "",
                          column(12, plotOutput("lifeStyleChart2", height = 700))
                        )
                      ) 
                    )
            ),
          # summary page
          tabItem(tabName = "summary01",
            fluidRow(
              column(7, htmlOutput("summText")),
                column(5,
                 img(
                   src = "https://pbs.twimg.com/media/DYGaYA3XcAAzVUu.jpg",
                   width = 400,
                   align = "right"
                 ),
                 img(
                   src = "https://i.pinimg.com/736x/ca/47/94/ca4794cfada458717c7aa99093a1f425--computer-humor-computer-science.jpg",
                   width = 400,
                   align = "right"
                 )
                 # img(
                 #   src = "https://i.pinimg.com/736x/ca/47/94/ca4794cfada458717c7aa99093a1f425--computer-humor-computer-science.jpg",
                 #   width = 400,
                 #   align = "right"
                 # )
                )
             )
          )
        )
    )
))