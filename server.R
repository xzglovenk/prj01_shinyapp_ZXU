library(DT)
library(shiny)
library(googleVis)
library(dplyr)
library(ggplot2)


shinyServer(function(input, output){

 ##################################

  output$introText <- renderText({
    "<h1> Introduction\n </h1>
    <br>
    <h3>
      <li> Stack Overflow is the home for programmers to share and learn.</li></h3> 
      
    <h3>
      <li> Every year they conduct a suvery of their site visitors, giving us the opportunity to learn more about the programmer community. 
      </li>
    </h3>
    <h3>
      <li> I analyzed a subset of the 2018 survey and trying to get some insights from it, here is something I want to figure out:
    </h3>
    <br>
      <h3><ul><li> What are the distributions of the respondents acorss countries, genders, education backgrouds...
        </li>
        <br>
        <li> What are their favorite languages? How do they like their jobs?
        </li>
        <br>
        <li> Programmers' life can be busy. Do they live a healthy life? 
        </li></ul>
      </li></h3>"
  })
 
############################################################# 
    # generate a gvis map object for the country statistics. 
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
    
    # Generate bar charts for different attributes (eg. gender, education, undergraduate major, etc.)
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

      #show bubble chart for distribution of language people are using right now
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
      
      #show bubble chart for the distribution of language people want to learn next year
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
    output$salaryCharts <- renderPlotly({
      temp01_usa = survey_data %>% filter(.,Country == "United States")
      # if the second attributes is empty, only one attribute will be drawn in bar chart. 
      print(
        ggplotly(
          
          ggplot(temp01_usa, aes_string(x = input$factors2, y = "ConvertedSalary")) + geom_boxplot() + scale_y_log10(limits = c(5000, 1000000)) + theme_economist() + scale_fill_economist() + xlab(input$factors2)+ylab("Salary in log10 scale")+
            theme(text = element_text(size=14), plot.title = element_text(size = 24), axis.title.x = element_text(size = 16),axis.title.y = element_text(size = 16))+ggtitle(paste0("Salary vs. ",input$factors2), subtitle = NULL)
        )
      )
    })  
#################################################################
    
    output$satisfactionChart1 <- renderPlotly({
      temp01_usa = survey_data %>% filter(.,Country == "United States")
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
      #  second step generate the assocplot. 
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
    
    output$tableName <- renderText({
      paste("                                               ","<h3>", input$attribute2, "vs. ", input$attribute1, "</h3>")
    })
    
    output$lifeStyleChart2 <- renderPlot({
      #  if given two attributes a mosaic plot will be generated.  
      #  first step make a contengincy table for the two attributes 
      tbl_2d = table(survey_data[,input$attribute1, drop = T],survey_data[,input$attribute2, drop = T])
      #  second step generate the mosaicplot. 
      #mosaicplot(tbl_2d, shade = TRUE)
      assocplot(tbl_2d, xlab = input$attribute1, ylab = input$attribute2)
    })
    
    output$summText <- renderText({
      "<h1> Summary\n </h1>
      <br>
      <h3><li> The developer community is booming, considerable gender gap still exists. 
      </li>
      </h3>
      <h3><li> Learn python, learn python and learn python. 
      </li>
      </h3>
      <h3><li> Consider company size when choosing jobs.
      </li>
      <h3>
      <h3><li> Live a healthy life!
      </li>
      </h3>
      <h3><li> Happy coding!
      </li>
      </h3>
      "
  })
}    
)