#Szukseges library-k
require(xgboost)
require(tm)
require(readr)
require(wordcloud)

set.seed(1)

#Adatok letoltese es beolvasasa
temp <- tempfile()
download.file("http://congressionalbills.org/billfiles/bills93-113.zip", temp)
congressData <- read_delim(unz(temp, "bills93-113.txt"), delim="\t")
unlink(temp)

#Szures a 113. kongresszusra, a valos kozpolitikai kodokra, illetve az irrelevans valtozok kiszurese
congressData<-congressData[congressData$Cong=="113" & congressData$Major!="99",
               c("id","Major","Title")]

#A tobb kozpolitikai koddal is rendelkezo szovegek kiszurese
congressData<-congressData[duplicated(congressData$Title)==FALSE,]

#A fo kozpolitikai kodok faktorra alakitasa
levels <- sort(unique(congressData$Major))
congressData$Major2 <- as.numeric(factor(congressData$Major, levels=levels))-1

#Data frame, mely az uj faktorvaltozot az eredeti kozpolitikai kodokhoz rendeli
oldNew<-unique(congressData[,c("Major","Major2")])

#A Title oszlop VCorpus-sza valo atalakitasa
titleCorpus<-VCorpus(VectorSource(unique(congressData$Title)))

#Kisbetusites
titleCorpus <- tm_map(titleCorpus, content_transformer(tolower))

#Stopszavak eltavolitasa
titleCorpus <- tm_map(titleCorpus, removeWords, stopwords("english"))

#Irasjelek eltavolitasa
titleCorpus <- tm_map(titleCorpus, removePunctuation)

#A dokumentum-kifejezés mátrix kialakítása
titleDTMatrix <- DocumentTermMatrix(titleCorpus)
titleDTMatrix <- data.matrix(titleDTMatrix)

#Kifejezes gyakorisagi matrix eloallitasa
termFrequencies <- colSums(titleDTMatrix)
termFrequencies <- sort(termFrequencies, decreasing = TRUE)
wordcloud(names(termFrequencies), 
          termFrequencies, 
          min.freq = 150)

#A dokumentum-kifejezes matrix training, illetve testing setre valo bontasa
train_ind<-sample(seq_len(nrow(titleDTMatrix)), size = 4000)
train <- titleDTMatrix[train_ind, ]
test<- titleDTMatrix[-train_ind,]

#Az XGBoost szamara konnyebben ertelmezheto DMatrix-okka valo konvertalas
dtrain <- xgb.DMatrix(train, label = congressData$Major2[train_ind])
dtest <- xgb.DMatrix(test, label = congressData$Major2[-train_ind])

#Felugyelt tanulasi modell epitese
model <- xgb.train(data      = dtrain,
                 booster     = "gbtree",
                 num_class   = 20,
                 nrounds     = 100,
                 objective   = "multi:softmax",
                 eval_metric = "merror",
                 watchlist   = list(eval = dtest, train = dtrain),
                 early.stop.round = 10,
                 set.seed        = 1)

# Becsult osztalyhovatartozasok kinyerese a tanito es a teszthalmazra
train_predictions <- predict(model, dtrain)
test_predictions <- predict(model, dtest)
