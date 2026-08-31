
# ============================================================
# 02_analisis_eda.R
# Proyecto: ess-internet-trust-dashboard
# Objetivo: Análisis exploratorio de los datos (EDA)
# ============================================================

library(dplyr)
library(ggplot2)

datos_limpios <- readRDS("data/datos_limpios.rds")

# 1. Uso de internet por ronda
ggplot(datos_limpios, aes(x = factor(netusoft))) +
  geom_bar() + facet_wrap(~round) +
  labs(title = "Frecuencia de uso de internet por ronda",
       x = "1=nunca ... 5=todos los días", y = "Cantidad de personas")
ggsave("report/figuras/01_uso_internet_por_ronda.png", width = 8, height = 6, dpi = 300)

# 2. Confianza social por ronda
ggplot(datos_limpios, aes(x = ppltrst)) +
  geom_histogram(binwidth = 1) + facet_wrap(~round) +
  labs(title = "Confianza social por ronda", x = "Confianza (0-10)", y = "Cantidad de personas")
ggsave("report/figuras/02_confianza_por_ronda.png", width = 8, height = 6, dpi = 300)

# 3. Distribución de edad
ggplot(datos_limpios, aes(x = agea)) +
  geom_histogram(binwidth = 5) +
  labs(title = "Distribución de edad", x = "Edad", y = "Cantidad de personas")
ggsave("report/figuras/03_distribucion_edad.png", width = 8, height = 6, dpi = 300)

# 4. Uso de internet vs. confianza
resumen_confianza <- datos_limpios %>%
  group_by(round, netusoft) %>%
  summarise(confianza_promedio = mean(confianza_idx, na.rm = TRUE), n = n(), .groups = "drop")

ggplot(resumen_confianza, aes(x = factor(netusoft), y = confianza_promedio)) +
  geom_col() + facet_wrap(~round) +
  labs(title = "Índice de confianza social promedio según frecuencia de uso de internet",
       x = "Uso de internet (1=nunca, 5=todos los días)", y = "Índice de confianza (0-10)")
ggsave("report/figuras/04_uso_internet_vs_confianza.png", width = 8, height = 6, dpi = 300)

# 5. Confianza según uso de internet y grupo de edad
resumen_edad <- datos_limpios %>%
  filter(!is.na(grupo_edad)) %>%
  group_by(round, grupo_edad, netusoft) %>%
  summarise(confianza_promedio = mean(confianza_idx, na.rm = TRUE), .groups = "drop")

ggplot(resumen_edad, aes(x = factor(netusoft), y = confianza_promedio, fill = grupo_edad)) +
  geom_col(position = "dodge") + facet_wrap(~round) +
  labs(title = "Confianza social según uso de internet, por grupo de edad",
       x = "Uso de internet (1=nunca, 5=todos los días)", y = "Índice de confianza (0-10)",
       fill = "Grupo de edad")
ggsave("report/figuras/05_confianza_por_edad_y_uso.png", width = 9, height = 6, dpi = 300)

# 6. Educación vs. confianza
resumen_edu <- datos_limpios %>%
  filter(!is.na(eduyrs), eduyrs <= 25) %>%
  group_by(round, eduyrs) %>%
  summarise(confianza_promedio = mean(confianza_idx, na.rm = TRUE), .groups = "drop")

ggplot(resumen_edu, aes(x = eduyrs, y = confianza_promedio)) +
  geom_point() + geom_smooth(method = "lm", color = "red") + facet_wrap(~round) +
  labs(title = "Relación entre años de educación y confianza social",
       x = "Años de educación", y = "Índice de confianza promedio (0-10)")
ggsave("report/figuras/06_educacion_vs_confianza.png", width = 8, height = 6, dpi = 300)

# 7. Confianza por país
resumen_pais <- datos_limpios %>%
  group_by(cntry, round) %>%
  summarise(confianza_promedio = mean(confianza_idx, na.rm = TRUE), .groups = "drop")

ggplot(resumen_pais, aes(x = reorder(cntry, confianza_promedio), y = confianza_promedio)) +
  geom_col() + coord_flip() + facet_wrap(~round) +
  labs(title = "Confianza social promedio por país", x = "País", y = "Índice de confianza (0-10)")
ggsave("report/figuras/07_confianza_por_pais.png", width = 9, height = 7, dpi = 300)

# Verificación de tamaño muestral por ronda
table(datos_limpios$round)