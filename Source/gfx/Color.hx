package gfx;

/**
 * ...
 * @author Matthias Faust
 */
class Color {
	public var r:Float;
	public var g:Float;
	public var b:Float;
	public var a:Float;
	
	public var intR(get, null):Int;
	public var intG(get, null):Int;
	public var intB(get, null):Int;
	
	inline function get_intR():Int {
		return Std.int(r * 255);
	}
	
	inline function get_intG():Int {
		return Std.int(g * 255);
	}
	
	inline function get_intB():Int {
		return Std.int(b * 255);
	}
	
	public function new (r:Float = 0., g:Float = 0., b:Float = 0., a:Float = 1.) {
		this.r = r;
		this.g = g;
		this.b = b;
		this.a = a;
	}
	
	public static var NONE = new Color(0, 0, 0, 0);
	
	public static var BLACK = Color.from(0x000000);
	
	public static var YELLOW = Color.from(0xffff00);
	public static var DARK_GREEN = Color.from(0x00a84f);
	public static var GRAY = Color.from(0xacacac);
	
	public static var PURPLE = Color.from(0xaf00af);
	public static var DARK_RED = Color.from(0xaf0000);
	public static var RED = Color.from(0xff0000);
	
	public static var ORANGE = Color.from(0xffac00);
	public static var GREEN = Color.from(0x00ff52);
	public static var LIGHT_GREEN = Color.from(0xafffaf);
	
	public static var LIGHT_BLUE = Color.from(0x00a8af);
	public static var BLUE = Color.from(0x0000ff);
	public static var BLUE2 = Color.from(0x4f50ff);
	
	public static var DARK_BLUE = Color.from(0x00004f);
	public static var BROWN = Color.from(0x4f5000);
	public static var WHITE = Color.from(0xffffff);
	
	public static inline function from(col:Int) : Color {
		var r:Float = Math.min(((col >> 16) & 0xFF) / 255.0, 1.0);
		var g:Float = Math.min(((col >> 8) & 0xFF)  / 255.0, 1.0);
		var b:Float = Math.min((col & 0xFF)         / 255.0, 1.0);
		
		return new Color(r, g, b);
	}
}