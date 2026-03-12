# Voxa – Wissenschaftliche Grundlage zu Stimme, Pitch, Resonanz und wahrgenommener Geschlechtlichkeit

Dieses Dokument bündelt die wissenschaftliche Basis für **Voxa**, einen Voice-Trainer mit Fokus auf gender-affirmende Stimmarbeit. Es dient als fachliche Grundlage für Produktentscheidungen, Zielbereiche, Feedback-Logik und Sicherheitshinweise in der App.

## 1. Ziel und Grundannahmen

Voxa soll Nutzer:innen dabei unterstützen, ihre Stimme bewusster zu steuern und Trainingsziele nachvollziehbar zu verfolgen. Die App arbeitet dabei **nicht** mit starren oder normativen Regeln, sondern mit **wahrscheinlichkeitsbasierten Heuristiken**. Eine Stimme wird nicht allein über ihre Grundfrequenz wahrgenommen. Pitch ist wichtig, aber nicht alles.

Die Forschung zeigt:

- Die **sprechbezogene Grundfrequenz** (*speaking fundamental frequency*, SFF bzw. f0) ist der stärkste einzelne akustische Hinweisreiz für die Wahrnehmung von Geschlecht in der Stimme.
- Sie erklärt aber **nicht die gesamte Wahrnehmung**. In einer systematischen Übersichtsarbeit mit Meta-Analyse erklärte Pitch etwa **41,6 % der Varianz** in der Geschlechtswahrnehmung. Auch **Resonanz/Formanten, Intonation, Artikulation und Lautheit** tragen zur Wahrnehmung bei.[4]
- Daraus folgt für Voxa: **Pitch darf der Hauptindikator sein, aber nie der einzige.**

## 2. Wie Stimme entsteht

Stimme entsteht durch das Zusammenspiel von **Atmung, Kehlkopf/Vocal Folds und Vokaltrakt**.

- Im **Kehlkopf** schwingen die Stimmlippen. Diese Schwingungsfrequenz ist die physikalische Grundlage der **Grundfrequenz f0**.[1]
- Eine stärkere **Längung und Spannung** der Stimmlippen – unter anderem durch den Musculus cricothyroideus – führt typischerweise zu **höherer Phonation**.[1]
- Der **Vokaltrakt** (Rachen, Mundraum, Zunge, Lippen usw.) formt den Klang weiter. Dabei entstehen **Formanten** bzw. Resonanzeigenschaften, die wesentlich dazu beitragen, ob eine Stimme eher heller, dunkler, kleiner, größer, maskuliner oder femininer wirkt.[3][4]

Für die App bedeutet das:

1. **Pitch/F0** ist gut messbar und eignet sich als Kernmetrik.
2. **Resonanz** ist für die Wahrnehmung entscheidend, aber technisch schwerer zuverlässig zu messen.
3. **Prosodie** (Intonation, Melodieverlauf, Sprechweise) verändert die Wahrnehmung zusätzlich.

## 3. Welche Stimmmerkmale für die Wahrnehmung besonders wichtig sind

### 3.1 Pitch / Grundfrequenz

Pitch ist die wahrgenommene Tonhöhe; akustisch wird sie vor allem durch die Grundfrequenz f0 beschrieben. Für Voxa ist die **sprechbezogene Grundfrequenz in zusammenhängender Sprache** die wichtigste Kennzahl, nicht nur ein einzelner Vokal oder ein kurz gehaltener Ton.[3][4]

### 3.2 Resonanz / Formanten

In der Forschung zeigen sich **Formanten bzw. Resonanzeigenschaften** als besonders wichtig, wenn die Pitch-Lage nicht eindeutig ist. Gerade im Bereich zwischen etwa **145 und 165 Hz** wird Geschlechtswahrnehmung deutlich stärker davon beeinflusst, wie der Vokaltrakt klingt.[3]

### 3.3 Intonation und Prosodie

Nicht nur die mittlere Höhe, auch der **Melodieverlauf** spielt eine Rolle. Bereits ältere Arbeiten zeigten, dass Stimmen, die als weiblich kategorisiert wurden, sich nicht nur in der mittleren f0, sondern auch in **Intonationsmustern** von Stimmen unterschieden, die als männlich kategorisiert wurden.[5]

### 3.4 Artikulation, Lautheit und Sprechstil

Die Meta-Analyse von Leung et al. fand Zusammenhänge zwischen Geschlechtswahrnehmung und **Resonanz, Lautheit, Artikulation und Intonation**. Tempo und Stress waren hingegen deutlich weniger konsistent.[4]

## 4. Was die Forschung zu typischen Bereichen sagt

Die Literatur arbeitet häufig mit erwachsenen Vergleichsgruppen von Männern und Frauen in Lese- oder Sprechaufgaben. Diese Normwerte sind **kontextabhängig**: Sprache, Alter, Aufgabe, Sprechlautstärke und Messmethode verändern die Ergebnisse. Deshalb sollte Voxa nie nur einen einzigen "richtigen" Zielwert anzeigen.

### 4.1 Typische Bereiche in Normstudien

Eine häufig zitierte Normstudie berichtet für komfortables Lesen bei Erwachsenen ungefähr folgende Bereiche:[7]

- **Männer:** etwa **107–140 Hz**
- **Frauen:** etwa **170–240 Hz**

Eine weitere populationsbezogene Studie fand – je nach Lautstärkeniveau – Mittelwerte von ungefähr **111,8–130,2 Hz** bei Männern und **161,3–198,0 Hz** bei Frauen.[6]

Diese Zahlen sprechen für Folgendes:

- Ein **typisch maskuliner Sprechbereich** liegt oft grob im Bereich von **ca. 100–145 Hz**.
- Ein **typisch femininer Sprechbereich** liegt oft grob im Bereich von **ca. 165–240 Hz**.
- Dazwischen liegt kein klar leerer Raum, sondern ein **Überlappungs- und Übergangsbereich**.

## 5. Was die Forschung zu "maskulin", "androgyn" und "feminin wahrgenommen" nahelegt

Für **androgyn** gibt es in der Forschung keine einheitliche medizinische Grenzziehung. Es ist sinnvoller, androgyn in Voxa als **Design- und Trainingskategorie** zu verstehen: als Bereich, in dem Wahrnehmung besonders stark von mehreren Faktoren gleichzeitig abhängt.

### 5.1 Zentrale Befunde für Übergangsbereiche

- In einer experimentellen Studie waren **145, 155 und 165 Hz** ausdrücklich die **mehrdeutigen bzw. überlappenden Testbereiche**; dort wurden Formanten besonders wichtig für die Geschlechtswahrnehmung.[3]
- Dieselbe Studie zeigte, dass männliche Sprecher bei **165 Hz und höher** weniger eindeutig als männlich wahrgenommen wurden.[3]
- Eine frühere Studie fand: Die **niedrigste durchschnittliche f0**, die noch als weiblich identifiziert wurde, lag bei **155 Hz**.[5]
- Eine weitere Studie zeigte, dass Stimmen, die als weiblich wahrgenommen wurden, im Mittel eine **höhere SFF** und eine **höhere obere SFF-Grenze** hatten als Stimmen, die als männlich wahrgenommen wurden.[2]

### 5.2 Wissenschaftlich informierte Voxa-Heuristik

Aus der Literatur lässt sich für Voxa folgende **produktseitige Heuristik** ableiten. Das sind **keine harten biologischen Grenzen**, sondern sinnvolle Trainings- und UI-Bereiche:

| Bereich | Wissenschaftliche Einordnung | Voxa-Preset / Interpretation |
|---|---|---|
| **100–145 Hz** | liegt nah an typischen maskulinen Sprechbereichen in Normstudien[6][7] | **Maskulin** |
| **145–165 Hz** | besonders mehrdeutiger Bereich; Resonanz/Formanten sehr wichtig[3] | **Androgyn / Ambiguous Core** |
| **155–175 Hz** | weibliche Wahrnehmung ist möglich, aber stark von Resonanz, Intonation und Sprechstil abhängig[3][5] | **Androgyn → Feminin** |
| **165–185 Hz** | sinnvoller Trainingskorridor für viele transfeminine Nutzer:innen; Pitch allein reicht hier oft noch nicht[3][4][5] | **Feminin – Einstieg** |
| **185–220 Hz** | liegt klarer in typischen femininen Bereichen[6][7] | **Feminin – stabil** |
| **220+ Hz** | weiterhin feminin möglich, aber für viele Sprecher:innen im Alltag auf Dauer anstrengender oder weniger natürlich | **Feminin – hoch** |

## 6. Produktentscheidung für Voxa

### 6.1 Presets

Auf Basis der Forschung sind diese Presets sinnvoll:

- **Masculine preset:** `100–145 Hz`
- **Androgynous preset:** `145–175 Hz`
- **Feminine preset:** `165–220 Hz`

Wichtig: Die Bereiche **überlappen bewusst**. Geschlechtswahrnehmung verändert sich graduell, nicht binär. Ein 170-Hz-Ziel kann je nach Resonanz und Prosodie deutlich femininer oder eher neutral wirken.

### 6.2 Was die App messen sollte

Voxa sollte nicht nur einen Momentanwert anzeigen, sondern mehrere Metriken unterscheiden:

1. **Median oder gleitender Median der f0** in stimmhaften Abschnitten
2. **Pitch-Range / IQR** statt nur Peak-Werte
3. **oberer und unterer Sprechbereich** in zusammenhängender Sprache
4. **Sitzungstrend über Zeit** statt Einzelmessung
5. **Subjektives Belastungsrating** nach jeder Session

Warum? Ein einzelner Peak sagt wenig aus. Wissenschaftlich relevanter ist die **habitual speaking pitch** in verbundenem Sprechen.[2][3][4]

### 6.3 Was die App später zusätzlich abbilden sollte

Für spätere Versionen sind folgende Features wissenschaftlich sinnvoll:

- **Resonanz-/Brightness-Feedback** als zweiter Hauptkanal neben Pitch
- **Prosodie-Training** (Melodiebögen, Satzintonation, Variabilität)
- **Transfer in Alltagssprache**, nicht nur gehaltene Töne
- **unterschiedliche Zielprofile**: soft feminine, bright feminine, neutral/androgynous, soft masculine, grounded masculine

## 7. Besonderheiten für trans, nichtbinäre und genderdiverse Nutzer:innen

### 7.1 Transfeminine Stimmen

Für trans Frauen verändert eine feminisierende Hormonbehandlung die Stimme in der Regel **nicht automatisch** in Richtung höherer Sprechlage. Entsprechend sind **Stimmtraining** und ggf. weitere Maßnahmen klinisch relevant.[8]

Eine systematische Übersichtsarbeit fand positive Ergebnisse von Stimmtherapie unter anderem für **Pitch-Anstieg, Resonanz, Selbstwahrnehmung und Fremdwahrnehmung**, weist aber gleichzeitig auf methodische Grenzen der Evidenz hin.[8]

### 7.2 Transmaskuline Stimmen

Testosteron senkt die Grundfrequenz häufig deutlich. In einer longitudinalen Studie lag die mittlere f0 nach 12 Monaten bei **125 Hz**, allerdings mit deutlicher interindividueller Streuung.[9]

Wichtig für Voxa: Auch bei transmaskulinen Nutzer:innen ist Pitch **nicht alles**. Manche berichten trotz Testosteron über eine Diskrepanz zwischen **habitual pitch** und **passing pitch** oder über Stimmermüdung, Instabilität und weiteren Unterstützungsbedarf.[9][10]

### 7.3 Nichtbinäre Stimmen

Nichtbinäre Ziele sind wissenschaftlich besonders schlecht normiert. Für Voxa sollte deshalb gelten:

- keine Defizitlogik
- frei wählbare Zielbereiche
- mehrere Presets und Mischprofile
- Fokus auf **stimmliche Selbstkongruenz** statt auf Fremdzuordnung allein

## 8. Sicherheit und Vocal Health

Voxa sollte Training nicht nur effektiver, sondern auch **stimmgesund** machen. Zu hohe oder dauerhaft gepresste Phonation kann belasten. Allgemein gelten als sinnvolle Basishinweise:

- ausreichend trinken
- nicht in Heiserkeit hinein trainieren
- Extreme wie Schreien oder forciertes Flüstern vermeiden
- bei anhaltender Heiserkeit, Schmerzen, starkem Räusperzwang oder deutlicher Erschöpfung fachlich abklären lassen[11][12]

App-seitig sinnvoll:

- Session-Limits
- Fatigue-Check nach Sessions
- Warnhinweis bei wiederholten Belastungssymptomen
- Hinweis auf Logopädie / Stimmtherapie / HNO / Phoniatrie bei Problemen

## 9. Konkrete Design-Prinzipien für Voxa

1. **Pitch als Hauptsignal, aber nicht als Wahrheit.**
2. **Überlappende Zielbereiche statt harter Schwellen.**
3. **Klare Kommunikation, dass Resonanz und Prosodie mitentscheiden.**
4. **Nichtbinäre und individuelle Zielsetzung als Standard mitdenken.**
5. **Alltagssprache höher gewichten als isolierte Töne.**
6. **Gesundheits- und Belastungshinweise fest integrieren.**

## 10. Vorschlag für In-App-Texte

### Kurztext für den Goal-Setting-Screen

> Deine Stimme wird nicht nur über Pitch wahrgenommen. Pitch ist ein wichtiger Teil, aber auch Resonanz, Intonation und Sprechweise beeinflussen, ob eine Stimme eher maskulin, androgyn oder feminin wirkt. Die Zielbereiche in Voxa sind deshalb Richtwerte, keine festen Regeln.

### Kurztext für den Feminine-Preset

> Viele Stimmen werden ab etwa 155–165 Hz nicht mehr eindeutig maskulin wahrgenommen. Wirklich feminin wirkt eine Stimme aber meist erst im Zusammenspiel aus Pitch, Resonanz und Sprechweise.

### Kurztext für den Androgynous-Preset

> Der androgynous Bereich ist kein fester medizinischer Standard, sondern ein bewusster Übergangsbereich. Hier beeinflussen Resonanz und Prosodie die Wahrnehmung besonders stark.

## 11. Relevante Referenznoten für die UI

Diese Noten sind für Pitch-Anzeigen in Voxa praktisch:

| Frequenz | Note |
|---|---|
| 110.0 Hz | A2 |
| 123.5 Hz | B2 |
| 130.8 Hz | C3 |
| 146.8 Hz | D3 |
| 155.6 Hz | D#3 / Eb3 |
| 164.8 Hz | E3 |
| 174.6 Hz | F3 |
| 185.0 Hz | F#3 / Gb3 |
| 196.0 Hz | G3 |
| 207.7 Hz | G#3 / Ab3 |
| 220.0 Hz | A3 |

## 12. Kurzfazit

Die wissenschaftliche Literatur stützt klar, dass **Pitch ein zentraler, aber nicht hinreichender Faktor** für die Wahrnehmung von Geschlecht in der Stimme ist. Für Voxa bedeutet das:

- Pitch-Messung ist sinnvoll und evidenznah.
- Übergangsbereiche müssen bewusst als **mehrdeutig** kommuniziert werden.
- **Androgyn** ist am besten als produktseitige Zielkategorie zwischen klarer maskuliner und klarer femininer Wahrnehmung zu verstehen.
- Die besten Nutzer:innenergebnisse sind zu erwarten, wenn Voxa mittelfristig **Pitch + Resonanz + Prosodie + Belastung** gemeinsam betrachtet.

---

## Quellen

[1] Suárez-Quintanilla, J., et al. (2023). *Anatomy, Head and Neck: Larynx*. StatPearls / NCBI Bookshelf. NBK538202.

[2] Gelfer, M. P., & Schofield, K. J. (2000). Comparison of acoustic and perceptual measures of voice in male-to-female transsexuals perceived as female versus those perceived as male. *Journal of Voice, 14*(1), 22–33. doi:10.1016/S0892-1997(00)80092-2. PMID: 10764114.

[3] Gelfer, M. P., & Bennett, Q. E. (2013). Speaking fundamental frequency and vowel formant frequencies: Effects on perception of gender. *Journal of Voice, 27*(5), 556–566. doi:10.1016/j.jvoice.2013.02.007. PMID: 23415148.

[4] Leung, Y., Oates, J., & Chan, S. P. (2018). Voice, articulation, and prosody contribute to listener perceptions of speaker gender: A systematic review and meta-analysis. *Journal of Speech, Language, and Hearing Research, 61*(2), 266–297. doi:10.1044/2017_JSLHR-S-17-0067. PMID: 29392290.

[5] Wolfe, V. I., Ratusnik, D. L., Smith, F. H., & Northrop, G. (1990). Intonation and fundamental frequency in male-to-female transsexuals. *Journal of Speech and Hearing Disorders, 55*(1), 43–50. doi:10.1044/jshd.5501.43. PMID: 2299839.

[6] Berg, M., Fuchs, M., Wirkner, K., Loeffler, M., Engel, C., & Berger, T. (2017). The speaking voice in the general population: Normative data and associations to sociodemographic and lifestyle factors. *Journal of Voice, 31*(2), 257.e13–257.e24. doi:10.1016/j.jvoice.2016.04.007. PMID: 27370073.

[7] Izadi, F., Salehi, A., Ghasemi, M. M., & Khosravi, A. (2012). Determination of fundamental frequency and voice intensity in Iranian men and women aged between 18 and 45 years. *Journal of Voice, 26*(6), e255–e260. doi:10.1016/j.jvoice.2011.07.002. PMID: 21889298.

[8] Leyns, C., et al. (2023). Effects of speech therapy for transgender women: A systematic review. *International Journal of Language & Communication Disorders, 58*(5), 1356–1371. doi:10.1111/1460-6984.12889. PMCID: PMC10553375.

[9] Nygren, U., Nordenskjöld, A., Arver, S., & Södersten, M. (2016). Effects on voice fundamental frequency and satisfaction with voice in trans men during testosterone treatment: A longitudinal study. *Journal of Voice, 30*(6), 766.e23–766.e34. doi:10.1016/j.jvoice.2015.10.016. PMID: 26678122.

[10] Mills, M., et al. (2019). Toward a protocol for transmasculine voice: A service evaluation of the voice and communication therapy group program, including long-term follow-up for trans men at the London Gender Identity Clinic. *Transgender Health, 4*(1), 143–151. doi:10.1089/trgh.2018.0048. PMCID: PMC6528553.

[11] National Institute on Deafness and Other Communication Disorders (NIDCD). *Taking Care of Your Voice*. NIH health information page.

[12] American Speech-Language-Hearing Association (ASHA). *Voice Disorders*; *Gender-Affirming Voice and Communication*. Practice Portal pages.
