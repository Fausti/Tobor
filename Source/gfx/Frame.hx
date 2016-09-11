package gfx;

import lime.math.Rectangle;
import gfx.Gfx;

/**
 * ...
 * @author Matthias Faust
 */
class Frame {
	public var sizeX:Int;
	public var sizeY:Int;
	
	var rTopLeft:Rectangle;
	var rTop:Rectangle;
	var rTopRight:Rectangle;
	
	var rLeft:Rectangle;
	var rBackground:Rectangle;
	var rRight:Rectangle;
	
	var rBottomLeft:Rectangle;
	var rBottom:Rectangle;
	var rBottomRight:Rectangle;
	
	public function new(x:Int, y:Int, w:Int, h:Int) {
		this.sizeX = w;
		this.sizeY = h;
		
		rTopLeft = Tobor.Tileset.rect(
			x, y, w, h
		);
		rTop = Tobor.Tileset.rect(
			x + w, y, w, h
		);
		rTopRight = Tobor.Tileset.rect(
			x + w * 2, y, w, h
		);
		
		rLeft = Tobor.Tileset.rect(
			x, y + h, w, h
		);
		rBackground = Tobor.Tileset.rect(
			0, 0, w, h
		);
		rRight = Tobor.Tileset.rect(
			x + w * 2, y + h, w, h
		);
		
		rBottomLeft = Tobor.Tileset.rect(
			x, y + h * 2, w, h
		);
		rBottom = Tobor.Tileset.rect(
			x + w, y + h * 2, w, h
		);
		rBottomRight = Tobor.Tileset.rect(
			x + w * 2, y + h * 2, w, h
		);
	}
	
	public function drawBox(x:Int, y:Int, w:Int, h:Int) {
		var r:Rectangle;
		
		// Hintergrund
		Gfx.drawTexture(x, y, w * sizeX, h * sizeY, rBackground, Color.WHITE); // MIDDLE
		
		for (i in 0 ... w) {
			// Obere Zeile
			
			if (i == 0) {
				r  = rTopLeft;
			} else if (i == (w - 1)) {
				r = rTopRight;
			} else {
				r = rTop;
			}
			
			Gfx.drawTexture(x + i * sizeX, y, sizeX, sizeY, r);
			
			// Untere Zeile
			
			if (i == 0) {
				r  = rBottomLeft;
			} else if (i == (w - 1)) {
				r = rBottomRight;
			} else {
				r = rBottom;
			}
			
			Gfx.drawTexture(x + i * sizeX, y + (h - 1) * sizeY, sizeX, sizeY, r);
		}
		
		// Zwischenzeilen
		
		for (i in 1 ... (h - 1)) {
			Gfx.drawTexture(x, y + i * sizeY, sizeX, sizeY, rLeft); // L
			Gfx.drawTexture(x + (w - 1) * sizeX, y + i * sizeY, sizeX, sizeY, rRight); // R
		}
	}
	
}