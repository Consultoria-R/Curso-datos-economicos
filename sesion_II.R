# Bases de datos de series económicas en R
# 29 de Abril 2022
# Sesión II

# Borrar objetos de r
rm(list = ls())

# ENIGH 2020
# Cargar base de datos
library(foreign)
enigh <- read.dbf("dataset/concentradohogar.dbf",
                  as.is = TRUE)
enigh

# Estructura de la base de datos
str(enigh)
enigh

# Cargar libreria especializada en base de datos
library(tidyverse)
enigh <- tibble(enigh)
enigh

# Verbos de la libreria dplyr
# Seleccionar columnas
View(enigh)
select(enigh,
       3,8,10:13,23)
select(enigh,
       ubica_geo,
       factor,
       sexo_jefe:tot_integ,
       ing_cor)
select(enigh,
       -3,-8,-c(10:13),-23)

# Seleccionar según un prefijo
select(enigh,starts_with("ing"))
select(enigh,ends_with("jefe"))
select(enigh,contains("ing"))
select(enigh,matches("ing|jefe"))

# Cambiar orden de columnas
relocate(enigh,matches("ing"),.after=factor)
relocate(enigh,matches("ing"),.before=factor)

# Nombres de las columnas
colnames(enigh)

# Crear base ingresos del hogar
ingresos <- 
  select(enigh,3,10:13,23:24,44,47,55,56,4,6:8)
ingresos

# Crear base gastos del hogar
gastos <- 
  select(enigh,folioviv,foliohog,ubica_geo,sexo_jefe,ing_cor,gasto_mon,
         alimentos,vesti_calz,vivienda,limpieza,salud,transporte,
         educa_espa,personales,transf_gas,factor,upm,est_dis)
gastos

# Mostrar objeto
ingresos

# Crear columnas
# Suma del ingreso corriente, pag. 192
mutate(ingresos,
       ING_TRIM=ingtrab+rentas+transfer+estim_alqu+otros_ing)
mutate(ingresos,
       ing_trim=rowSums(across(.cols = ingtrab:otros_ing),na.rm = TRUE))
mutate(ingresos,
       ing_trim=rowSums(across(.cols = ingtrab:otros_ing),na.rm = TRUE),.keep = "used")

# Varias columnas
ingresos
mutate(ingresos,
       across(.cols = ingtrab:otros_ing,
              .fns = ~.x/ing_cor*100))

mutate(ingresos,
       across(.cols = ingtrab:otros_ing,
              .fns = ~.x/ing_cor*100,
              .names = "{.col}_porc"))

mutate(ingresos,
       across(.cols = ingtrab:otros_ing,
              .fns = ~.x/ing_cor*100,
              .names = "{.col}_porc"),
       .keep = "used")

# Gasto de los hogares


# Gasto monetario trimestral


# Porcentaje del gasto monetario trimestral


# Entidad
ingresos
mutate(ingresos,
       entidad=str_sub(ubica_geo,1,2))
mutate(ingresos,
       municipio=str_sub(ubica_geo,3,5))
mutate(ingresos,
       entidad=str_sub(ubica_geo,1,2),
       municipio=str_sub(ubica_geo,3,5))

# Base ingresos
ingresos <- mutate(ingresos,
                   entidad=str_sub(ubica_geo,1,2))

# Base gastos
gastos


# Crear etiquetas
ingresos
table(ingresos$sexo_jefe)
ingresos <- 
  mutate(ingresos,sexo_jefe=factor(as.numeric(sexo_jefe),
                                   levels = 1:2,
                                   labels = c("Hombre","Mujer")))

ingresos <- 
  mutate(ingresos,entidad=factor(as.numeric(entidad),
                                 levels = 1:32,
                                 labels = c("Ags","BC","BCS","Camp","Coah","Col","Chia",
                                            "Chih","CDMX","Dgo","Gto","Gro","Hgo","Jal",
                                            "Mex","Mich","Mor","Nay","NL","Oax","Pue",
                                            "Qro","QRoo","SLP","Sin","Son","Tabs","Tamps",
                                            "Tlax","Ver","Yuc","Zac")))

ingresos <- 
  mutate(ingresos,educa_jefe=factor(as.numeric(educa_jefe),
                                    levels = 1:11,
                                    labels = c("Sin_instruccion",
                                               "Preescolar",
                                               "Primaria incompleta",
                                               "Primaria completa",
                                               "Secundaria incompleta",
                                               "Secundaria completa",
                                               "Preparatoria incompleta",
                                               "Preparatoria completa",
                                               "Profesional incompleta",
                                               "Profesional completa",
                                               "Posgrado")))
ingresos

# Base gastos
# Etiqueta sexo_jefe


# Etiqueta entidad


# Filter: filtrar filas
ingresos
filter(ingresos,
       entidad=="CDMX")
filter(ingresos,
       entidad=="CDMX",sexo_jefe=="Mujer")
filter(ingresos,
       entidad=="CDMX" & sexo_jefe=="Mujer")
filter(ingresos,
       entidad=="CDMX" & sexo_jefe=="Mujer" & edad_jefe>=65)
filter(ingresos,
       entidad %in% c("CDMX","Mex") & sexo_jefe=="Mujer")

# arrange: ordenar
ingresos
arrange(ingresos,edad_jefe)
arrange(ingresos,desc(edad_jefe))
arrange(ingresos,edad_jefe,ing_cor)

# Estadísticas
# Ingreso
ingresos
ingresos$ing_cor
mean(ingresos$ing_cor)
mean(ingresos$edad_jefe)
weighted.mean(ingresos$ing_cor,ingresos$factor)

# Gasto
gastos


# Media del ingreso
summarise(ingresos,
          Ingreso=mean(ing_cor))
summarise(ingresos,
          Edad=mean(edad_jefe))
summarise(ingresos,
          Ingreso=mean(ing_cor),
          Edad=mean(edad_jefe))

summarise(ingresos,
          Ingreso=weighted.mean(ing_cor,factor))

summarise(ingresos,
          Ingreso=weighted.mean(ing_cor,factor),
          Ing_trab=weighted.mean(ingtrab,factor))

# Varias columnas (excel, cuadro 3.5)
ingresos
summarise(ingresos,across(.cols = ing_cor:otros_ing,
                          .fns = ~weighted.mean(.x,factor)))

summarise(ingresos,across(.cols = c(ing_cor:otros_ing,edad_jefe),
                          .fns = ~weighted.mean(.x,factor),
                          .names = "media_{.col}"))

# Base gastos (Excel tabla 4.5)
gastos

# Encadenamiento
summarise(ingresos,
          Ingreso=mean(ing_cor))

ingresos %>% 
  summarise(Ingreso=mean(ing_cor))

ingresos %>% 
  summarise(Ingreso=weighted.mean(ing_cor,factor))

ingresos %>% 
  select(entidad,2:3,ing_cor,factor)

# Seleccionar variables y filtrar
ingresos %>% 
  select(entidad,2:3,ing_cor,factor) %>% 
  filter(sexo_jefe=="Hombre")

ingresos %>% 
  select(entidad,2:3,ing_cor,factor) %>% 
  filter(sexo_jefe=="Hombre") %>% 
  arrange(desc(ing_cor))

# Agrupar
ingresos %>% 
  summarise(Ingreso=weighted.mean(ing_cor,factor))

# Ingreso por sexo
ingresos %>% 
  group_by(sexo_jefe) %>% 
  summarise(Ingreso=weighted.mean(ing_cor,factor))

# Ingreso por entidad
ingresos %>% 
  group_by(entidad) %>% 
  summarise(Ingreso=weighted.mean(ing_cor,factor))

# Ingreso por entidad y sexo
ingresos %>% 
  group_by(entidad,sexo_jefe) %>% 
  summarise(Ingreso=weighted.mean(ing_cor,factor))

# Media del ingreso por entidad
ing_ent <-
  ingresos %>% 
  group_by(entidad) %>% 
  summarise(ingreso=weighted.mean(ing_cor,factor))
ing_ent

# Ingresos por entidad de todos los ingresos
ingresos
ingresos %>% 
  summarise(across(.cols=ingtrab:otros_ing,
                   .fns=~weighted.mean(.x,factor),na.rm=TRUE))

ingresos %>% 
  group_by(entidad) %>% 
  summarise(across(.cols=ingtrab:otros_ing,
                   .fns=~weighted.mean(.x,factor),na.rm=TRUE))

# Base gastos
gastos


# Variables categóricas
ingresos
table(ingresos$sexo_jefe)
table(ingresos$educa_jefe)

# Porcentajes
prop.table(table(ingresos$sexo_jefe))*100
prop.table(table(ingresos$educa_jefe))*100

# dplyr
ingresos %>% 
  count(sexo_jefe)
ingresos %>% 
  count(educa_jefe)
ingresos %>% 
  count(educa_jefe,sort = TRUE)
ingresos %>% 
  count(educa_jefe,sexo_jefe)

# Con factor de expansión
ingresos %>% 
  count(sexo_jefe,wt=factor)
ingresos %>% 
  count(educa_jefe,wt=factor,sort = TRUE)
 
# Guardar bases
save(ingresos,
     file = "ingresos.RData")
save(gastos,
     file = "gastos.RData")
save(ing_ent,
     file = "ing_ent.RData")
# FIN
