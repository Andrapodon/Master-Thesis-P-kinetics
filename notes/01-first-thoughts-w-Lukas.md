# Anova

simple: y ~ 1
categorical: y ~ as.factor(t)

y' = y^n
y' = y


y ~ ln(t) - linear? == y/ln(t) ~ 1
--> überprüfe indem wir uns fragen ob: "y/ln(t) ~ as.factor(t)" daten besser erklärt als "y/ln(t) ~ 1" == one-way ANOVA

y ~ 1/t  - 2te ordnung?


---

H2O
Lösungsmittel
--> Differenz

Tongehalt

Kinetik = funktion(messwerte-über-zeit)
    Wie stark wird das restliche (mässig labile = Differenz) in wasser mit der Zeit gelöst
    Kinetik ~ Differenz  (wir erwarten gute korrelation)


Entzug  (Phosphor)
GE  (GemessenErtrag)
WP  (Wünschen Phosphor)
WE  (Wünschen Ertrag)

Bodenarten x Dünungen

Frage: ist unsere kinetik hilfreich?  (Ertrag Analog)
Entzug ~            Bodentyp + H2O + Lösungsmittel 
Entzug ~ f(Kinetik)*Bodentyp + H2O + Lösungsmittel 
--> 2 ML-modelle (XGboost) + CrossValidation: ist das hinzufügen von Kinetik hilfreich?
    wir müssen hier f() nicht kennen -- ML-modell dies selber herausfinden kann
        problem: das extrahieren von f() ist nicht trivial

Versuche f() herauszufinden -> vorschlag g()  (zB median von ableitungen)
--> vergleiche wie oben die zwei modelle hier
Entzug ~ f(Kinetik)*Bodentyp + H2O + Lösungsmittel 
Entzug ~ g(Kinetik)*Bodentyp + H2O + Lösungsmittel 

==> somit haben wir eine kenngrösse für die kinetik (d.h. f() geschätzt)
==> Bauer: misst seine Kinetik -> wissen wie viel er düngen muss um Enzug/Ertrag zu optimieren

---

# Datenerhebung
Kinetik:
6 Zeitpunkte machen
0 5 10 20 30 45 60

4 * 6 * 6   * 1 Zeitpunk    wie viel kostet jeder weitere Zeitpunkt
