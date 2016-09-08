package world.entity;
import gfx.Gfx;
import screens.Screen;
import lime.math.Vector2;
import world.Room;

/**
 * ...
 * @author Matthias Faust
 */
class Entity {
	public static inline var WIDTH:Int = 16;
	public static inline var HEIGHT:Int = 12;
	
	public var isAlive:Bool = true;
	
	public var isStatic:Bool = true;
	public var changed:Bool = true;
	
	var position:Vector2;
	
	public var room:Room;
	
	var gfx:gfx.IDrawable;
	
	// Bildschirmposition
	
	public var x(get, set):Float;
	public var y(get, set):Float;
	
	function get_x():Float {
		return position.x;
	}
	
	function set_x(v:Float):Float {
		position.x = v;
		
		return v;
	}
	
	function get_y():Float {
		return position.y;
	}
	
	function set_y(v:Float):Float {
		position.y = v;
		
		return v;
	}
	
	// Gridposition
	
	public var gridX(get, set):Int;
	public var gridY(get, set):Int;
	
	inline function get_gridX():Int {
		return Math.round(position.x / 16);
	}
	
	function set_gridX(v:Int):Int {
		position.x = v * WIDTH;
		
		return v * WIDTH;
	}
	
	inline function get_gridY():Int {
		return Math.round(position.y / HEIGHT);
	}
	
	function set_gridY(v:Int):Int {
		position.y = v * HEIGHT;
		
		return v * HEIGHT;
	}
	
	// Kollisionen
	
	public function isSolid(e:Entity):Bool {
		return false;
	}
	
	// ---
	
	public function new() {
		position = new Vector2();
	}
	
	public function draw() {
		if (gfx == null) return;
		
		Gfx.drawTexture(x, y, 16, 12, gfx.getUV());
	}
	
	public function update(deltaTime:Float) {
		if (gfx != null) gfx.update(deltaTime);
		
		changed = false;
	}
}