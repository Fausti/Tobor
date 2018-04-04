![](/docs/images/logo-tobor.png)

## Inhalt

<!-- TOC -->

- [Inhalt](#inhalt)
- [Über](#über)
- [Der Editor](#der-editor)
    - [Eine neue Episode erstellen](#eine-neue-episode-erstellen)
    - [Den Editor starten](#den-editor-starten)
    - [Szenen eurer Episode bearbeiten](#szenen-eurer-episode-bearbeiten)
                - [Anhang - Tastenkürzel im Editor](#anhang---tastenkürzel-im-editor)
    - [Speichern eurer Episode](#speichern-eurer-episode)
    - [Verteilen eurer Episode](#verteilen-eurer-episode)
    - [Eigene Texte](#eigene-texte)
                - [Anhang - weitere Tags für Texte](#anhang---weitere-tags-für-texte)
    - [Markierungen](#markierungen)
    - [Strömungen](#strömungen)
    - [Teleporter](#teleporter)
    - [Container (Säcke)](#container-säcke)

<!-- /TOC -->

## Über

The Game of Tobor ist der Clone einer alten Reihe von DOS Spielen. Und zwar [The Game of Robot](www.the-game-of-robot.de) von [TOM Productions](http://www.tom-games.de/ger/index.html).

Mittels Tobor könnt ihr nun endlich eure eigenen Robot Episoden erstellen und von anderen erstellte Episoden spielen.
Dabei steht euch eine Sammlung von Standardobjekten aus Robot I, II und Robot Junior zur Verfügung.

## Der Editor
### Eine neue Episode erstellen
Im Episodenbildschirm *>> NEU <<* wählen und eurer Episode einen Namen geben.

![Episodenauswahl](/docs/images/screen-episoden-auswahl.png)

![Episode benennen](/docs/images/tutorial-step-1.png)

### Den Editor starten
Im Introbildschirm mittels *< Enter >* oder *< ESC >* das Menü aufrufen und dort *Bearbeiten* wählen um in den Editor zu gelangen.

![Episode benennen](/docs/images/tutorial-step-2.png)

### Szenen eurer Episode bearbeiten

Im Editor könnt ihr nun mittels *< ENTER >* die Objektauswahl öffnen und mittels der Maus das zu zeichnende Objekt auswählen.
*< linke Maustaste >* zum Setzen des Objektes, *< rechte Maustaste >* zum Löschen des Objektes.

![Objektauswahl](/docs/images/choose-objects.png)

Zum Wechseln der aktuellen Szene stehen euch zwei Möglichkeiten zur Verfügung: 

1. *< W >, < A >, < S >, < D >, < Bild rauf >, < Bild runter >* für einen schnellen Wechsel - praktisch falls ihr zum Beispiel gerade schauen wollt ob die Ausgänge zweier Räume auch passrecht von euch gezeichnet wurden.

2. *< TAB >* die Szenenauswahl. Hier könnt ihr sofort die Anordnung eurer Szenen erkennen. 

![Szenenauswahl](/docs/images/choose-scenes.png)

Mittels *< F5 >* wechselt ihr zwischen dem *Editor-* und dem *Spielmodus*.
Im *Spielmodus* könnt ihr fast wie im richtigen Spiel mit Charlie durch eure Episode laufen und eure Rätsel und Räume austesten.

Wenn ihr im *Editormodus* das [![Charlie](/docs/images/object-charlie.png)] Objekt versetzt, so versetzt ihr auch Charlies Position im *Spielmodus*. Wollt ihr die *Startposition* eurer Episode ändern, so müsst ihr das [![Startposition](/docs/images/object-start-position.png)] *Spielstartobjekt* an eine andere Position setzen.

###### Anhang - Tastenkürzel im Editor

Hier noch eine Auflistung aller Tastenkombinationen des Editors:

Tastenkürzel|Funktion 
-------|----------
F5 | Testen / Editieren
ENTER | Objektauswahl anzeigen
TAB | Szenenauswahl anzeigen
ESCAPE | Menü aufrufen
linke Maustaste | Objekt / Markierung / Strömung / Inhalt setzen
rechte Maustaste | Objekt / Markierung / Strömung / Inahlt entfernen 
W, A, S, D | schnelles wechseln der aktuellen Szene im *Editormodus*

### Speichern eurer Episode

Vergesst bitte vor dem Verlassen des Editors oder dem Beenden von Tobor nicht eure Episode zu Speichern! Einfach mit *< ESC >* das Menü aufrufen und *Speichern* wählen.

### Verteilen eurer Episode

In eurem Tobor Verzeichnis findet ihr folgenden Verzeichnisbaum:

```
Tobor
├── <games>
│   └── <Tutorial>          <== Eure erstellte Episode!
│       ├── info.de
│       ├── rooms.json
│       ├── translation.json
│       ├── translation_missing.json
│       └── ...
├── <saves>
├── Tobor.exe
├── lime.ndll
└── ...
```

Wir erinnern uns - in Schritt 1 haben wir unsere Episode "Tutorial" genannt. So heißt auch ein Verzeichnis im Tobor/games Verzeichnis. ALLE Dateien in "Tutorial" müssen nun in ZIP - Archiv gepackt werden, welches ihr dann im [Game of Robot - Forum](https://www.tapatalk.com/groups/gameofrobot/index.php) anderen Robot Fans zum Spielen anbieten könnt.

### Eigene Texte

Im Verzeichnis eurer Episode findet ihr noch weitere Dateien. Zum Beispiel `info.de` in welche ihr eine kurze Beschreibung eurer Episode schreiben könnt. Dies würde dann in der Episodenauswahl unter dem Namen eurer Episode stehen.

Verseht ihr in euren Räumen [![Notiz](/docs/images/notice.png)] Notizzettel mit einer der fünf [![Markierungen](/docs/images/marker.png)] Markierungen, könnt ihr den Text der Notiz dann später innerhalb der `translation_missing.json` oder `translation.json` ändern.

Eine Notiz mit blauer Markierung in Raum 210 erkennt ihr z.B. an folgendem Namen `TXT_NOTICE_ROOM_210_NR_3`:

```
,"TXT_NOTICE_ROOM_210_NR_3" : {
    "de" : "Hallo! Ich bin ein Notizzellt. Ist das nicht cool?"
}
```

Ihr müsst euch diese kryptischen Namen aber nicht unbedingt merken. Geht einfach mit *< F5 >* in den Spielmodus und sammelt eure Notiz ein. Der richtige Tag steht in der Textbox die euch angezeigt wird, da ihr dem Tag noch keinen eigenen Text zugeordnet habt.

###### Anhang - weitere Tags für Texte

Ihr findet in beiden Dateien aber noch mehr Einträge denen ihr Texte verpassen könnt und sollte:

Tag|Text
-|-
TXT_ROOM_100|Szenenname für Szene 100
TXT_NOTICE_ROOM_210_NR_3|Notiz mit Markierung 3 in Szene 210
TXT_EPISODE_WON|Episode gewonnen
TXT_EPISODE_LOST|Episode verloren

### Markierungen

Einige Objekte könnt ihr mit einer von fünf [![Markierungen](/docs/images/marker.png)] Markierungen versehen um ihnen spezielle Funktionen zu zuweisen.

Objekt|Funktion
-|-
![Notiz](/docs/images/notice.png)|Text TAG zuordnen, 5 pro Szene
![Strömungen](/docs/images/streams.png)|Strömung spiegeln falls ein Schaltobjekt mit selber Markierung im Raum betätigt wird
![Elektrotür](/docs/images/edoor.png)|zwischen AUF und ZU wechseln, falls ein Schaltobjekt mit selber Markierung im Raum betätigt wird
![Elektrozaun](/docs/images/efence.png)|zwischen AKTIV (und tödlich) und INAKTIV (nicht tödlich) wechseln, falls ein Schaltobjekt mit selber Markierung im Raum betätigt wird
![Bodenplatte](/docs/images/plate.png)|löst bei Betreten / Verlassen Funktionswechsel aller Objekte mit selber Markierung im Raum aus

### Strömungen
[![Strömungen](/docs/images/streams.png)] Strömungen geben an in welche Richtung der Spieler abgetrieben wird, sollte er das Wasserfeld ohne Schwimmflossen betreten. Diese lassen sich auch noch durch eine der fünf [![Markierungen](/docs/images/marker.png)] Markierungen ferngesteuert regeln.

### Teleporter

Setzt ihr einen einsammelbaren Gegenstand auf ein Teleportationsfeld, wird aus den unsichtbaren und bedingungslosen Teleportern ein HABEN / NICHT-HABEN Teleporter. Sie reagieren nur wenn der Spieler den besagten Gegenstand (nicht) im Inventar hat.

Start- und Zielposition der Teleporter lassen sich im Editor am `[S]tart` und `[Z]iel` Zeichen erkennen. Bedingte Teleporter funktionieren auch Szenenübergreifend, während bedingungslose Teleporter in ihrer Funktion auf die selbe Szene beschränkt sind.

### Container (Säcke)

Um den Inhalt eines Containers festzulegen einfach einen sammelbaren Gegenstand auf den Container zeichnen.
