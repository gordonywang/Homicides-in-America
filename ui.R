library("shinydashboard")
library(shinythemes)

shinyUI(bootstrapPage(theme = shinytheme("united"), 
  
  
  dashboardPage(skin = "blue",
                
    dashboardHeader(title = "Homicides in America"),
    
    dashboardSidebar(
      width = 355,
      sidebarMenu(
          menuItem("Frequency of Homicides in the US", tabName = "intro", 
                   icon = icon("cog")), 
          menuItem("Homicides by Year", tabName = "Year", icon = icon("cog")),
          menuItem("Distribution of Ages", tabName = "Ages", icon = icon("cog")),
          menuItem("Relationship Between Victim & Perpetrator Ages", 
                   tabName = "ageRelationship", icon = icon("cog")),
          menuItem("Relationship Between Victim & Perpetrator", 
                   tabName = "Relationship", icon = icon("cog")),
          menuItem("Role of Gender and Race", tabName = "attributes", 
                   icon = icon("cog")),
          menuItem("Weapon Used", tabName = "weapon", icon = icon("cog")),
          menuItem("Who Solved the Most Homocides", tabName = "solved", 
                   icon = icon("cog"))
          )
      ),
    
    dashboardBody(
      tabItems(
        tabItem(tabName = "intro",
            
            plotlyOutput(outputId = "total_homicide_map", height = "500px")
            
        ), 

        
        tabItem(tabName = "Year", 
                selectInput("which_year", label = "Year Selection:",
                                                 choices = seq(2000, 2014, by = 1), selected = 2000),
                plotOutput(outputId = "monthly_time_series", height = "500px")
                ),
        
        
        tabItem(tabName = "Ages",
                selectInput("n_breaks", label = "Number of bins:",
                            choices = c(5, 10, 15, 20, 25, 30), selected = 10),
                
                sliderInput("bw_adjust", label = "Bandwidth adjustment:",
                            min = 0.2, max = 2, value = 1, step = 0.2),
                
                radioButtons("which_group", label = "Which Variable?",
                             choices = c("Victim" = "Victim.Age",
                                         "Perpetrator" = "Perpetrator.Age")),
                
                checkboxInput("rug_plot", label = "Show Rug Plot"),
                
                plotOutput(outputId = "age_plot", height = "600px")
                ),
        
        tabItem(tabName = "ageRelationship",
                sliderInput("point_size", label = "Point size:",
                            min = 0.5, max = 3, value = 1, step = 0.5),
                checkboxInput("show_conf", label = "Include confidence band"),
                
                plotlyOutput(outputId = "age_scatterplot", height = "500px")
                ),
        
        
        tabItem(tabName = "Relationship",
                selectInput("which_relationship", 
                            label = "Relationship between Victim and Perpetrator:",
                            choices = unique(homicides$Relationship), 
                            selected = "Acquaintance"),
                plotOutput(outputId = "relation_time_series", height = "600px")
                ),
        
        
        tabItem(tabName = "attributes",
                selectInput("which_race", label = "Which Group's Race?",
                            choices = list("Races of Perpetrators" = "Perpetrator.Race", "Races of Victims" = "Victim.Race")),
                
                radioButtons("which_facet", label = "Which Group's Gender?",
                             choices = c("Gender of Perpetrators" = "Perpetrator.Sex",
                                         "Gender of Victims" = "Victim.Sex")),
                plotOutput(outputId = "bar_plot1", height = "500px")
                ),
        
        
        tabItem(tabName = "weapon",
                selectInput("which_variable", label = "Weapon Type",
                            choices = list("Blunt Object" = "blunt_object", 
                                           "Drowning" = "drowning", 
                                           "Drugs" = "drugs",
                                           "Explosives" = "explosives", 
                                           "Fall" = "fall", 
                                           "Fire" = "fire", 
                                           "Firearm" = "firearm", 
                                           "Gun" = "gun", 
                                           "Handgun" = "handgun", 
                                           "Knife" = "knife", 
                                           "Poison" = "poison", 
                                           "Rifle" = "rifle", 
                                           "Shotgun" = "shotgun", 
                                           "Strangulation" = "strangulation",
                                           "Suffocation" = "suffocation",
                                           "Unknown" = "unknown")),
                
                plotOutput(outputId = "map_weapon", height = "500px")
                ),
        
        tabItem(tabName = "solved",
                selectInput("agency", 
                            label = "Select Agency",
                            choices = list("Municipal Police",
                                           "County Police",
                                           "State Police",
                                           "Sheriff", 
                                           "Special Police",
                                           "Regional Police",
                                           "Tribal Police"),
                            selected = "Municipal Police"),
                
                plotOutput(outputId = "barPlot", height = "500px"))
        
      )
    )
  )

))   


