# PS6

## Here is my ps6 link:
### https://katyye.shinyapps.io/PS6_katyye/

## Description of Data:
The data is about lower troposphere from UAH. The data set contains the columns "year","month","region", and "temp".

## Description of App:
Use tabsetPanel() to set three sets of pages: opening page(About) which displays the general information about the dataset, plot page(Plots) which dispalys a plot with some widgets, and Table page(Tables) which dispalys a table with some widgets

### page "About":
Summarize the general information about the dataset which contains some HTML text formatting makers. The table shows 5 random datas from dataset. 

### page "Plots":
The control widgets I used are "Single checkbox","Radio Buttons" ,and "Checkbox group"
##### sidebarPanel:
    "Single checkbox" (Display trends): choose whether you want to see the trends in the graph
    "Radio Buttons" (Choose a palette): choose the color palette of the graph dots
    "Checkbox group" (select the region(s) to display): select the region(s) to display
##### mainPanel:
    The plot is scatterplot and corresponding trend lines that related what you relected.
    The text shows how many observations include in your selected region(s).

### page "Tables":
The control widget I used is "Radio Buttons".
##### sidebarPanel:
    "Radio Buttons"(Average over): you can choose to see the average temperature over "month","year", or "decade".
##### mainPanel:
    The text shows the temperature range from lowest to highest depending on the avarage range you choose. 
    The table shows the average temparature depending on the average range you choose in the sidebarPanel. 

#### I used one whole day to finish this assignment. 