# Szukseges library-k importalasa
require(rvest)

# Fuggveny a Wikipedia oldalak szovegenek tisztitasahoz
clean<-function(text){
  # A tab, illetve az uj sort jelolo karakterek eltavolitasa
  text<-gsub("[\r\n\t]", " ", text)
  
  # Az osszes nem szam es betu tipusu karakter kicserelese szokozre
  text<-gsub("[^[:alnum:] ]", " ", text)
}

# A veletlenszeruen kivalasztando Wikipedia oldalak szama
num<-200

# (Egyelore) ures data frame a Wikipedia oldalak adatainak eltarolasara
wiki_data<-data.frame()

# A Wikipedia oldalak adatainak osszegyujtese egy ciklusban
print("Parsing in progress...")
for (i in 1:num){
  print(i)
  # A random Wikipedia oldalt generalo webcim megnyitasa
  random_wikipage<-read_html("https://en.wikipedia.org/wiki/Special:Random")
  
  # A Wikipedia oldal cimenek meghatarozasa es tisztitasa
  wiki_title<-random_wikipage %>%
    html_node("h1") %>%
    html_text() %>%
    clean 
  
  # A Wikipedia oldal szovegenek kinyerese es tisztitasa
  wiki_text<-random_wikipage %>%
    html_nodes("div #mw-content-text p") 
  wiki_text<-lapply(wiki_text, html_text)
  wiki_text<-paste(wiki_text, collapse=" ")
  wiki_text<-clean(wiki_text)

  # Az oldal kategoriajat jelolo kifejezesek kinyerese es tisztitasa
  wiki_categories<-random_wikipage %>%
    html_nodes("div #mw-normal-catlinks li")
  wiki_categories<-lapply(wiki_categories, html_text)
  wiki_categories<-paste(wiki_categories, collapse=" ")
  wiki_categories<-clean(wiki_categories)
  
  # Az eredmeny elmentese
  temp<-data.frame(title=wiki_title,
                   text=wiki_text,
                   category=wiki_categories)
  wiki_data<-rbind(wiki_data,temp)
}

print("Parsing successful, writing to file...")
# A Wikipedia oldalak kinyert tartalmanak fajlba irasa
write.csv(wiki_data, "wiki_corpus.csv")
