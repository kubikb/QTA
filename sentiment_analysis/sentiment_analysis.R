# Szukseges library-k importalasa
library(qdap)
library(RCurl)
library(tm)

Sys.setlocale('LC_ALL','C') 

# A relevans New York Times cikk szovegenek beolvasasa
nyt <- getURL("http://qta.tk.mta.hu/uploads/files/nyt.txt",
                  .encoding = 'ASCII')

# A relevans Washington Post cikk szovegenek beolvasasa
wp <- getURL("http://qta.tk.mta.hu/uploads/files/wp.txt",
                  .encoding = 'ASCII')

# A relevans CNN cikk szovegenek beolvasasa
cnn <- getURL("http://qta.tk.mta.hu/uploads/files/cnn.txt",
                  .encoding = 'ASCII')

# A relevans Wall Street Journal cikk szovegenek beolvasasa
wsj <- getURL("http://qta.tk.mta.hu/uploads/files/wsj.txt",
                  .encoding = 'ASCII')
print("Database successfully downloaded!")

#################### A New York Times cikk feldolgozasa ####################
print("Processing New York Times...")
# A szoveg mondatokra bontasa
text_df <- as.data.frame(nyt)
split_text <- sentSplit(text_df, text.var = colnames(text_df), verbose=F)
colnames(split_text) <- c("tot", "sentence")

# A vesszok korrekcioja
split_text$sentence <- comma_spacer(split_text$sentence)

# A polaritas kiszamitasa
polarity_measures <- polarity(split_text$sentence)

# Az atfogo polaritasi ertekek megjelenitese
print("Polarity measures:")
print(polarity_measures$group)

# A kiszurt pozitiv jelentestartalmu kifejezesek megjelenitese
pos_words <- sort(unique(unlist(polarity_measures$all$pos.words)))
print("Positive words:")
print(pos_words)

# A kiszurt negativ jelentestartalmu kifejezesek megjelenitese
neg_words <- sort(unique(unlist(polarity_measures$all$neg.words)))
print("Negative words:")
print(neg_words)

#################### A Washington Post cikk feldolgozasa ####################
print("Processing Washington Post...")
# A szoveg mondatokra bontasa
text_df <- as.data.frame(wp)
split_text <- sentSplit(text_df, text.var = colnames(text_df), verbose=F)
colnames(split_text) <- c("tot", "sentence")

# A vesszok korrekcioja
split_text$sentence <- comma_spacer(split_text$sentence)

# A polaritas kiszamitasa
polarity_measures <- polarity(split_text$sentence)

# Az atfogo polaritasi ertekek megjelenitese
print("Polarity measures:")
print(polarity_measures$group)

# A kiszurt pozitiv jelentestartalmu kifejezesek megjelenitese
pos_words <- sort(unique(unlist(polarity_measures$all$pos.words)))
print("Positive words:")
print(pos_words)

# A kiszurt negativ jelentestartalmu kifejezesek megjelenitese
neg_words <- sort(unique(unlist(polarity_measures$all$neg.words)))
print("Negative words:")
print(neg_words)

#################### A CNN cikk feldolgozasa ####################
print("Processing CNN...")
# A szoveg mondatokra bontasa
text_df <- as.data.frame(cnn)
split_text <- sentSplit(text_df, text.var = colnames(text_df), verbose=F)
colnames(split_text) <- c("tot", "sentence")

# A vesszok korrekcioja
split_text$sentence <- comma_spacer(split_text$sentence)

# A polaritas kiszamitasa
polarity_measures <- polarity(split_text$sentence)

# Az atfogo polaritasi ertekek megjelenitese
print("Polarity measures:")
print(polarity_measures$group)

# A kiszurt pozitiv jelentestartalmu kifejezesek megjelenitese
pos_words <- sort(unique(unlist(polarity_measures$all$pos.words)))
print("Positive words:")
print(pos_words)

# A kiszurt negativ jelentestartalmu kifejezesek megjelenitese
neg_words <- sort(unique(unlist(polarity_measures$all$neg.words)))
print("Negative words:")
print(neg_words)

#################### A Wall Street Journal cikk feldolgozasa ####################
print("Processing Wall Street Journal...")
# A szoveg mondatokra bontasa
text_df <- as.data.frame(wsj)
split_text <- sentSplit(text_df, text.var = colnames(text_df), verbose=F)
colnames(split_text) <- c("tot", "sentence")

# A vesszok korrekcioja
split_text$sentence <- comma_spacer(split_text$sentence)

# A polaritas kiszamitasa
polarity_measures <- polarity(split_text$sentence)

# Az atfogo polaritasi ertekek megjelenitese
print("Polarity measures:")
print(polarity_measures$group)

# A kiszurt pozitiv jelentestartalmu kifejezesek megjelenitese
pos_words <- sort(unique(unlist(polarity_measures$all$pos.words)))
print("Positive words:")
print(pos_words)

# A kiszurt negativ jelentestartalmu kifejezesek megjelenitese
neg_words <- sort(unique(unlist(polarity_measures$all$neg.words)))
print("Negative words:")
print(neg_words)
