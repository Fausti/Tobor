package gfx;

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
	
	private var tileBG:Rectangle;
	private var chars:Array<Rectangle> = [];
	
	public function new(w:Int, h:Int, offsetY:Int) {
		this.glyphW = w;
		this.glyphH = h;
		this.offsetY = offsetY;
		
		tileBG = Tobor.Tileset.rect(0, 0, glyphW, glyphH);
		
		for (i in 0 ... GLYPHS.length) {
			var glyphY:Int = Math.floor(i / 16);
			var glyphX:Int = i - glyphY * 16;
			
			chars.push(Tobor.Tileset.rect(glyphX * glyphW, offsetY + glyphY * glyphH, glyphW, glyphH));
		}
	}
	
	inline function drawChar(x:Float, y:Float, charIndex:Int, fg:Color = null, bg:Color = null) {
		// Hintergrund zeichnen
		Gfx.drawTexture(x, y, glyphW, glyphH, tileBG, bg);
		
		// Char zeichnen
		Gfx.drawTexture(x, y, glyphW, glyphH, chars[charIndex], fg);
	}
	
	public inline function drawString(x:Float, y:Float, text:String, fg:Color = null, bg:Color = null) {
		var posX:Float = x;
		var posY:Float = y;
		
		for (i in 0 ... text.length) {
			drawChar(posX, posY, GLYPHS.indexOf(text.charAt(i)), fg, bg);
			posX += glyphW;
		}
	}
	
#if html5
	public static var GLYPHS:String = "" + //
			"abcdefghijklmnop" +
			"qrstuvwxyzäöüß_ " +
			"ABCDEFGHIJKLMNOP" +
			"QRSTUVWXYZÄÖÜ^° " + //
			"0123456789.,!?'\"-+=/\\%()<>:;[]`´" + //
			"$#&@*éúíóáýèùìòà";
#else
	public static var GLYPHS:String = Utf8.decode("" + //
		"abcdefghijklmnop" +
		"qrstuvwxyzäöüß_ " +
		"ABCDEFGHIJKLMNOP" +
		"QRSTUVWXYZÄÖÜ^° " + //
		"0123456789.,!?'\"-+=/\\%()<>:;[]`´" + //
		"$#&@*éúíóáýèùìòà");
#end
}