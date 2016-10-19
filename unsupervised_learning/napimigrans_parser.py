# -*- coding: utf-8 -*-

# A szükséges library-k importálása
from bs4 import BeautifulSoup
import requests
import csv

# Aloldalak meghatározása
url = "http://napimigrans.com/"
depth = 15 # A "mélység", tehát a feldolgozni kívánt aloldalak száma
subpages = ["%spage/%s/" %(url, str(item)) for item in range(1, depth + 1)]
print u"Feldolgozandó aloldalak a következők:"
print subpages

# Ures lista az egyes cikkekre mutato kozvetlen linkek elmentesehez
direct_urls = []

# A aloldalak megnyitasa es az egyes cikkekre mutato kozvetlen linkek elmentese
for subpage_url in subpages:
    # Az aloldal megnyitása es BeautifulSoup objektummá való alakítása
    try:
        subpage_content = requests.get(subpage_url).text
        subpage_soup = BeautifulSoup(subpage_content, 'html.parser')
        # Az "article" tagek kinyerése
        articles = subpage_soup.findAll("article")
        # A webcímek kinyerése az "article" tag-ekből, majd ezek hozzáadása a korábban definiált "direct_urls" listához
        direct_urls += [item.find("a").get("href") for item in articles]
        print u"%s feldolgozva." %subpage_url
    except Exception, e:
        print u"Hiba %s feldolgozásakor: %s" %(subpage_url, e)

print u"A direkt hiperlinkek száma %s." %len(direct_urls)

# Üres lista a cikkszövegek eltárolásához
article_texts = []

# Az egyes cikkek szövegének kinyerése
for direct_url in direct_urls:
    try:
        # Az aloldal megnyitása es BeautifulSoup objektummá való alakítása
        subpage_content = requests.get(direct_url).text
        subpage_soup = BeautifulSoup(subpage_content, 'html.parser')
        # A szövegparagrafusok kinyerése es tisztítása
        text_paragraphs = [" ".join(item.getText().split()) for item in subpage_soup.findAll("p")]
        # A paragrafusok összefűzése egy szöveggé
        text = " ".join(text_paragraphs)
        # A korábban definiált "article_texts" nevű listához való hozzáadása
        url_data = [direct_url, text]
        if url_data not in article_texts:
            article_texts.append(url_data)
        print u"Szöveg kinyerve a következő linkről: %s" %direct_url
    except Exception, e:
        print u"Hiba %s feldolgozásakor: %s" %(direct_url, e)

print u"Az összegyűjtött cikkszövegek száma: %s" %len(article_texts)

# A művelet eredményének elmentése. Ne felejtsük el módosítani a fájl (leendő) helyét!
with open("napimigrans_corpus.csv", "wb") as f:
    writer = csv.writer(f, delimiter="\t")
    writer.writerows(map(lambda x: [x[0], x[1].encode("utf-8")], article_texts))