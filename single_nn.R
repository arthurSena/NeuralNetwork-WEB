#
create_and_test<-function (train, test, size, decay, maxit, target)
{
  require(nnet)
  require(caret)
  if (!grepl("home", train)) {
    train <- paste("/home/arthur/Documents/redes_neurais/singlenetwork",
                   train, sep = "/")
  }
  if (!grepl("home", test)) {
    test <- paste("/home/arthur/Documents/redes_neurais/singlenetwork",
                  test, sep = "/")
  }
  train_temp <- read.csv(train)
  test_temp <- read.csv(test)
  train_temp[,which( colnames(train_temp)== target)] <- as.factor(train_temp[,which( colnames(train_temp)== target)])
  test_temp[,which( colnames(test_temp)== target)] <- as.factor(test_temp[,which( colnames(test_temp)== target)])
  n <- names(train_temp)
  f <- as.formula(paste(paste(target, "~"), paste(n[!n %in%
                                                      target], collapse = " + ")))
  print(f)
  train.nnet <- nnet(f, data = train_temp, size = size, rang = 0.07,
                     Hess = FALSE, decay = decay, maxit = maxit, MaxNWts = 7400)

  test.nnet <- predict(train.nnet, test_temp[, !colnames(test_temp) %in% c(target)], type = ("class"))
  return(confusionMatrix(table(test.nnet, test_temp[, colnames(test_temp) %in%
                                                      c(target)])))
}
# now <- Sys.time()
# create_and_test('/home/arthur/Documents/redes_neurais/singlenetwork/irisTrain.csv','/home/arthur/Documents/redes_neurais/singlenetwork/irisTest.csv',20,0.1,20,'Species')
# create_and_test('/home/arthur/Documents/redes_neurais/singlenetwork/temp.csv','/home/arthur/Documents/redes_neurais/singlenetwork/temp.csv',20,0.1,20,'target')
# # difftime(Sys.time(), now, units = "secs")
#
# index<-createDataPartition(iris$Species,p=0.7,list=FALSE)
# irisTrain<-iris[index,]
# irisTest<-iris[-index,]

