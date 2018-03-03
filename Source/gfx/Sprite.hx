package gfx;
import lime.math.Rectangle;

/**
 * ...
 * @author Matthias Faust
 */
class Sprite {
	public var uv(get, null):Rectangle;
	public var color:Color = null;
	
	public var width:Int;
	public var height:Int;
	
	public function new(?texture:Texture = null, ?x:Int = 0, ?y:Int = 0, ?w:Int = 0, ?h:Int = 0, ?scale:Float = 1.0) {
		if (texture == null) return;
		
		uv = new Rectangle(x / texture.width, y / texture.height, w / texture.width / scale, h  / texture.height / scale);
		
		width = w;
		height = h;
	}
	
	public function update(deltaTime:Float) {
		
	}
	
	public function setColor(c:Color) {
		this.color = c;
	}
	
	function get_uv():Rectangle {
		return uv;
	}
}