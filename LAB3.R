#1. First read in the three csv files: gdppercapitaandgini and airpollution

#Both datasets are from Our World in Data: ourworldindata.org
#The GDP dataset has GDP per capita and the GINI index (a measure of income inequality: https://en.wikipedia.org/wiki/Gini_coefficient)
#The air pollution dataset has death rates from indoor and outdoor air pollution - units are in deaths per 100,000 people
#Indoor air pollution is the Household Air Pollution from Solid Fules
#Outdoor air pollution is split into particulate matter and ozone

#Hint: The column names are long and cumbersome (because they contain information about units et) - you might want to rename some of the columns to make them easier to work with

air <- read.csv("desktop/airpollution.csv", header = TRUE)
gdp <- read.csv("desktop/gdppercapiandgini.csv", header = TRUE)


#2. Chose two countries that you are interested in and make a plot showing the death rates from indoor air pollution and outdoor air pollution (sum of particulate matter and ozone) over time
#Distinguish the countries using different colored lines and the types of pollution using different line types
#Make sure to add a legend and appropriate titles for the axes and plot 

#Hint: you can see all the different country names using unique(x$Entity) where x is the data frame containing the air pollution data
#Then create two new data frames that countain only the rows corresponding to each of the two countries you want to look at
#Create a new column of total outdoor air pollution deaths by summing death rates from particulate matter and ozone
#Use these to make your plot and add the lines you need

colnames(air)[1:7] = c('country', 'code', 'year', 'partmatter', 'indoorair', 'ozone', 'airpollution')
colnames(gdp)[1:7] = c('country', 'code', 'year', 'totpop', 'continent', 'ginicoeff', 'gdppercapita')
air$outdoor <- air$partmatter+air$ozone

sweden <- subset(air, country == 'Sweden')
US <- subset(air, country == 'United States')

plot(x = sweden$year, y = sweden$`indoorair`, type = 'l',  
     main = "Number of Deaths from \n Indoor and Outdoor Pollution Over Time", 
     ylab = "Deaths", xlab = "Years", col = "red", ylim = c(0, 40))
  lines(US$year, US$indoorair, col = "blue")
  lines(US$year, US$outdoor, col = "blue", lty = 5)
  lines(sweden$year, sweden$outdoor, col = "red", lty = 5)


#3. Merge the air pollution data with the gdp data using merge()
# Merge is a function that combines data across two data frames by matching ID rows
#By default merge will identify ID rows as those where column names are the same between datasets, but it is safer to specify the columns you want to merge by yourself using "by"
#In our case, we want to merge both by country (either the "Entity" or "Code" columns) and year columns
#Note that by default, the merge function keeps only the entries that appear in both data frames - that is fine for this lab. If you need for other applications, you can change using the all.x or all.y arguments to the function - check out the documentation at ?merge

m <- merge(gdp, air, by.x = "code", by.y = "year", all = TRUE)

#4. Make a plot with two subplots - one showing a scatter plot between log of per-capita GDP (x axis) 
# and indoor air pollution death rate (y axis) and one showing log of per-capita GDP (x axis) and outdoor 
# air pollution (y axis)
# Make sure to add appropraite titles to the plots and axes
# Use ylim to keep the range of the y axis the same between the two plots - this makes it easier for the 
# reader to compare across the two graphs
# STRECTH GOAL CHALLENGE - color the points based on continent. NOT REQUIRED FOR FULL POINTS - a challenge if you want to push yourself - continent info is included in the GDP dataset, but it is only listed for the year 2015
# If you are trying this and getting stuck ASK FOR HELP - there are some tips and tricks for making it easier 
plot(log(m$gdppercapita), m$indoorair, main="Per Capita GDP Versus Death from Indoor Air Pollution",
     xlab="Log Per Capita GDP ", ylab="Indoor Air Pollution Death Rates", pch= ".")
points(log(m$gdppercapita), m$outdoor, pch= ".", col = "purple")

