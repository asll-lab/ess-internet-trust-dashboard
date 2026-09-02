# ess-internet-trust-dashboard

## Objetivo principal

Analizar la relación entre el uso de internet y la confianza social en países europeos 
entre 2016 y 2023, considerando diferencias según edad, nivel educativo y país, 
con el fin de generar evidencia contextual que contribuya a la toma de decisiones 
de diseño de productos digitales sensibles a la confianza del usuario.

## Objetivos específicos

1. Describir la evolución temporal de la frecuencia de uso de internet y de la confianza
social entre las rondas 8 y 11 de la ESS, identificando diferencias relevantes
entre países.

2. Analizar la relación entre frecuencia de uso de internet y confianza social,
examinando cómo varía el nivel promedio de confianza según la frecuencia de uso.

3. Examinar el papel de la edad y el nivel educativo en la relación entre uso de internet 
y confianza social, identificando posibles diferencias entre grupos etarios y niveles educativos.

4. Comparar los niveles de confianza social entre países y su estabilidad temporal, 
identificando mercados con niveles relativamente altos o bajos de confianza y 
traduciendo estos hallazgos en consideraciones contextuales para estrategias de producto digital.


## Datos

Los archivos originales de la European Social Survey no se incluyen en este 
repositorio por su tamaño (>25MB, límite de GitHub). Para reproducir el análisis:

1. Regístrate en https://www.europeansocialsurvey.org/data-portal
2. Descarga en formato CSV las Rondas 8, 9, 10 y 11 (usa el archivo de 
   entrevista cara a cara para la Ronda 10, no el de auto-completado)
3. Guárdalos en la carpeta `data/` con estos nombres exactos:
   `ess8.csv`, `ess9.csv`, `ess10.csv`, `ess11.csv`
4. Corre `scripts/01_importar_limpiar.R` para generar `datos_limpios.rds`

## Enlace al repositorio 
https://github.com/asll-lab/ess-internet-trust-dashboard

## Dashboard en vivo
https://asll-lab.github.io/ess-internet-trust-dashboard/dashboard/dashboard.html