# ARU-Visualization

(https://prayagnshah.shinyapps.io/aru-visualization-dashboard/) - Link for the shiny application

## Deployment:

    - [Shiny Server](https://www.rstudio.com/products/shiny/shiny-server/)

## Packages:

    - [shiny](https://cran.r-project.org/web/packages/shiny/index.html)
    - [tidyverse](https://cran.r-project.org/web/packages/tidyverse/index.html)
    - [leaflet](https://cran.r-project.org/web/packages/leaflet/index.html)
    - [highcharter](https://cran.r-project.org/web/packages/highcharter/index.html)
    - [here](https://cran.r-project.org/web/packages/here/index.html)

## Explanation:

This is a Rshiny web application useful to analyze the data from the <b>ARU Recorders</b>. The data is stored in a [SQLite](https://www.datacamp.com/tutorial/sqlite-in-r) database. The application is deployed on a [Shiny Server](https://www.rstudio.com/products/shiny/shiny-server/). This application depicts the species data according to the location of the ARU recorders. The data is visualized in the form of a map and a bar chart. Species name on bar charts is arranged according to the taxonomy order of the species.
 
**Note:** The data may not be presented in a consistent format as more detailed information is shown upon request on the dashboard. Currently, the dashboard displays the work and demonstrates how I have integrated .css themes.