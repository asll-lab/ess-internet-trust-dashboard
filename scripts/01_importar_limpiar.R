#Importación de datos
library(dplyr)
ESS8  <- read.csv("data/ess8.csv")
ESS9  <- read.csv("data/ess9.csv")
ESS10 <- read.csv("data/ess10.csv")
ESS11 <- read.csv("data/ess11.csv")

vars <- c("netusoft", "netustm", "ppltrst", "pplfair", "pplhlp", "agea", "eduyrs", "cntry")
vars %in% names(ess8)
vars %in% names(ess9)
vars %in% names(ess10)
vars %in% names(ess11)

datos <- bind_rows(
  ess8  %>% select(all_of(vars)) %>% mutate(round = 8),
  ess9  %>% select(all_of(vars)) %>% mutate(round = 9),
  ess10 %>% select(all_of(vars)) %>% mutate(round = 10),
  ess11 %>% select(all_of(vars)) %>% mutate(round = 11)
)

dim(datos)
head(datos)
summary(datos)

datos_limpios <- datos %>%
  mutate(
    netusoft = ifelse(netusoft %in% c(7, 8, 9), NA, netusoft),
    netustm  = ifelse(netustm %in% c(6666, 7777, 8888, 9999), NA, netustm),
    ppltrst  = ifelse(ppltrst %in% c(77, 88, 99), NA, ppltrst),
    pplfair  = ifelse(pplfair %in% c(77, 88, 99), NA, pplfair),
    pplhlp   = ifelse(pplhlp  %in% c(77, 88, 99), NA, pplhlp),
    agea     = ifelse(agea == 999, NA, agea),
    eduyrs   = ifelse(eduyrs %in% c(77, 88, 99), NA, eduyrs)
  )

summary(datos_limpios)

saveRDS(datos_limpios, "data/datos_limpios.rds")