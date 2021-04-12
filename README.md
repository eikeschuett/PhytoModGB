# PhytoModGB

## To do

- [x] Chl predictions in schöner Karte (z.B. aus dem rasterVis-package) zeigen  
- [x] Chl prediction für eine schöne Frühjahrsblüte machen und Parameter optimieren
- [x] net und gross primary production berechnen 
- [ ] PP für alle Szenarien schön plotten
- [x] Difference Plots zwischen den Szenarien erstellen
- [ ] Ergebnisse inhaltlich überprüfen (ergibt das Sinn?)
- [ ] nc-Files auf Datenkohärenz überprüfen
- [x] spatially integrated net primary production GB berechnen, Bezug globale PP 
- [ ] Result, Discussion, Conclusion schreiben (an Angaben halten)
- [ ] README vor Abgabe schön machen

## Update 2021-04-09
- NPP und GPP geplottet für verschiedene Szenarien aber nicht in rasterVis (hat nicht geklappt mit nc-file)
- Unterschiede bei NPP sehr gering für die Szenarien (warum?)
- Ergebnisse bisher nur zwischengespeichert und dann im Plot abgerufen, Loops hintereinander hat nicht funktioniert und ist sehr viel Code (doppelt bis auf kleine Änderungen)

## Update 2021-04-08
Wir haben an den Parametern weiter rumgeschraubt. Das hat sich allerdings etwas schwierig gestaltet. Entweder die Vorhersage ist im Küstenbereich recht gut und dafür offshore schlecht oder anders herum. Müssten wir uns vielleicht noch mal zusammen einigen. Wir haben uns auf das Jahr 2018 ausgesucht. Da gab es gute Ergebnisse und es ist im Vergleich recht aktuell. 
Ansonsten haben wir noch mit der Modellierung angefangen. Die Skripte sind noch recht unaufgeräumt und manches funktioniert noch nicht ganz aber wir sind weiter dran :)

## Update 2021-03-30
Ich habe mal mein Chl Model ein bisschen angepasst, aufgeräumt und die Funktionen an die angepasst, die auch im Manuskript in Sciflow stehen (Markus hatte an manchen Stellen andere Funktionen als Kai benutzt, die aber letztlich das gleiche ergeben [sollten :D]). Vielleicht können wir ja daran weiter arbeiten, dann haben wir einen gemeinsamen Stand :) Ihr könnt sehr gerne noch weiter aufräumen und verändern und so.
