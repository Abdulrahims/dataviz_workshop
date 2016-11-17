# Let's play with aRound with R!
# A hashtag means this line of code is a comment. 
# The R console won't run any line with a hashtag

# Behold, we can do math
2 + 2
3 * 3

# Ok, that's enough math

# I mentioned a few data types, remember those?

# Vectors:
x <- c(1,7,3,8)

# Assignment operator: <- assigns a value to a variable
# You can also use a plain old equal sign =
# c() is just a way of grouping the elements together

# How do we access the first element?
x[1]
# Second element?
x[2]
# You get the point

#Factors:
# Start with a vector.
celebrities <- c('joe biden','kanye','obama','bernie sanders','harambe')

# Create the factor object.
factor_celebs <- factor(celebrities)

print(factor_celebs)

# The first line is simply printing out the elements in the vector
# The Levels line prints the distinct values in vector

# These will print the same value because each element in the vector is unique
print(nlevels(factor_celebs))
print(length(celebrities))

# Dataframes: 
# But first, we need da data

# A wild package has appeared. What do you do?
# A package is a set of instructions and commands written by someone else
# It makes using R a whole lot easier

install.packages("RCurl")

# Use the library() command to let R know that you will be using this package
# RCurl, I choose you!
library(RCurl)   

# getURL() is a function from RCurl. Let's get the url from my Github and assign it to the variable "url"
url <- getURL("https://raw.githubusercontent.com/Abdulrahims/dataviz_workshop/master/pokemon.csv")

# Now we can use the read.csv() function and assign to the variable "pokedata"
pokedata <- read.csv(text = url)

# So is pokedata a data frame? Let's check!
# The class() function is one of R's many built-in functions
# It returns the abstract type of a given variable

class(pokedata)
class(x)
class(celebrities)

# It is! Click on pokedata under the "Data" tab in the environment window to view the data
# So what can we do with a data frame?

# We can use the built-in head() function to get a sneak peek at the first couple elements of the data
head(pokedata)

# And the tail() function (also built-in) to look at the last couple elements 
tail(pokedata)

# Summary statistics of the dataframe
summary(pokedata)

# A look at all the columns
names(pokedata)

# Accessing specific columns
pokedata$Pokémon #by name
pokedata[1] #by column number

# Ok, let's start with some basic plots in base R:

# Histogram
# Used to show the frequency distribution of data in groups called bins/breaks

hist(pokedata$HP)
hist(pokedata$Attack, breaks = 10)
hist(pokedata$Defense, main = "Defense Distribution of Pokemon")

# Bargraph 

barplot(pokedata$Attack)

# Could use some color

install.packages("RColorBrewer")
library(RColorBrewer)

barplot(pokedata$Attack,col  = brewer.pal(3,"Set2"))

# This doesn't really tell us much

# Let's try a scatterplot to look at the relationship between variables

plot(x = pokedata$Speed, y = pokedata$Defense)
plot(x = pokedata$Defense, y = pokedata$Attack)

# Scatterplot matrix! 
plot(pokedata[2:5],col=brewer.pal(3,"Set1"))

# Base plots are alright, but lets step it up a notch

# A wild ggplot has appeared!

install.packages("ggplot2")
#install.packages("lazyeval") #may need this if running a newer version of R
library(ggplot2)

# Advantages of ggplot2
# Flexible
# Customizable 
# Strong user base and great documentation
# Better than any viz package in Python I guarantee you

# Let's do a histogram, this time with ggplot
ggplot(pokedata, aes(x = Attack)) + geom_histogram(binwidth = 2)

# aes() is short for aesthetic and means "something you can see". Also used for:
# position (i.e., on the x and y axes)
# color ("outside" color)
# fill ("inside" color)
# shape (of points)
# linetype
# size

# geom_historgram is what is known as a geometric object. Other geometric objects include:
# geom_point (scatterplots)
# geom_line (line graphs, time series)
# geom_boxplot (you know, boxplots)

# Let's try a scatterplot, this time with ggplot
ggplot(pokedata, aes(y = Defense, x = Attack)) + geom_point() 

# We can even add the names of the Pokémon as labels on the plot
ggplot(pokedata, aes(y = Defense, x = Attack)) + geom_point() + 
  geom_text(aes(label=Pokémon), size = 3)

# That's a lot of pokemon and a bit messy, so lets try this

# Before we start building more plots, let's take a subset of the pokedata
# There are 151 pokemon in Generation I. We won't graph 'em all

install.packages("dplyr")
library(dplyr)

# The sample_n() function comes from the dplyr package
# Let's take a random sample of 10 pokemon and assign it to a new variable, pokesample
pokesample <- sample_n(pokedata,20)

# pokesample will automatically be a data frame
class(pokesample)

# Now lets try the same scatter plot
ggplot(pokesample, aes(y = Defense, x = Attack)) + geom_point() + 
  geom_text(aes(label=Pokémon), size = 3)

# We can customize the plot in many ways
p1 <- ggplot(pokesample, aes(Attack, HP)) +
  geom_point(aes(color = Pokémon)) +
  geom_smooth(se = FALSE, method = "loess") 
p1

# We can also save the plot itself as an object of the class "ggplot"
# This makes it easier to add more to the plot later on, so that we don't have to repeat code

# Like so
p1 +   labs(
  title = "Relationship between Pokémon Attack and HP",
  subtitle = "There is a positive correlation between a Pokémon's attack and HP",
  caption = "Data from Bulbapedia, the community driven Pokémon encyclopedia"
)

# Let's step it up a notch

# Heatmaps!
# Matrix visualization of data in cells

# But first, we'll have to reshape our data a bit to get the plot we want
# Wow, a reshpe package. Very convenient

install.packages("reshape2")
library(reshape2)

# Let's get rid of these 3 columns cause why not
pokesample$Total <- NULL
pokesample$Average <- NULL
pokesample$Special <- NULL

# Now we make a new "melted" data frame
pokesample.melted <- melt(pokesample)

# Let's check out the first few elements to see what we changed
head(pokesample.melted)

my_palette <- colorRampPalette(c("white", "blue", "purple"))(n = nrow(200))

ggplot(pokesample.melted, aes(x = variable, y = Pokémon, fill = value)) + geom_tile() +
  scale_fill_gradientn(colours = my_palette)

# Lastly, some HTML widgets

# Datatables: A cool way to look at your data
install.packages("DT")
library(DT)

datatable(pokedata, options = list(pageLength = 10))

# Interactive scatterplots!

install.packages("metricsgraphics")
library(metricsgraphics)

mjs_plot(pokesample, x=Attack, y=HP) %>%
  mjs_point(color_accessor=HP, size_accessor=Attack) %>%
  mjs_labs(x="Pokémon Attack", y="Pokémon HP")

