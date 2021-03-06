# Chapter 12 tidy data
library(tidyverse)
table1
table2
table3
table4a
table4b

table1 %>% 
  mutate(rate = cases / population * 1000)

table1 %>% 
  count(year, wt = cases)

library(ggplot2)
ggplot(table1, aes(year, cases)) +
  geom_line(aes(group = country), colour = "grey50") +
  geom_point(aes(colour = country))

# spreading and gathering
table4a
table4a %>% 
  gather("1999", "2000", key = "year", value = "cases")

table4b %>% 
  gather(`1999`, `2000`, key = "year", value = "population")

# to combine
tidy4a <- table4a %>% 
  gather("1999", "2000", key = "year", value = "cases")

tidy4b <- table4b %>% 
  gather(`1999`, `2000`, key = "year", value = "population")

left_join(tidy4a, tidy4b)

# spreading
table2
table2 %>% 
  spread(key = type, value = count)

# separating and uniting
table3
table3 %>% 
  separate(rate, into = c("cases", "population"))

table3 %>% 
  separate(rate, into = c("cases", "population"), sep = "/")

table3 %>% 
  separate(rate, into = c("cases", "population"), sep = "/", convert = TRUE)

table3 %>% 
  separate(year, into = c("century", "year"), sep = 2)

# unite
table5
table5 %>% 
  unite(new, century, year)

table5 %>% 
  unite(new, century, year, sep = "")

# missing values
stocks <- tibble(
  year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr    = c(   1,    2,    3,    4,    2,    3,    4),
  return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)

stocks %>% 
  spread(year, return)

stocks %>% 
  spread(year, return) %>% 
  gather(year, return, `2015`:`2016`, na.rm = TRUE)

stocks %>% 
  complete(year, qtr) # complete


# fill NA
treatment <- tribble(
  ~ person,           ~ treatment, ~response,
  "Derrick Whitmore", 1,           7,
  NA,                 2,           10,
  NA,                 3,           9,
  "Katherine Burke",  1,           4
)

treatment %>% 
  fill(person)

# case study
who
who1 <- who %>%
  gather(new_sp_m014:newrel_f65, key = "key", value = "cases", na.rm = TRUE)
who1
who1 %>% 
  count(key)

who2 <- who1 %>% 
  mutate(key = stringr::str_replace(key, "newrel", "new_rel"))
who2

who3 <- who2 %>% 
  separate(key, c("new", "type", "sexage"), sep = "_")
who3

who3 %>% 
  count(new)
who4 <- who3 %>% 
  select(-new, -iso2, -iso3)

who5 <- who4 %>% 
  separate(sexage, c("sex", "age"), sep = 1)
who5

# with one chain of command
who %>%
  gather(key, value, new_sp_m014:newrel_f65, na.rm = TRUE) %>% 
  mutate(key = stringr::str_replace(key, "newrel", "new_rel")) %>% 
  separate(key, c("new", "var", "sexage")) %>% 
  select(-new, -iso2, -iso3) %>% 
  separate(sexage, c("sex", "age"), sep = 1)
