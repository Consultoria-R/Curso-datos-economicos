# Bases de datos de series económicas en R
# 30 de Abril 2022
# Sesión III

# Borrar objetos de r
rm(list = ls())

# Libreria
library(tidyverse)

# Funciones
# Ejemplo I
potencia_cuad <- function(z) {
  z*z
}
potencia_cuad(4)

# Ejemplo II
miles <- function(w) {
  w/1000
}
miles(5879)

# Dos variables
potencia <- function(x,y) {
  x^y
}
potencia(5,3)

# Tasa de crecimiento o tasa de variación
# Función rezago
# PIB de México en cifras desestacionalizadas
x <- c(18231131,14976856,16997528,17588474,
       17722918,17907744,17782677,17786344)
x

# Función rezago
lag(x,1)

# Tasa de variacion trimestral
x/lag(x,1)*100-100
round(x/lag(x,1)*100-100,1)

# Tasa de variación anual
x/lag(x,4)*100-100
round(x/lag(x,4)*100-100,1)

# Función
variacion <- 
  function(x,k,d){
    round(x/lag(x,k)*100-100,d)
  }
variacion(x,1,2) # trimestral con dos decimales
variacion(x,4,2) # anual con dos decimales

# Aplicación a base de datos
# Cargar base de datos
library(readxl)
demanda <- 
  read_excel("dataset/oferta_demanda_global.xlsx")

# Visualizar base
demanda
demanda %>% tail()

# Tasa de variación trimestral del PIB
demanda %>% 
  mutate(pib_tasa_trimestral=pib/lag(pib,1)*100-100) %>% 
  tail(10)

# Tasa de variación trimestral del PIB hasta las importaciones
demanda %>% 
  mutate(across(.cols = pib:impor,
                .fns = ~variacion(.x,1,1))) %>% 
  as.data.frame()

# Varias columnas
demanda %>% 
  mutate(across(.cols = pib:impor,
                .fns = ~variacion(.x,1,1),
                .names = "{.col}_var_mensual")) %>% 
  as.data.frame()

# Tasa de variación trimestral y anual del PIB hasta las importaciones
demanda %>% 
  mutate(across(.cols = pib:impor,
                .fns = c(trim=~variacion(.x,1,1),anual=~variacion(.x,4,1)),
                .names = "{.col}_{.fn}"))

# Contribución
contribucion <- function(x,y,d) {
  round(((x-lag(x,4))/lag(y,4))*100,d)
}

# https://www.inegi.org.mx/contenidos/saladeprensa/boletines/2022/ofyd/ofyd2022_03.pdf
demanda %>%
  mutate(fbkf=rowSums(across(.cols = fbkf_privado:fbkf_publico),na.rm=TRUE),
         periodo=as.Date(periodo)) %>%
  select(periodo:consumo_publico,fbkf,expor,impor) %>%
  mutate(across(.cols = consumo_privado:impor,
                .fns = c(contr=~contribucion(.x,pib,1)),
                .names = "{.col}_{.fn}")) %>%
  tail(10)

# Loop for
for (i in 1:5) {
  print(i^2)
}

x <- c(3,5,7,9)
for (i in x) {
  print(i^2)
}

x <- c("ags","bc","bcs","camp")
for (i in x) {
  print(paste(i,2020,sep = "_"))
}

# Guardar resultados
resultados <- c()
for (i in 1:10) {
  resultados[i] <- i^2
}
resultados

resultados2 <- c()
x <- c("ags","bc","bcs","camp")
for (i in x) {
  resultados2[i] <- paste(i,2020,sep = "_")
}
resultados2

# Aplicación: cálculo de deciles ENIGH 2020
library(foreign)
enigh <- read.dbf("dataset/concentradohogar.dbf",
                  as.is = TRUE)
enigh <- tibble(enigh)
enigh

# Ingresos de los hogares
summary(enigh$ing_cor)

# Total de hogares
sum(enigh$factor)

# Deciles
enigh %>% 
  select(ubica_geo,ing_cor,factor) %>% 
  arrange(ing_cor) %>% 
  mutate(pp=cumsum(factor)) %>% 
  mutate(ppi=pp/sum(factor),
         decil=0)

# Ordenar base de datos y crear nuevas variables
enigh <- 
  enigh %>% 
  arrange(ing_cor) %>% 
  mutate(pp=cumsum(factor)/sum(factor),
         decil=0)

# Visualizar columnas
enigh %>% 
  select(ing_cor,factor,pp,decil)

# Iterar variable decil
for (i in 1:10){
  enigh$decil[enigh$pp>(i-1)/10 & enigh$pp<=i/10] <- i
}

# Tabulado: excel cuadro 2.1
enigh %>%   
  group_by(decil) %>% 
  summarise(Ingreso_decil=weighted.mean(ing_cor,factor))

# Por entidad federativa
enigh
enigh <- 
  enigh %>% 
  mutate(entidad=as.numeric(str_sub(ubica_geo,1,2)))

# Ordenar base de datos
enigh_ef <- 
  enigh %>%
  group_by(entidad) %>% 
  arrange(ing_cor) %>% 
  mutate(pp=cumsum(factor)/sum(factor),
         decil=0) %>% 
  ungroup()

# Iterar variable decil
# https://www.finanzaspublicas.hacienda.gob.mx/work/models/Finanzas_Publicas/docs/congreso/infoanual/2021/drr_2021.pdf
# Página 59
for (j in 1:32) {
  for (i in 1:10){
    enigh_ef$decil[enigh_ef$pp>(i-1)/10 & enigh_ef$pp<=i/10 & enigh_ef$entidad==j] <- i
  }
}

# Tabulados: excel cuadro 3.5
enigh_ef %>% 
  group_by(decil,entidad) %>% 
  summarise(Ingreso_decil=weighted.mean(ing_cor,factor)) %>% 
  arrange(entidad) %>% 
  ungroup() %>% 
  as.data.frame()

# Listas
lista <- list(A=seq(1,5),
              B=seq(1,10),
              C=seq(1,20),
              D=matrix(1:15,5,3),
              E="texto")
lista

# Extracción de sublistas
lista[[1]]
lista[[2]]
lista[["D"]]
lista$C

# Agragar sublistas
lista[["F"]] <- 
  tibble(salario=rnorm(n=10,mean=15000,sd=2500),
         sexo=c(rep("Mujer",5),rep("Hombre",5)))
lista

# Estructura de la lista
str(lista)

# Total de sublistas en forma progresiva
seq_along(lista)

# Definiendo nuevamente al objeto lista
lista <- list(A=seq(1,5),
              B=seq(1,10),
              C=seq(1,20))
lista

# Iteración
# Media
for (i in seq_along(lista)) {
  mean(lista[[i]]) %>% print
}

# Suma
for (i in seq_along(lista)) {
  sum(lista[[i]]) %>% print
}

# Tamanio de la lista
for (i in seq_along(lista)) {
  length(lista[[i]]) %>% print
}

# Guardar resultados
lista_media <- list()
for (i in seq_along(lista)) {
  lista_media[[i]] <- mean(lista[[i]])
}
lista_media

# Funcion map (paquete purrr)
lista
map(lista,~sum(.x))
map(lista,~mean(.x))
map(lista,~length(.x))

map_dbl(lista,~sum(.x))
map_dbl(lista,~mean(.x))
map_dbl(lista,~length(.x))

# Logico
map_lgl(lista,~length(.x)>=10)

lista
map(lista,~.x %>% sum() %>% log())

# Base ingresos (ENIGH)
load("dataset/ingresos.RData")
load("dataset/gastos.RData")
ingresos
gastos

# Aplicación a regresión
# Regresiones
options(scipen = 5)
lm(gasto_mon~ing_cor+sexo_jefe,data = gastos) %>% summary()
lm(gasto_mon~ing_cor+sexo_jefe,data = gastos,weights = factor) %>% summary()
lm(gasto_mon~ing_cor+sexo_jefe,data = subset(gastos,entidad=="Ags")) %>% summary()
lm(gasto_mon~ing_cor+sexo_jefe,data = subset(gastos,entidad=="Ags"),weights = factor) %>% summary()
lm(gasto_mon~ing_cor+sexo_jefe,data = subset(gastos,entidad=="BC"),weights = factor) %>% summary()
lm(gasto_mon~ing_cor+sexo_jefe,data = subset(gastos,entidad=="BCS"),weights = factor) %>% summary()

# Crear listas a partir de las entidades federativas
gastos_lista <- 
  gastos %>% 
  group_split(ingresos$entidad)

# Regresiones (comentar)
map(gastos_lista,~lm(gasto_mon~ing_cor+sexo_jefe,data = .x,weights = factor) %>% summary())

levels(gastos$entidad)
names(gastos_lista) <- levels(gastos$entidad)

# FIN
