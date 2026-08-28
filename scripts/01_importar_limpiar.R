#Importación de datos
library(dplyr)
ess8  <- read.csv("data/ess8.csv")
ess9  <- read.csv("data/ess9.csv")
ess10 <- read.csv("data/ess10.csv")
ess11 <- read.csv("data/ess11.csv")

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

dir.create("presentation")
file.create("presentation/.gitkeep")
dir.create("report/figuras")


library(dplyr)
library(ggplot2)

datos_limpios <- readRDS("data/datos_limpios.rds")

# 1. Uso de internet (netusoft) — distribución por ronda
ggplot(datos_limpios, aes(x = factor(netusoft))) +
  geom_bar() +
  facet_wrap(~round) +
  labs(title = "Frecuencia de uso de internet por ronda",
       x = "1=nunca ... 5=todos los días", y = "Cantidad de personas")
ggsave("report/figuras/01_uso_internet_por_ronda.png", width = 8, height = 6, dpi = 300)

# 2. Confianza social (ppltrst) — distribución por ronda
ggplot(datos_limpios, aes(x = ppltrst)) +
  geom_histogram(binwidth = 1) +
  facet_wrap(~round) +
  labs(title = "Confianza social por ronda", x = "Confianza (0-10)", y = "Cantidad de personas")
ggsave("report/figuras/02_confianza_por_ronda.png", width = 8, height = 6, dpi = 300)

# 3. Edad — para saber si hay algún grupo etario sobre/sub-representado
ggplot(datos_limpios, aes(x = agea)) +
  geom_histogram(binwidth = 5) +
  labs(title = "Distribución de edad", x = "Edad", y = "Cantidad de personas")
ggsave("report/figuras/03_distribucion_edad.png", width = 8, height = 6, dpi = 300)


table(datos_limpios$round)

install.packages("psych")
library(psych)
psych::alpha(datos_limpios[, c("ppltrst", "pplfair", "pplhlp")])


datos_limpios <- datos_limpios %>%
  mutate(confianza_idx = rowMeans(select(., ppltrst, pplfair, pplhlp), na.rm = TRUE))



resumen_confianza <- datos_limpios %>%
  group_by(round, netusoft) %>%
  summarise(confianza_promedio = mean(confianza_idx, na.rm = TRUE),
            n = n(), .groups = "drop")

ggplot(resumen_confianza, aes(x = factor(netusoft), y = confianza_promedio)) +
  geom_col() +
  facet_wrap(~round) +
  labs(title = "Índice de confianza social promedio según frecuencia de uso de internet",
       x = "Uso de internet (1=nunca, 5=todos los días)", y = "Índice de confianza (0-10)")
ggsave("report/figuras/04_uso_internet_vs_confianza.png", width = 8, height = 6, dpi = 300)


# Confianza según grupo de edad
datos_limpios <- datos_limpios %>%
  mutate(grupo_edad = cut(agea, breaks = c(0, 25, 40, 55, 70, 100),
                          labels = c("18-25", "26-40", "41-55", "56-70", "71+")))

resumen_edad <- datos_limpios %>%
  filter(!is.na(grupo_edad)) %>%
  group_by(round, grupo_edad, netusoft) %>%
  summarise(confianza_promedio = mean(confianza_idx, na.rm = TRUE), .groups = "drop")

ggplot(resumen_edad, aes(x = factor(netusoft), y = confianza_promedio, fill = grupo_edad)) +
  geom_col(position = "dodge") +
  facet_wrap(~round) +
  labs(title = "Confianza social según uso de internet, por grupo de edad",
       x = "Uso de internet (1=nunca, 5=todos los días)", y = "Índice de confianza (0-10)",
       fill = "Grupo de edad")
ggsave("report/figuras/05_confianza_por_edad_y_uso.png", width = 9, height = 6, dpi = 300)

resumen_edu <- datos_limpios %>%
  filter(!is.na(eduyrs), eduyrs <= 25) %>%
  group_by(round, eduyrs) %>%
  summarise(confianza_promedio = mean(confianza_idx, na.rm = TRUE), .groups = "drop")

ggplot(resumen_edu, aes(x = eduyrs, y = confianza_promedio)) +
  geom_point() +
  geom_smooth(method = "lm", color = "red") +
  facet_wrap(~round) +
  labs(title = "Relación entre años de educación y confianza social",
       x = "Años de educación", y = "Índice de confianza promedio (0-10)")
ggsave("report/figuras/06_educacion_vs_confianza.png", width = 8, height = 6, dpi = 300)


resumen_pais <- datos_limpios %>%
  group_by(cntry, round) %>%
  summarise(confianza_promedio = mean(confianza_idx, na.rm = TRUE),
            uso_internet_alto = mean(netusoft == 5, na.rm = TRUE), .groups = "drop")

ggplot(resumen_pais, aes(x = reorder(cntry, confianza_promedio), y = confianza_promedio)) +
  geom_col() +
  coord_flip() +
  facet_wrap(~round) +
  labs(title = "Confianza social promedio por país", x = "País", y = "Índice de confianza (0-10)")
ggsave("report/figuras/07_confianza_por_pais.png", width = 9, height = 7, dpi = 300)

saveRDS(datos_limpios, "data/datos_limpios.rds")

getwd()

