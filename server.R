library(DT)
library(shiny)
library(googleVis)
library(dplyr)
library(ggplot2)


shinyServer(function(input, output){

 ##################################
  output$map01 <- renderGvis({
    
    survey_data %>% group_by(.,Country) %>% tally() -> survey_country
    
    gvisexample <- gvisGeoChart(survey_country, "Country", "n", 
                                options=list(width=800, height=600))
  })
  
    output$distrChart1 <-renderBubbles({
      
      #show bubble chart for country distribution
      countrydata <- survey_data%>%
        group_by(Country) %>%
        tally() %>%
        arrange(desc(n), tolower(Country)) %>%
        # Just show the top 30, otherwise it gets hard to see
        head(30)
      
      bubbles(countrydata$n, countrydata$Country, 
              key = countrydata$Country, 
              color = rainbow(10, alpha = NULL),
              tooltip = countrydata$n)
      
      
    })
    
 
    output$distrChart2 <-renderPlotly({
      temp_svydata01 = survey_data%>%
        group_by_(.,input$distribution1) %>% 
        summarise(.,count = n())%>%
        arrange(desc(count))

      print(
        ggplotly(
          ggplot(temp_svydata01,aes_string(x = paste0("reorder(",input$distribution1,", count)"), y = "count")) + 
            geom_bar(stat = 'identity') + coord_flip() + 
            theme_economist() + scale_fill_economist() + xlab(input$distribution1)+ylab("Count of Respondents")+
            theme(text = element_text(size=14), plot.title = element_text(size = 24), axis.title.x = element_text(size = 16),axis.title.y = element_text(size = 16))+
            ggtitle(paste0("Distribution by ", input$distribution1)), subtitle = NULL)
            
             

        )
      
    })

#################################################################
    output$LanguageChart1 <-renderBubbles({

      #show bubble chart for country distribution
      languageData1 <- survey_data%>% 
        select(.,LanguageWorkedWith) %>% 
        mutate(singleLanguage = str_split(LanguageWorkedWith, pattern = ";")) %>% 
        unnest(singleLanguage) %>%
        group_by(singleLanguage) %>%
        tally() %>%
        arrange(desc(n)) %>%
        # Just show the top 20, otherwise it gets hard to see
        head(20)

      bubbles(languageData1$n, languageData1$singleLanguage,
              key = languageData1$singleLanguage,
              color = rainbow(10, alpha = NULL),
              tooltip = languageData1$n)


    })
    
    output$LanguageChart2 <-renderBubbles({
      
      #show bubble chart for country distribution
      languageData2 <- survey_data%>% 
        select(.,LanguageDesireNextYear) %>% 
        mutate(singleLanguage = str_split(LanguageDesireNextYear, pattern = ";")) %>% 
        unnest(singleLanguage) %>%
        group_by(singleLanguage) %>%
        tally() %>%
        arrange(desc(n)) %>%
        # Just show the top 20, otherwise it gets hard to see
        head(20)
      
      bubbles(languageData2$n, languageData2$singleLanguage,
              key = languageData2$singleLanguage,
              color = rainbow(10, alpha = NULL),
              tooltip = languageData2$n)
      
      
    })
    
    
    
#################################################################
    
    output$satisfactionChart1 <- renderPlotly({
      temp01_usa = survey_data %>% filter(.,Country == "United States")
      # if the second attributes is empty, only one attribute will be drawn in bar chart. 
      print(
        ggplotly(
          
          ggplot(temp01_usa, aes(x = JobSatisfaction)) + geom_bar() + coord_flip() + theme_economist() + scale_fill_economist() + xlab("Job Satisfaction Score")+ylab("Count of Respondents")+
            theme(text = element_text(size=14), plot.title = element_text(size = 24), axis.title.x = element_text(size = 16),axis.title.y = element_text(size = 16))+ggtitle(paste0("Statistics on Job Satisfaction"), subtitle = NULL)
          
        )
      )
    })
    
    output$satisfactionChart2 <- renderPlot({
      #  if given two attributes a mosaic plot will be generated.  
      #  first step make a contengincy table for the two attributes 
      temp02_usa = survey_data %>% filter(.,Country == "United States")
      tbl_2d = table(temp02_usa[,input$factors, drop = T], temp02_usa[,"JobSatisfaction", drop = T])
      #  second step generate the mosaicplot. 
      #mosaicplot(tbl_2d, shade = TRUE)
      assocplot(tbl_2d, xlab = input$factors, ylab = "JobSatisfaction")
    })  
    
    
#################################################################
    output$lifeStyleChart1 <- renderPlotly({
      # if the second attributes is empty, only one attribute will be drawn in bar chart. 
      print(
        ggplotly(
          
          ggplot(survey_data,aes_string(x = input$attribute1)) + geom_bar() + coord_flip()+theme_economist() + scale_fill_economist() + xlab(input$attribute1)+ylab("Count of Respondents")+
            theme(text = element_text(size=14), plot.title = element_text(size = 24), axis.title.x = element_text(size = 16),axis.title.y = element_text(size = 16))+ggtitle(paste0("Statistics on ", input$attribute1), subtitle = NULL)
          
          
        )
      )
    })
    
    output$lifeStyleChart2 <- renderPlot({
      #  if given two attributes a mosaic plot will be generated.  
      #  first step make a contengincy table for the two attributes 
      tbl_2d = table(survey_data[,input$attribute1, drop = T],survey_data[,input$attribute2, drop = T])
      #  second step generate the mosaicplot. 
      #mosaicplot(tbl_2d, shade = TRUE)
      assocplot(tbl_2d, xlab = input$attribute1, ylab = input$attribute2)
    })
}    
)