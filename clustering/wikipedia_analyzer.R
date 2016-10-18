# Szukseges library-k importalasa
require(tm)

# A szovegkorpuszt tartalmazo fajl megnyitasa
corpus <- read.csv("http://qta.tk.mta.hu/uploads/files/wiki_corpus.csv")
print("Database successfully downloaded!")

# Szures az elso szaz elemre
corpus <- corpus[1:100, ]

# VCorpus objektumma valo alakitas
wiki_corpus<-VCorpus(VectorSource(corpus$text))

# A folosleges whitespace-ek eltavolitasa
wiki_corpus<- tm_map(wiki_corpus, stripWhitespace)

# Kisbetusites
wiki_corpus <- tm_map(wiki_corpus, content_transformer(tolower))

# Stopszavak eltavolitasa
wiki_corpus <- tm_map(wiki_corpus, removeWords, stopwords("english"))

# Szotovezes
wiki_corpus <- tm_map(wiki_corpus, stemDocument)
print("Text preprocessing has been successful!")

# Dokumentum-kifejezes matrix kialakitasa
wiki_dtm <- DocumentTermMatrix(wiki_corpus,
                               control=list(weighting =
                                            function(x) weightTfIdf(x, normalize=FALSE)))

# Dokumentumok cimeinek hozzarendelese
rownames(wiki_dtm) <- corpus$title
print("Document-term matrix successfully obtained!")

# Szorvanyos elemek kiszurese
wiki_dtm <- removeSparseTerms(wiki_dtm, 0.95)

# Leggyakoribb elemek
findFreqTerms(wiki_dtm)

# Hiearchikus klaszterezes
print("Clustering in progress...")
wiki_dist <- dist(wiki_dtm, method = "euclidean")
fit <- hclust(wiki_dist, method="ward") 
plot(fit)
print("Clustering successful!")

# A fa 5 csoportra valo vagasa
groups <- cutree(fit, k=8)

# Az ot csoport jelolese az elozo dendrogrammon
rect.hclust(fit, k=8, border="red")
