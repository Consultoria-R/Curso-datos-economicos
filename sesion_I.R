# Bases de datos de series económicas en R
# 22 de Abril 2022
# Sesión I

# Operaciones básicas
2+2
5-2
2*5
10/5
2^3

# Condiciones lógicas
1<5  # Menor
1>5  # Mayor
1==5 # Igual
1!=5 # Diferente

# Funciones
# Secuencias
1:10
10:1
seq(from=0,to=20,by=1)
seq(from=0,to=20,by=2)
seq(0,20,2)
seq(20,0)
seq(20,0,-5)

# Repetición
rep(1,times=10)
rep(1:5,times=3)
rep(1:5,each=3)               # repetición del mismo elemento en forma consecutiva
rep(1:5,each=3,length=12)
rep(1:5,length=7)
rep("Mujer",4)

# Asignaciones (un solo elemento)
x <- 5
x
y <- 10
y
x+y
w <- x+y
w

# Concatenación (agrupación de varios elementos)
x <- c(9,7,2,5,1)
x

# Extracción por posición
x[1]
x[3]
x[c(1,3)]
x[c(4,2)]

# Extracción por condiciones
x<=2
x[x<=2]
x[x>=4]
x[x>=1 & x<=4]  # Y
x[x<=2 | x>=9]  # O
x[-1]
x[-3]
x[2:4]
x[-c(1,5)]

# Operaciones
x <- c(9,4,2,5,10)
sum(x)                    # suma
mean(x)                   # media
median(x)                 # mediana
sd(x)                     # desviación estandar
min(x)                    # mínimo
max(x)                    # máximo
cumsum(x)                 # suma acumulada
sort(x)                   # creciente
sort(x,decreasing = TRUE) # decreciente
length(x)                 # tamaño del objeto
summary(x)                # resumen
log(x)                    # logaritmo
sqrt(x)                   # raíz cuadrada
class(x)                  # Tipo de objeto

# Definiendo nuevamente el vector x
x <- c(1,3,6,12,NA,4,8,10,0,6,0,NA,5)
x
sum(x)
sum(x,na.rm = TRUE)
mean(x,na.rm = TRUE)
class(x)

# Valores perdidos
is.na(x)
sum(is.na(x))  # Suma de valores perdidos
sum(!is.na(x)) # Diferentes de valores perdidos

# Reemplazo
x[3] <- 20
x[1:2] <- 40
x[c(4,7)] <- 80
x

# Posiciones
which(x>=80)    # Busca la posición de los valores mayores o iguales a 80
which(is.na(x)) # Busca la posición de los valores perdidos

# Asignaciones por condición
x[is.na(x)] <- 0
x[is.na(x)] <- mean(x,na.rm = TRUE)
x

# Nueva base
x_nueva <- x[!is.na(x)]
x_nueva

# Objeto tipo carácter
x <- c("1","1","2","1")
x
class(x)

# Volver a tipo numérico
as.numeric(x)
x <- as.numeric(x)
x

# Objeto tipo factor o categórico (clasificar)
# Ejemplo I
factor(x,
       levels = 1:2,
       labels = c("Hombre","Mujer"))
x <- factor(x,
            levels = 1:2,
            labels = c("Hombre","Mujer"))
class(x)

# Contar variables categóricas
table(x)
prop.table(table(x))

# Ejemplo II
x <- c(1,1,1,2,3)

factor(x,
       levels = 1:3,
       labels = c("Hombre","Mujer","Fuga"))
x <- factor(x,
            levels = 1:3,
            labels = c("Hombre","Mujer","Fuga"))
x
class(x)

# Contar variables categóricas
table(x)
accid <- table(x)
prop.table(accid)

# Pegar columnas
(x <- 1:10)
(y <- 21:30)
cbind(x,y)

# Juntar elementos a un vector
c(x,y)
append(x,y)

# Matrices
matrix(1:15,nrow = 5,ncol = 3)
mat <- matrix(1:15,5,3)
mat

# Extracción
mat[5,3]
mat[4:5,2:3]
mat[c(1,5),c(1,3)]
mat[4:5,1:3]
mat[4:5,]
mat[,2:3]
mat[,-1]
mat

# Cambio de nombres
mat
colnames(mat) <- c("A","B","C")
row.names(mat) <- 1:5

mat[3,3] <- NA

# Operaciones de matrices
mat
rowSums(mat)
rowSums(mat,na.rm = TRUE)
colSums(mat,na.rm = TRUE)
rowMeans(mat,na.rm = TRUE)
colMeans(mat,na.rm = TRUE)

suma <- rowSums(mat,na.rm = TRUE)
suma
mat

# Pegar columnas
mat <- cbind(mat,suma)
mat

total <- colSums(mat,na.rm = TRUE)
total

# Pegar filas
mat <- rbind(mat,total)
mat

# Borrar objetos
rm(list = ls())

# Cargar archivos de Excel
library(readxl)
ensanut <- 
  read_excel("dataset/ensanut_2018.xlsx")

ensanut
View(ensanut)

# Tipo de objeto
class(ensanut)

# Estructura de la base
str(ensanut)

# Estadísticas de salud
# Variables numéricas
# Edad
ensanut
ensanut$edad
mean(ensanut$edad)
mean(ensanut$no_cigarros_d)
mean(ensanut$no_cigarros_d,na.rm = TRUE)
mean(ensanut$no_cigarros_s,na.rm = TRUE)

# Peso
mean(ensanut$peso)
min(ensanut$peso)
max(ensanut$peso)
mean(ensanut$peso[ensanut$peso!=999])

# Filtrar valores
salud <- ensanut[ensanut$peso!=999,]
mean(salud$peso)
sd(salud$peso)
median(salud$peso)
summary(salud$peso)

# Variables categóricas
# Etiquetar la variable salud
salud

# Convertir en factor: sexo
summary(salud)
salud$sexo <- factor(salud$sexo,
                     levels = 1:2,
                     labels = c("Hombre","Mujer"))
table(salud$sexo)
prop.table(table(salud$sexo))

# Convertir en factor: localidad
salud$localidad <- factor(salud$localidad,
                          levels = 1:2,
                          labels = c("Urbano","Rural"))
local <- table(salud$localidad)
prop.table(local)

# Convertir en factor: escolaridad
salud
salud$escolaridad <- as.factor(salud$escolaridad)
table(salud$escolaridad)
prop.table(table(salud$escolaridad))

# Entidad
salud
summary(salud)

salud$entidad <- as.factor(salud$entidad)
table(salud$entidad)
levels(salud$entidad)
nlevels(salud$entidad)

# Comparación
levels(salud$region)
nlevels(salud$region)

salud$region <- as.factor(salud$region)

# Peso promedio de hombre y mujeres
salud
mean(salud$peso)
mean(salud$peso[salud$sexo=="Hombre"])
mean(salud$peso[salud$sexo=="Mujer"])

# Subbases
salud
saludH <- subset(salud,
                 sexo=="Hombre",
                 select = -6)
saludH

# Borrar la base de datos
rm(saludH)

baseM <- subset(salud,
                sexo=="Mujer" & region=="Centro")

summary(baseM)

# Guardar base salud
save(salud,
     file = "salud.RData")

# Instalación de tidyverse
library(tidyverse)

# FIN