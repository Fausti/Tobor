package ui;

import gfx.Sprite;
/**
 * ...
 * @author Matthias Faust
 */
class Frame {
	public var sizeX:Int;
	public var sizeY:Int;
	
	var NW:Sprite;
	var N:Sprite;
	var NE:Sprite;
	
	var W:Sprite;
	var BG:Sprite;
	var E:Sprite;
	
	var SW:Sprite;
	var S:Sprite;
	var SE:Sprite;
	
	public function new(x:Int, y:Int, w:Int, h:Int) {
		this.sizeX = w;
		this.sizeY = h;
		
		NW = Gfx.getSprite(
			x, y, w * Tobor.ZOOM, h * Tobor.ZOOM
		);
		N = Gfx.getSprite(
			x + w, y, w * Tobor.ZOOM, h * Tobor.ZOOM
		);
		
		NE = Gfx.getSprite(
			x + w * 2, y, w * Tobor.ZOOM, h * Tobor.ZOOM
		);
		
		W = Gfx.getSprite(
			x, y + h, w * Tobor.ZOOM, h * Tobor.ZOOM
		);
		BG = Gfx.getSprite(
			0, 0, w * Tobor.ZOOM, h * Tobor.ZOOM
		);
		E = Gfx.getSprite(
			x + w * 2, y + h, w * Tobor.ZOOM, h * Tobor.ZOOM
		);
		
		SW = Gfx.getSprite(
			x, y + h * 2, w * Tobor.ZOOM, h * Tobor.ZOOM
		);
		S = Gfx.getSprite(
			x + w, y + h * 2, w * Tobor.ZOOM, h * Tobor.ZOOM
		);
		SE = Gfx.getSprite(
			x + w * 2, y + h * 2, w * Tobor.ZOOM, h * Tobor.ZOOM
		);
	}
	
	public function drawBox(x:Int, y:Int, w:Int, h:Int, ?bg:Color = null) {
		var r:Sprite;
		
		x = x * Tobor.ZOOM;
		y = y * Tobor.ZOOM;
		
		if (bg == null) bg = Color.WHITE;
		
		// Hintergrund
		Gfx.drawTexture(x, y, w * sizeX * Tobor.ZOOM, h * sizeY * Tobor.ZOOM, BG.uv, bg); // MIDDLE
		
		for (i in 0 ... w) {
			// obere Zeile
			
			if (i == 0) {
				r = NW;
			} else if (i == w - 1) {
				r = NE;
			} else {
				r = N;
			}
			
			Gfx.drawSprite(x + sizeX * i * Tobor.ZOOM, y, r);
		
			// obere Zeile
			
			if (i == 0) {
				r = SW;
			} else if (i == w - 1) {
				r = SE;
			} else {
				r = S;
			}
			
			Gfx.drawSprite(x + sizeX * i * Tobor.ZOOM, y + (h - 1) * sizeY * Tobor.ZOOM, r);
		}
		
		for (i in 1 ... (h - 1)) {
			Gfx.drawSprite(x, y + sizeY * i * Tobor.ZOOM, W);
			Gfx.drawSprite(x + (w - 1) * sizeX * Tobor.ZOOM, y + sizeY * i * Tobor.ZOOM, E);
		}
	}
	
	public function drawBoxColored(x:Int, y:Int, w:Int, h:Int, ?fg:Color, ?bg:Color) {
		if (fg == null) fg = Color.BLACK;
		if (bg == null) bg = Color.WHITE;
		
		var r:Sprite;
		
		x = x * Tobor.ZOOM;
		y = y * Tobor.ZOOM;
		
		// Hintergrund
		Gfx.drawTexture(x, y, w * sizeX * Tobor.ZOOM, h * sizeY * Tobor.ZOOM, BG.uv, bg); // MIDDLE
		
		for (i in 0 ... w) {
			// obere Zeile
			
			if (i == 0) {
				r = NW;
			} else if (i == w - 1) {
				r = NE;
			} else {
				r = N;
			}
			
			Gfx.drawSprite(x + sizeX * i * Tobor.ZOOM, y, r, fg);
		
			// obere Zeile
			
			if (i == 0) {
				r = SW;
			} else if (i == w - 1) {
				r = SE;
			} else {
				r = S;
			}
			
			Gfx.drawSprite(x + sizeX * i * Tobor.ZOOM, y + (h - 1) * sizeY * Tobor.ZOOM, r, fg);
		}
		
		for (i in 1 ... (h - 1)) {
			Gfx.drawSprite(x, y + sizeY * i * Tobor.ZOOM, W, fg);
			Gfx.drawSprite(x + (w - 1) * sizeX * Tobor.ZOOM, y + sizeY * i * Tobor.ZOOM, E, fg);
		}
	}
}