package ui;

// import haxe.Utf8;

/**
 * ...
 * @author Matthias Faust
 */
class Font {
	private var offsetY:Int;
	public var glyphW:Int;
	public var glyphH:Int;
	
	private var tileBG:Sprite;
	private var chars:Array<Sprite> = [];
	
	public function new(w:Int, h:Int, offsetY:Int) {
		this.glyphW = w;
		this.glyphH = h; 
		
		this.offsetY = offsetY;
		
		tileBG =  Gfx.getSprite(0, 0, glyphW, glyphH);
		
		for (i in 0 ... GLYPHS.length) {
			var glyphY:Int = Math.floor(i / 16);
			var glyphX:Int = i - glyphY * 16;
			
			chars.push(Gfx.getSprite(glyphX * w, offsetY + glyphY * h, glyphW, glyphH));
		}
	}
	
	inline function drawChar(x:Float, y:Float, charIndex:Int, fg:Color = null, bg:Color = null) {
		if (bg == null) bg = Color.NONE;
		
		// Hintergrund zeichnen
		if (bg != Color.NONE) Gfx.drawSprite(x, y, tileBG, bg);
		
		// Char zeichnen
		Gfx.drawSprite(x, y, chars[charIndex], fg);
	}
	
	public inline function drawString(x:Float, y:Float, text:String, fg:Color = null, bg:Color = null) {
		var posX:Float = x;
		var posY:Float = y;
		
		// text = Utf8.decode(text);
		
		for (i in 0 ... text.length) {
			var c = text.charAt(i);
			// if (c == "_") c = " ";
			
			var ci:Int = GLYPHS.indexOf(c);
			
			if (ci >= 0) {
				drawChar(posX, posY, ci, fg, bg);
				posX += glyphW;
			}
		}
	}
	
	// Schattenvariante
	
	inline function drawShadowChar(x:Float, y:Float, charIndex:Int, bg:Color = null) {
		if (bg == null) bg = Color.NONE;
		
		// Hintergrund zeichnen
		if (bg != Color.NONE) Gfx.drawSprite(x, y, tileBG, bg);
		
		// Char zeichnen
		Gfx.drawSprite(x, y, chars[charIndex], Color.GRAY);
		Gfx.drawSprite(x + 2, y + 2, chars[charIndex], Color.BLACK);
		Gfx.drawSprite(x + 1, y + 1, chars[charIndex], Color.DARK_GRAY);
	}
	
	public inline function drawShadowString(x:Float, y:Float, text:String, bg:Color = null) {
		var posX:Float = x;
		var posY:Float = y;
		
		for (i in 0 ... text.length) {
			drawShadowChar(posX, posY, GLYPHS.indexOf(text.charAt(i)), bg);
			posX += glyphW;
		}
	}
	
	// public static var GLYPHS:String = Utf8.decode("" + //
	public static var GLYPHS:String =
		"abcdefghijklmnop" +
		"qrstuvwxyzäöüß_ " +
		"ABCDEFGHIJKLMNOP" +
		"QRSTUVWXYZÄÖÜ^° " + //
		"0123456789.,!?'\"-+=/\\%()<>:;[]`´" + //
		"$#&@*éúíóáýèùìòà";
}