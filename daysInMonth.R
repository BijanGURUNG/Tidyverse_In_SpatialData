# Count the number of days in each month from the Spatial data based on the data type. 
# Or count the days in a month when observation was carried  out.

install.packages("foreign")
library(foreign)
install.packages("tidyverse")
library(tidyverse)

# Export the shapefile to dbf format in ArcGIS Pro and r can easily read the .dbf file.
df <- read.dbf("D:/olym/Tidyverse_In_SpatialData/OLYM_SummaryWaypoints.dbf", as.is = FALSE)

glimpse(df)

head(df)

# Closely observe the variables or fields that can be used to calculate the total number of days in the spatial data.
# We choose only two variables - TIME and flight_id
# We used mutate_at before, but funs() of mutate_at was deprecated. So, we have to use select() to pick the required columns.
df1 <- df %>% select(TIME, flight_id)

# Have to change the columns to characters because TIME is in date format and flight_id as factor.
# TIME is in the format 2021-07-29
df1 <- data.frame(lapply(df1, as.character), stringsAsFactors=FALSE)

glimpse(df1)

# Now, time is in the format '2021-07-29'.
# Need to separate the variable TIME. We will get '2021', '07' and '29' - all as characters
df1 <- df1 %>% separate(TIME, c('Year', 'Month', 'Day'))

glimpse(df1)

head(df1)

# Combine or concatenate Year and Month, using "-" in between them. We will get '2021-07' as character. 
df1 <- df1 %>% unite(YearMonth, Year, Month, sep = "-")

glimpse(df1)

head(df1)

# Apply group_by with YearMonth as each YearMonth is unique, and count the 'Day' within each group by n_distinct.
# Distinct Days are counted within that Month-Year and thus gives the total days month-wise.
# Days when the data was obtained in the shapefile. 
days_month <- df1 %>%
  group_by(YearMonth) %>%
  summarize(Number_days = n_distinct(Day))

days_month