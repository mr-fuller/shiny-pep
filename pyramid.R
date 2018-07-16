library(censusapi)
library(plotly)
library(tidyverse)

#api key set in .Renviron file
#plotly username and api key also set in .Renviron file
#api_key = "b7da053b9e664586b9e559dba9e73780602f0aab"

vintage = 2017
name = "pep/charagegroups"
vars <- listCensusMetadata(name=name,vintage = vintage, type="variables")
regions  <-  c("39095", "39173", "26115", "39123", "39143")
#regions  <-  c("39095")
#pyramidestimate <- tibble()
temp <- tibble()
for (i in regions){
  temp <- as_tibble(getCensus(name=name,
                              vintage = vintage,
                              vars = vars$name,
                              region = paste("county:",substr(i,3,5)),
                              regionin = paste("state:",substr(i,1,2))
                              ))
  temp$AGEGROUP <- as.numeric(temp$AGEGROUP)
  #ages <- c()
  #temp$AGEGROUP <- factor(temp$AGEGROUP,levels=ages)
  temp$POP <- as.numeric(temp$POP)
  #note that for sexes, 0=both, 1=male, 2=female
  temp <-  temp %>%  #male pop negative, female positive
    filter(SEX != 0 & AGEGROUP < 19 & AGEGROUP > 0 & 
             DATE_DESC == "7/1/2017 population estimate") %>%
    mutate(group_est = ifelse(SEX == '1',-POP,POP),
         SEX = ifelse(SEX == '1','Male','Female')) %>%
    arrange(state,county,SEX,HISP,RACE)
    #mutate(AGEGROUP = ifelse(AGEGROUP))
   temp$AGEGROUP <- recode_factor(temp$AGEGROUP,
    '1'="Under 5",'2'="5-9",'3'="10-14",'4'="15-19",'5'="20-24", '6'="25-29",
    '7'="30-34",'8'="35-39",'9'="40-44",'10'="45-49",'11'="50-54",'12'="55-59",
    '13'="60-64",'14'="65-69",'15'="70-74",'16'="75-79",'17'="80-84",'18'="85+")

           
#View(temp)
  pyramid <- plot_ly(temp, x= temp$group_est,y = temp$AGEGROUP,color = temp$SEX, type = 'bar',
                     orientation = 'h', colors = c('green','purple'),
                     hoverinfo = 'text+name',text = temp$POP)%>%
    layout(bargap = 0.1, barmode = 'overlay', title = i,
           #annotations = list(x = -5, y = 17,text = "Total Population: 110",showarrow = FALSE),
           xaxis = list(title = "Population 2017"),
           yaxis = list(title = "Age"))
  #pyramidestimate <- rbind(pyramidestimate,temp)
#pyramid
  api_create(x = pyramid,filename = i, fileopt = "overwrite", sharing = "public")
}
