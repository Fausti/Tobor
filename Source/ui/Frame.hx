package ui;

import gfx.Sprite;
import lime.math.Rectangle;
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
			x, y, w, h
		);
		N = Gfx.getSprite(
			x + w, y, w, h
		);
		
		NE = Gfx.getSprite(
			x + w * 2, y, w, h
		);
		
		W = Gfx.getSprite(
			x, y + h, w, h
		);
		BG = Gfx.getSprite(
			0, 0, w, h
		);
		E = Gfx.getSprite(
			x + w * 2, y + h, w, h
		);
		
		SW = Gfx.getSprite(
			x, y + h * 2, w, h
		);
		S = Gfx.getSprite(
			x + w, y + h * 2, w, h
		);
		SE = Gfx.getSprite(
			x + w * 2, y + h * 2, w, h
		);
	}
	
	public function drawBoxRect(r:Rectangle, ?bg:Color = null) {
		drawBox(Std.int(r.x), Std.int(r.y), Std.int(r.width / sizeX), Std.int(r.height / sizeY), bg);
	}
	
	public function drawBox(x:Int, y:Int, w:Int, h:Int, ?bg:Color = null) {
		var r:Sprite;
		
		if (bg == null) bg = Color.WHITE;
		
		// Hintergrund
		Gfx.drawTexture(x, y, w * sizeX, h * sizeY, BG.uv, bg); // MIDDLE
		
		for (i in 0 ... w) {
			// obere Zeile
			
			if (i == 0) {
				r = NW;
			} else if (i == w - 1) {
				r = NE;
			} else {
				r = N;
			}
			
			Gfx.drawSprite(x + sizeX * i, y, r);
		
			// obere Zeile
			
			if (i == 0) {
				r = SW;
			} else if (i == w - 1) {
				r = SE;
			} else {
				r = S;
			}
			
			Gfx.drawSprite(x + sizeX * i, y + (h - 1) * sizeY, r);
		}
		
		for (i in 1 ... (h - 1)) {
			Gfx.drawSprite(x, y + sizeY * i, W);
			Gfx.drawSprite(x + (w - 1) * sizeX, y + sizeY * i, E);
		}
	}
	
	public function drawBoxColored(x:Int, y:Int, w:Int, h:Int, ?fg:Color, ?bg:Color) {
		if (fg == null) fg = Color.BLACK;
		if (bg == null) bg = Color.WHITE;
		
		var r:Sprite;
		
		// Hintergrund
		Gfx.drawTexture(x, y, w * sizeX, h * sizeY, BG.uv, bg); // MIDDLE
		
		for (i in 0 ... w) {
			// obere Zeile
			
			if (i == 0) {
				r = NW;
			} else if (i == w - 1) {
				r = NE;
			} else {
				r = N;
			}
			
			Gfx.drawSprite(x + sizeX * i, y, r, fg);
		
			// obere Zeile
			
			if (i == 0) {
				r = SW;
			} else if (i == w - 1) {
				r = SE;
			} else {
				r = S;
			}
			
			Gfx.drawSprite(x + sizeX * i, y + (h - 1) * sizeY, r, fg);
		}
		
		for (i in 1 ... (h - 1)) {
			Gfx.drawSprite(x, y + sizeY * i, W, fg);
			Gfx.drawSprite(x + (w - 1) * sizeX, y + sizeY * i, E, fg);
		}
	}
}