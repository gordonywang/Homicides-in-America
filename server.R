library(ggplot2)
library(shiny)
library(shinydashboard)
library(shinythemes)
library(ggmap)
library(plotly)
library(flexdashboard)
library(tidyverse)
library(fiftystater)
library(rsconnect)
library(zoo)
library(dplyr)


######## Set up graph theme/data ############

homicides <- read.csv("homicide.csv")
idx.rm <- which(homicides$Year < 2000)
homicides <- homicides[-idx.rm,]


######## Clean data ############
change.vec = which(homicides$Victim.Age==998)
homicides$Victim.Age[change.vec] = NA

homicides$State = as.character(homicides$State)
change.ri = which(homicides$State == "Rhodes Island")
homicides$State = as.character(homicides$State)
homicides$State[change.ri] = as.character("Rhode Island")

homicides = na.omit(homicides)

homicides$Date = as.character(paste(homicides$Year, homicides$Month, sep = " "))
homicides$Date = as.Date(as.yearmon(homicides$Date,"%Y %B"))

######## Subsets of Data ############
blunt_object <- c(776, 200, 1476, 591, 10195, 974, 529, 154, 435, 4102, 1776, 394, 190, 2402, 1118, 336, 410, 763, 1394, 168, 1611, 683, 2709, 639, 580, 1271, 85, 206, 735, 134, 2165, 595, 5714, 2017, 53, 2342, 1151, 581, 2386, 184, 1258, 102, 1381, 6217, 350, 70, 1334, 1116, 361, 802, 122)

drowning <- c(13, 11, 36, 16, 240, 22, 8, 6, 8, 56, 26, 4, 3, 41, 15, 2, 2, 10, 47, 7, 25, 7, 40, 21, 16, 33, 2, 6, 15, 1, 28, 9, 27, 16, 2, 34, 24, 29, 64, 2, 11, 0, 11, 124, 5, 1, 25, 33, 6, 11, 3)

drugs <- c(1, 8, 55, 10, 180, 31, 24, 3, 2, 102, 23, 4, 6, 24, 18, 4, 9, 21, 24, 0, 30, 13, 71, 62, 5, 94, 1, 3, 0, 6, 41, 14, 16, 37, 2, 73, 27, 17, 92, 8, 23, 4, 42, 83, 25, 3, 64, 79, 32, 48, 4)

explosives <- c(3, 2, 6, 5, 50, 6, 6, 0, 0, 12, 8, 1, 1, 7, 7, 0, 7, 2, 5, 0, 7, 5, 52, 3, 3, 18, 0, 1, 5, 0, 14, 4, 45, 3, 0, 14, 158, 9, 18, 6, 1, 0, 5, 17, 5, 1, 3, 3, 4, 5, 0)

fall <- c(0, 2, 4, 0, 0, 1, 6, 1, 4, 4, 7, 8, 0, 17, 9, 0, 0, 0, 3, 1, 2, 4, 6, 3, 5, 5, 0, 3, 1, 0, 8, 0, 18, 5, 0, 5, 2, 11, 16, 1, 3, 0, 3, 11, 2, 1, 4, 2, 0, 0, 2)

fire <- c(24, 26, 71, 81, 624, 57, 112, 11, 34, 248, 129, 22, 12, 189, 159, 33, 26, 63, 115, 18, 143, 139, 399, 56, 43, 152, 0, 16, 46, 18, 329, 19, 723, 139, 2, 315, 103, 41, 456, 10, 129, 6, 117, 306, 17, 8, 131, 100, 71, 81, 4)

firearm <- c(96, 122, 639, 602, 4327, 505, 463, 140, 1433, 7105, 985, 23, 54, 1364, 1030, 127, 315, 337, 1066, 71, 186, 949, 4350, 40, 229, 3132, 24, 60, 483, 30, 409, 219, 2078, 111, 18, 1493, 188, 324, 1198, 231, 864, 24, 1391, 5165, 138, 22, 1938, 282, 152, 429, 19)

gun <- c(3, 7, 38, 32, 40, 44, 9, 2, 8, 22, 71, 1, 9, 44, 7, 13, 9, 14, 70, 0, 22, 16, 77, 5, 14, 118, 5, 1, 12, 3, 12, 5, 58, 837, 0, 58, 22, 52, 114, 1, 40, 0, 58, 108, 16, 0, 61, 24, 15, 8, 1)

handgun <- c(6352, 548, 7054, 3180, 55429, 2705, 2332, 444, 3853, 14213, 11900, 357, 418, 15492, 6036, 517, 1211, 3269, 12266, 233, 10906, 1890, 11657, 1628, 3684, 5536, 225, 527, 2525, 182, 6790, 1787, 26452, 9217, 69, 9204, 4167, 1419, 13302, 315, 5515, 95, 7255, 29843, 772, 120, 7101, 3331, 1203, 2730, 227)

knife <- c(1632, 243, 1629, 905, 14989, 1200, 847, 224, 1009, 4916, 2965, 294, 158, 3660, 1327, 344, 397, 779, 2243, 145, 2598, 1552, 3593, 775, 917, 1717, 101, 205, 793, 135, 2938, 772, 9347, 2859, 50, 2466, 1232, 712, 3377, 252, 1675, 80, 2015, 9656, 331, 63, 2102, 1366, 377, 911, 89)

poison <- c(4, 2, 3, 6, 77, 4, 3, 0, 4, 17, 6, 0, 8, 11, 9, 1, 2, 7, 8, 2, 7, 5, 23, 6, 3, 13, 2, 1, 3, 0, 14, 1, 44, 20, 1, 31, 12, 6, 24, 0, 5, 1, 9, 25, 0, 0, 10, 9, 3, 2, 0)

rifle <- c(393, 193, 611, 456, 4103, 239, 111, 33, 8, 1052, 654, 69, 118, 343, 429, 67, 145, 353, 734, 87, 278, 97, 1488, 183, 268, 624, 69, 83, 186, 41, 160, 261, 624, 1225, 29, 359, 561, 333, 690, 23, 533, 38, 558, 2713, 88, 60, 536, 437, 260, 279, 65)

shotgun <- c(1028, 95, 493, 598, 4731, 242, 146, 68, 41, 1072, 955, 46, 65, 590, 609, 137, 186, 517, 829, 70, 624, 132, 1871, 237, 458, 715, 32, 86, 192, 40, 331, 168, 1283, 1813, 31, 911, 624, 214, 842, 45, 973, 29, 994, 3864, 74, 27, 931, 337, 365, 285, 36)

strangulation <- c(26, 28, 174, 99, 1865, 89, 65, 10, 85, 191, 360, 26, 10, 431, 155, 13, 25, 47, 160, 26, 204, 129, 349, 82, 41, 228, 4, 23, 163, 6, 292, 51, 282, 94, 4, 209, 112, 179, 308, 26, 37, 7, 76, 798, 25, 8, 147, 227, 30, 72, 12)

suffocation <- c(8, 28, 90, 31, 760, 94, 47, 11, 38, 73, 88, 16, 17, 102, 48, 17, 35, 26, 67, 6, 91, 67, 151, 40, 31, 138, 10, 28, 50, 11, 112, 28, 176, 66, 4, 138, 61, 80, 208, 16, 94, 16, 71, 290, 31, 6, 114, 90, 13, 120, 15)

unknown <- c(1017, 102, 492, 335, 2533, 380, 188, 72, 153, 3979, 1135, 73, 81, 1154, 487, 138, 306, 346, 598, 35, 578, 348, 1612, 195, 249, 1038, 41, 82, 324, 48, 489, 339, 2381, 1931, 43, 1506, 364, 210, 1141, 91, 537, 40, 944, 2875, 154, 22, 1019, 379, 169, 408, 31)

state_weapons <- data.frame(State = unique(sort(tolower(homicides$State))), blunt_object = blunt_object, drowning = drowning, drugs = drugs, explosives = explosives, fall = fall, fire = fire, firearm = firearm, gun = gun, handgun = handgun, knife = knife, poison = poison, rifle = rifle, shotgun = shotgun, strangulation = strangulation, suffocation = suffocation, unknown = unknown)

state_data <- data.frame(fifty_states)
state_data <- state_data %>%
  left_join(state_weapons, by = c("id" = "State"))

df.by.state.count <- homicides %>%
  group_by(State) %>%
  dplyr::summarize(state.count = n())

df.by.state.count$State = tolower(df.by.state.count$State)
df.by.state.count = left_join(fifty_states, df.by.state.count, by = c("id" = "State"))

num.solved = rep(0, 51)
states = unique(homicides$State)
for (i in 1:51) {
  num.solved[i] = sum(homicides[homicides$State == states[i], ]$Crime.Solved == "Yes")
}

solved = homicides[homicides$Crime.Solved == "Yes", ]

######## Shiny server ############
shinyServer(function(input, output) {
  
  
  ### Homicide Map Count ###
  output$total_homicide_map <- renderPlotly({
    
    map_homicide <- ggplot(df.by.state.count) +
      geom_polygon(aes(x = long, y = lat, fill = state.count, group = group), color = "black") + 
      scale_fill_gradient(low = "slategray2",
                          high = "midnightblue") +
      theme_void() +
      coord_map("polyconic") + 
      labs(title = "Homicide Frequency in US", fill = "Number of Homicides")
    
    ggplotly(map_homicide)
    
    
  })

  
  
  
  ### Homicides Per Year/Month ###
    output$monthly_time_series <- renderPlot({
      
      # Create new data frame that summarizes number of homicides per month for specified year
      by.Year <- homicides[homicides$Year == input$which_year,] %>%
        group_by(Date) %>%
        summarize(Homicide_Count = n())
      
      time_homicide <- ggplot(by.Year, aes(x = Date, y = Homicide_Count)) + geom_line() + 
        scale_x_date(date_breaks = '1 month', date_labels = '%b') + 
        labs(title = 'Number of US Homicides Per Month',
             caption = 'Source: Murder Accountability Project',
             x = 'Months',
             y = 'Number of Homicides')
      
      time_homicide
    
  })
  
  
  
  
  ### Age Distribution ###
    output$age_plot <- renderPlot({
      age_dist <- ggplot(homicides, aes_string(x = input$which_group)) + 
        geom_histogram(aes(y = ..density..), bins = as.numeric(input$n_breaks),
                       col = "black") + 
        geom_density(aes(y = ..density..), adjust = input$bw_adjust, col = "blue") + 
        labs(title = paste("", input$which_group, ""), x = "Age",
             y = "Density", caption = "Source: Homicide Data")
      
      if(input$rug_plot) {
        age_dist <- age_dist + geom_rug()
      }
      
      age_dist
  })
  
  
  
  
  ### Age Scatterplot ###
    output$age_scatterplot <- renderPlotly({
      
      age_scatterplot <- ggplot(homicides, aes(x = Victim.Age, y = Perpetrator.Age)) + 
        geom_point(aes(col = Victim.Sex), size = input$point_size) + 
        geom_smooth(method = "lm", se = input$show_conf) +
        labs(title = 'Relationship Between Victim and Perpetrator Ages',
             caption = 'Source: Murder Accountability Project',
             x = 'Victim Age',
             y = 'Perpetrator age')
      
      ggplotly(age_scatterplot)
      
  })
  
  
  
  ### Relationship btwn Perp and Victim ###
    output$relation_time_series <- renderPlot({
      
      # Create data frame summarizing homicides per year for specified relationship 
      by.relationship <- homicides[homicides$Relationship == input$which_relationship,] %>%
        group_by(Year) %>%
        summarize(Homicides = n())
      
      relation <- ggplot(by.relationship, aes(x = Year, y = Homicides)) + geom_line() + 
        scale_x_continuous(breaks = seq(2000, 2014, 1)) +
        theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
        labs(title = 'US Homicides By Relationship From 2000-2014',
             caption = 'Source: Murder Accountability Project',
             x = 'Years',
             y = 'Number of Homicides')
      
      relation
  })
  

  ### Gender and Race of Perp and Victim ###
    output$bar_plot1 <- renderPlot({
      ## PUT YOUR GGPLOT CODE HERE ##
      gen_race <- ggplot(homicides, aes_string(x = input$which_race)) + 
        geom_bar(fill = "darkslategray4") + facet_wrap(c(input$which_facet)) + 
        labs(title = paste("Count of", input$which_race, "Based on",
                           input$which_facet), x = "Race", y = "Frequency",
             caption = "Source: Kaggle") + 
        theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 11))
      
      gen_race
    
  })
  
  ### Map of Weapons ###  
    output$map_weapon <- renderPlot({
      ## PUT YOUR GGPLOT CODE HERE ##
      weapon_map <- ggplot(state_data, aes(map_id = id)) + 
        geom_map(aes_string(fill = input$which_variable), color = "black", 
                 map = state_data) +
        scale_fill_gradient(low = "slategray2", high = "midnightblue") +
        expand_limits(x = state_data$long, y = state_data$lat) + coord_map() +
        scale_x_continuous(breaks = NULL) + scale_y_continuous(breaks = NULL) +
        labs(title = "Distribution Of Homicides Based on Weapon Type", x = "",
             y = "", fill = "Number of Homicides", caption = "Source: Kaggle")
      
      weapon_map
  })
      
 
  ### Crimes Solved###
    output$barPlot <- renderPlot({
      solved.by.agency = solved[solved$Agency.Type == input$agency, ]
      
      crime_solved <- ggplot(solved.by.agency) + 
        geom_bar(aes(x = State)) + 
        labs(title = 'Number of Crimes Solved by State',
             caption = 'Source: Murder Accountability Project',
             x = 'State',
             y = 'Count') +
        theme(axis.text.x = element_text(angle=45, hjust=1))
      
      crime_solved
  })
  
  
})




