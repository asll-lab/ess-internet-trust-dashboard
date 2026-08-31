
# ============================================================
# 01_importar_limpiar.R
# Proyecto: ess-internet-trust-dashboard
# Objetivo:importar, combinar y depurar los datos ESS (rondas 8-11)
# ============================================================



library(dplyr)

# Importar los 4 CSV de la ESS
ess8  <- read.csv("data/ess8.csv")
ess9  <- read.csv("data/ess9.csv")
ess10 <- read.csv("data/ess10.csv")
ess11 <- read.csv("data/ess11.csv")

# Verificar que las variables necesarias existen en cada ronda
vars <- c("netusoft", "netustm", "ppltrst", "pplfair", "pplhlp", "agea", "eduyrs", "cntry")
vars %in% names(ess8)
vars %in% names(ess9)
vars %in% names(ess10)
vars %in% names(ess11)

# Combinar las 4 rondas en un solo dataset
datos <- bind_rows(
  ess8  %>% select(all_of(vars)) %>% mutate(round = 8),
  ess9  %>% select(all_of(vars)) %>% mutate(round = 9),
  ess10 %>% select(all_of(vars)) %>% mutate(round = 10),
  ess11 %>% select(all_of(vars)) %>% mutate(round = 11)
)

# Recodificar códigos especiales de no respuesta a NA
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

# Validar consistencia interna antes de construir el índice de confianza
library(psych)
psych::alpha(datos_limpios[, c("ppltrst", "pplfair", "pplhlp")])  # raw_alpha = 0.79

# Crear variables derivadas
datos_limpios <- datos_limpios %>%
  mutate(
    confianza_idx = rowMeans(select(., ppltrst, pplfair, pplhlp), na.rm = TRUE),
    grupo_edad = cut(agea, breaks = c(0, 25, 40, 55, 70, 100),
                     labels = c("18-25", "26-40", "41-55", "56-70", "71+"))
  )

# Guardar el dataset limpio
saveRDS(datos_limpios, "data/datos_limpios.rds")

