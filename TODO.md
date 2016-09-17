- Custom Texture mit Pixeldaten aus Bild füttern => Tilesheet dynamisch aus Einzelbildern bauen?
- Hintergrundlayer einbauen (2D Array)

- Messaging
- Entitydaten von Entityklasse trennen!
# Animationen (IDrawable)
? isSolid -> canEnter
Optimierungen:

Idee:
	# in ein 640x348 Framebuffer zeichnen, wegen Aspektrate beibehalten beim Skalieren und so..., oder Skalierungseffekte
	- HScript durch eigene VM ersetzen
	- AABB Kollisionserkennung
	- Backgroundarray (linear sortiert: 40 * y + x), nichtinteragierbare Objekte: unzerstörbare Mauern, Böden (z.B. mit Laufeffekt)
	
Bugs:
	- Animationen "ruckeln" manchmal, Fehler in der Berechnung?