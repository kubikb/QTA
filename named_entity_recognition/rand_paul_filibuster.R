# Fejlesztõ: Kubik Bálint György

# Library-k importálása
require(RCurl)
require(openNLP)
require(NLP)

# Az névelem-felismerés mûveletéhez szükséges modellek letöltése (74,2 MB-os fájl)
install.packages("openNLPmodels.en", repos = "http://datacube.wu.ac.at/", type = "source")

# A filibuster szovegenek beolvasasa az internetrol
text <- getURL("http://qta.tk.mta.hu/uploads/files/rand_paul_filibuster.txt",
              .encoding = 'ASCII')

# A szoveg hossza
print("Length of the text in characters:")
nchar(text)
# 519.620 karakterbol all a szoveg szokozokkel egyutt

print("Length of the text in characters without spaces:")
nchar(gsub(" ","",text))
# A szoveg tehat 427.492 karakterbol all szokozok nelkul

# A szavak szamanak kinyerese
print("Number of words in text:")
length(strsplit(text,' ')[[1]])
# 92.129 szo talalhato a szovegben

# Annotatorok betoltese
word_annotator <- Maxent_Word_Token_Annotator()
sent_annotator <- Maxent_Sent_Token_Annotator()
person_annotator <- Maxent_Entity_Annotator(kind = "person")
location_annotator <- Maxent_Entity_Annotator(kind = "location")
#organization_annotator <- Maxent_Entity_Annotator(kind = "organization")
print("Annotators loaded.")

# Az un. "pipeline" kialakitasa
pipeline <- list(sent_annotator,
                 word_annotator,
                 person_annotator,
                 location_annotator)
                 #organization_annotator)

# Annotalas (a resz futasideje hosszabb idot vehet igenybe)
print("Annotation is in progress...")
text_annotations <- annotate(text, pipeline)
annotated_text <- AnnotatedPlainTextDocument(text, text_annotations)
print("Annotation has been successful!")

# Segedfuggveny az entitasok kinyeresere (forras: https://rpubs.com/lmullen/nlp-chapter)
entities <- function(doc, kind) {
  s <- doc$content
  a <- annotations(doc)[[1]]
  if(hasArg(kind)) {
    k <- sapply(a$features, `[[`, "kind")
    s[a[k == kind]]
  } else {
    s[a[a$type == "entity"]]
  }
}

# A vizualizációhoz szükséges library betöltése
require(ggplot2)

# Beazonositott szemelynevek megjelenitese
persons <- table(entities(annotated_text, "person"))
word_frequencies <- data.frame(word=names(persons), freq=as.numeric(persons))
word_frequencies <- word_frequencies[order(-word_frequencies$freq),]
print("Top persons:")
head(word_frequencies)
c <- ggplot(word_frequencies[1:10,], aes(reorder(word, -freq), freq))
c + geom_bar(stat="identity", 
             width=.5,
            fill="blue") + 
  theme(axis.text.x=element_text(angle=45, hjust=1)) + 
  xlab("Személynév") + ylab("Gyakoriság")

# Beazonositott földrajzi nevek megjelenitese
locations <- table(entities(annotated_text, "location"))
word_frequencies <- data.frame(word=names(locations), freq=as.numeric(locations))
word_frequencies <- word_frequencies[order(-word_frequencies$freq),]
print("Top locations:")
head(word_frequencies)
c <- ggplot(word_frequencies[1:10,], aes(reorder(word, -freq), freq))
c + geom_bar(stat="identity", 
             width=.5,
             fill="blue") + 
  theme(axis.text.x=element_text(angle=45, hjust=1)) + 
  xlab("Földrajzi név") + ylab("Gyakoriság")

# Beazonositott szervezetnevek megjelenitese
#organizations <- table(entities(annotated_text, "organization"))
#word_frequencies <- data.frame(word=names(organizations), freq=as.numeric(organizations))
#word_frequencies <- word_frequencies[order(-word_frequencies$freq),]
#c <- ggplot(word_frequencies[1:10,], aes(reorder(word, -freq), freq))
#c + geom_bar(stat="identity", 
#             width=.5,
#             fill="blue") + 
#  theme(axis.text.x=element_text(angle=45, hjust=1)) + 
#  xlab("Szervezetnév") + ylab("Gyakoriság")

