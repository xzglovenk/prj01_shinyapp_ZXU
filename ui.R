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
            menuItem("Introduction", tabName = "intro",icon = icon("intro")),
            menuItem("Respondent Profile", tabName = "profile", icon = icon("profile")),
            menuItem("About Work", tabName = "workstat", icon = icon("workstat")),
            menuItem("Life Style", tabName = "lifeStyle", icon = icon("lifeStyle"))

        )
 
    ),
    dashboardBody(
        tags$head(
            tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
        ),
###################################################        
        tabItems(
            tabItem(tabName = "intro",
                    fluidRow(
                      box(
                        tags$h1("Introduction"), 
                        tags$br(), 
                        tags$h3(tags$li("Stack Overflow is the home for programmers to share and learn.\n 
                        In January 2018, it conducted its annual survey and received ~100,000 responses.")),
                        tags$h3(tags$li("The survey is hight standardized so the response data set is mostly categorized. ")),
                        tags$h3(tags$li("The survey is hight standardized so the response data set is mostly categorized. ")),
                      width = 10))
              
            ),

            # 
            tabItem(tabName = "profile",
                    fluidRow(
                      selectizeInput("distribution1",
                                     "Distribution factor",
                                     choice = c("Country","Gender", "FormalEducation", "UndergradMajor", "YearsCoding"),
                                     selected = "Country"
                      )
                    ),
                    fluidRow(
                      box(
                        width = 10, status = "info", solidHeader = TRUE,
                        title = "Distribution by different catergory",
                        
                        
                        conditionalPanel(
                          
                          condition = "input.distribution1 =='Country'",
                          # uiOutput('chart')
                          box(
                            title = "Distributed by country",
                            width = 12,
                            htmlOutput("map01"),
                            bubblesOutput("distrChart1", width = "100%", height = 600)
                            
                          )
                        ),
                        
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
                      tabBox(
                        title = "Work Related",
                        # The id lets us use input$tabset1 on the server to find the current tab
                        id = "tabset1", height = "250px",
                        tabPanel("Programming Language",
                                 fluidRow(
                                 selectizeInput("languageStat",
                                                "Choose now or future",
                                                choice = c("LanguageWorkedWith","LanguageDesireNextYear"),
                                                selected = "LanguageWorkedWith"
                                 )
                                 ),
                                 fluidRow(
                                   conditionalPanel(
                                     condition = "input.languageStat == 'LanguageWorkedWith'",
                                     bubblesOutput("LanguageChart1", width = "100%", height = 600)
                                     
                                   ), 
                                   conditionalPanel(
                                  
                                     condition = "input.languageStat == 'LanguageDesireNextYear'",
                                     bubblesOutput("LanguageChart2", width = "100%", height = 600)
                                     
                                     
                                   ) 

                                   
                                 )
                                 
                        ),
                        tabPanel("Job Satisfaction",
                                 fluidRow(
                                 selectizeInput("factors",
                                                "Choose one factor",
                                                choice = c("--------", "Gender","SalaryRange", "CompanySize"),
                                                selected = "--------"
                                 )
                                 ),
                                 fluidRow(
                                   conditionalPanel(
                                     condition = "input.factors == '--------'",
                                     box(
                                       width = 12, status = "info", solidHeader = TRUE,
                                       title = "Job Satisfaction Distribution",
                                       column(12, plotlyOutput("satisfactionChart1", height = 500))
                                     )
                                     
                                   ), 
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
                      conditionalPanel(
                        condition = "input.attribute2 =='--------'",
                        box(
                          width = 12, status = "info", solidHeader = TRUE,
                          title = "Life Style",
                          column(12, plotlyOutput("lifeStyleChart1", height = 500))
                        )
                        
                      ), 
                      conditionalPanel(
                        condition = "input.attribute2 !='--------'",
                        box(
                          width = 12, status = "info", solidHeader = TRUE,
                          title = "Life Style",
                          column(12, plotOutput("lifeStyleChart2", height = 700))
                        )
                        
                      ) 
                      
                    )
                    
            )
 
        )
    )
))