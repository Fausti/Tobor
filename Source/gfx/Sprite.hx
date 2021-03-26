package gfx;

import lime.math.Rectangle;

/**
 * ...
 * @author Matthias Faust
 */
class Sprite {
	public var uv(get, null):Rectangle;
	
	var _color:Color = null;
	public var color(get, set):Color;
	
	public var width:Int;
	public var height:Int;
	
	public function new(?texture:Texture = null, ?x:Int = 0, ?y:Int = 0, ?w:Int = 0, ?h:Int = 0, ?scale:Float = 1.0) {
		var texWidth:Int = 256;
		var texHeight:Int = 512 * 2;
		
		if (texture != null) {
			texWidth = texture.width;
			texHeight = texture.height;
		}
		
		uv = new Rectangle(x / texWidth, y / texHeight, w / texWidth / scale, h  / texHeight / scale);
		
		width = w;
		height = h;
	}
	
	public function update(deltaTime:Float) {
		
	}
	
	function get_color():Color {
		return this._color;
	}
	
	function set_color(c:Color):Color {
		this._color = c;
		
		return this._color;
	}
	
	function get_uv():Rectangle {
		return uv;
	}
}