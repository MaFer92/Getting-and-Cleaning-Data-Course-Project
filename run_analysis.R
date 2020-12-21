#Create one R script called run_analysis.R that does the following:
#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names. 
#5. From the data set in step 4, creates a second, independent tidy data set with 
#the average of each variable for each activity and each subject.

library("data.table")

setwd("C:/Users/Mafer/Documents/Coursera/Curso3/proyecto/UCI HAR Dataset")
actividad_lab= read.table("activity_labels.txt")[,2]
caracteristicas = read.table("features.txt")[,2]

# Extraer solo las medias de la media y desviacion estandar de cada medida. 
extra_carac = grepl("mean|std", caracteristicas)


#########CONJUNTO DE ENTRENAMIENTO

setwd("C:/Users/Mafer/Documents/Coursera/Curso3/proyecto/UCI HAR Dataset/train")

train_x = read.table("X_train.txt")
train_y = read.table("Y_train.txt")
subject_train = read.table("subject_train.txt")

names(train_x) = caracteristicas

#Extraer solo las medias de media y desviacion estandar para cada medida. 
train_x = train_x[,extra_carac]

#Cargando las actividades
train_y[,2] = actividad_lab[train_y[,1]]
names(train_y) = c("Actividad_ID", "Actividad_Lab")
names(subject_train) = "subject"

#Base de datos de entrenamiento
train_data = cbind(as.data.table(subject_train), train_y, train_x)

###CONJUNTO DE PRUEBA
setwd("C:/Users/Mafer/Documents/Coursera/Curso3/proyecto/UCI HAR Dataset/test")

test_x = read.table("X_test.txt")
test_y = read.table("y_test.txt")
subject_test = read.table("subject_test.txt")

names(test_x) = caracteristicas

#Extraer solo las medias de media y desviacion estandar para cada medida. 
test_x = test_x[,extra_carac]

#Cargando las actividades
test_y[,2] = actividad_lab[test_y[,1]]
names(test_y) = c("Actividad_ID", "Actividad_Lab")
names(subject_test) = "subject"

#Base de datos de entrenamiento
test_data = cbind(as.data.table(subject_test), test_y, test_x)

#Union de la data de entrenamiento y prueba
data = rbind(test_data, train_data)

id_lab   = c("subject", "Actividad_ID", "Actividad_Lab")
data_lab = setdiff(colnames(data), id_lab)
melt_data      = melt(data, id = id_lab, measure.vars = data_lab)

# Aplicando la media a cada variable
tidy_data   = dcast(melt_data, subject + Actividad_Lab ~ variable, mean)

write.table(tidy_data, file = "tidy_data.txt")
