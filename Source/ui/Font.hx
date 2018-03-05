package ui;

import haxe.Utf8;

import lime.math.Rectangle;

/**
 * ...
 * @author Matthias Faust
 */
class Font {
	private var offsetY:Int;
	private var glyphW:Int;
	private var glyphH:Int;
	
	private var tileBG:Sprite;
	private var chars:Array<Sprite> = [];
	
	public function new(w:Int, h:Int, offsetY:Int) {
		this.glyphW = w * Tobor.ZOOM;
		this.glyphH = h * Tobor.ZOOM; 
		
		this.offsetY = offsetY;
		
		tileBG =  Gfx.getSprite(0, 0, glyphW, glyphH);
		
		for (i in 0 ... GLYPHS.length) {
			var glyphY:Int = Math.floor(i / 16);
			var glyphX:Int = i - glyphY * 16;
			
			chars.push(Gfx.getSprite(glyphX * w, offsetY + glyphY * h, glyphW, glyphH));
		}
	}
	
	inline function drawChar(x:Float, y:Float, charIndex:Int, fg:Color = null, bg:Color = null) {
		// Hintergrund zeichnen
		if (bg != Color.NONE) Gfx.drawSprite(x, y, tileBG, bg);
		
		// Char zeichnen
		Gfx.drawSprite(x, y, chars[charIndex], fg);
	}
	
	public inline function drawString(x:Float, y:Float, text:String, fg:Color = null, bg:Color = null) {
		var posX:Float = x * Tobor.ZOOM;
		var posY:Float = y * Tobor.ZOOM;
		
		for (i in 0 ... text.length) {
			drawChar(posX, posY, GLYPHS.indexOf(text.charAt(i)), fg, bg);
			posX += glyphW;
		}
	}
	
	public static var GLYPHS:String = Utf8.decode("" + //
		"abcdefghijklmnop" +
		"qrstuvwxyzäöüß_ " +
		"ABCDEFGHIJKLMNOP" +
		"QRSTUVWXYZÄÖÜ^° " + //
		"0123456789.,!?'\"-+=/\\%()<>:;[]`´" + //
		"$#&@*éúíóáýèùìòà");
}