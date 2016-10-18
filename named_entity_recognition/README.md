# Rand Paul közel 11 órás filibuster-ének elemzése a névelem-felismerés módszerével
A fenti R szkript Rand Paul 2015. május 20-i közel 11 órás felszólalásának elemzését végzi el a névelem-felismerés módszerével (Named Entity Recognition). A szenátor a Patriot Act nevű törvény megújítása ellen tiltakozott az amerikai politikában ismert _filibusterrel_, melynek célja a törvényhozási munka akadályozása az adott kérdésben. 

# A (politikatudományi) probléma
A méretes szöveg számos személynevet, helységnevet és szervezetnevet tartalmaz, melyeket szeretnénk kinyerni. A szöveg átolvasására és a releváns nevek kigyűjtésére ugyanakkor nincs elegendő kapacitásunk. A névelem-felismerés módszere itt igen nagy segítségünkre van. 