library(vroom)
library(tidyverse)

dir.create("neiss")
# #> Warning in dir.create("neiss"): 'neiss' already exists
# download <- function(name) {
#   url <- "https://github.com/hadley/mastering-shiny/raw/master/neiss/"
#   download.file(paste0(url, name), paste0("neiss/", name), quiet = TRUE)
# }
# download("injuries.tsv.gz")
# download("population.tsv")
# download("products.tsv")

injuries <- vroom::vroom("neiss/injuries.tsv.gz")
injuries

products <- vroom::vroom("neiss/products.tsv")
products
#> # A tibble: 38 × 2
#>   prod_code title                            
#>       <dbl> <chr>                            
#> 1       464 knives, not elsewhere classified 
#> 2       474 tableware and accessories        
#> 3       604 desks, chests, bureaus or buffets
#> 4       611 bathtubs or showers              
#> 5       649 toilets                          
#> 6       676 rugs or carpets, not specified   
#> # … with 32 more rows

population <- vroom::vroom("neiss/population.tsv")
population
#> # A tibble: 170 × 3
#>     age sex    population
#>   <dbl> <chr>       <dbl>
#> 1     0 female    1924145
#> 2     0 male      2015150
#> 3     1 female    1943534
#> 4     1 male      2031718
#> 5     2 female    1965150
#> 6     2 male      2056625
#> # … with 164 more rows
 
 
selected <- injuries %>% filter(prod_code == 649)
nrow(selected) 

selected %>% count(location, wt = weight, sort = TRUE)

selected %>% count(body_part, wt = weight, sort = TRUE) 

selected %>% count(diag, wt = weight, sort = TRUE)

summary <- selected %>% 
  count(age, sex, wt = weight)
summary
#> # A tibble: 208 × 3
#>     age sex         n
#>   <dbl> <chr>   <dbl>
#> 1     0 female   4.76
#> 2     0 male    14.3 
#> 3     1 female 253.  
#> 4     1 male   231.  
#> 5     2 female 438.  
#> 6     2 male   632.  
#> # … with 202 more rows

summary %>% 
  ggplot(aes(age, n, colour = sex)) + 
  geom_line() + 
  labs(y = "Estimated number of injuries")

summary <- selected %>% 
  count(age, sex, wt = weight) %>% 
  left_join(population, by = c("age", "sex")) %>% 
  mutate(rate = n / population * 1e4)

summary
#> # A tibble: 208 × 5
#>     age sex         n population   rate
#>   <dbl> <chr>   <dbl>      <dbl>  <dbl>
#> 1     0 female   4.76    1924145 0.0247
#> 2     0 male    14.3     2015150 0.0708
#> 3     1 female 253.      1943534 1.30  
#> 4     1 male   231.      2031718 1.14  
#> 5     2 female 438.      1965150 2.23  
#> 6     2 male   632.      2056625 3.07  
#> # … with 202 more rows

summary %>% 
  ggplot(aes(age, rate, colour = sex)) + 
  geom_line(na.rm = TRUE) + 
  labs(y = "Injuries per 10,000 people")

selected %>% 
  sample_n(10) %>% 
  pull(narrative)

count_top <- function(df, var, n = 5) {
  # var is bare name
  df %>%
    mutate({{ var }} := fct_lump(fct_infreq({{ var }}), n = n)) %>%
    group_by({{ var }}) %>%
    summarise(n = as.integer(sum(weight)))
}

selected %>%
  count_top(location)



