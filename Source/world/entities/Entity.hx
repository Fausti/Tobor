package world.entities;

import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 * 
 * Basisklasse aller Spielobjekte.
 * 
 */

class Entity {
	private var classPath:String;
	
	public function new() {
		classPath = Type.getClassName(Type.getClass(this));
	}
	
	// interner Klassenpath z.B. "world.entities.Object"
	
	public function getClassPath():String {
		return classPath;
	}
	
	// Bildschirmposition
	
	private var position:Vector2 = new Vector2();
	
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
		position.x = v * Tobor.OBJECT_WIDTH;
		
		return v * Tobor.OBJECT_WIDTH;
	}
	
	inline function get_gridY():Int {
		return Math.round(position.y / Tobor.OBJECT_HEIGHT);
	}
	
	function set_gridY(v:Int):Int {
		position.y = v * Tobor.OBJECT_HEIGHT;
		
		return v * Tobor.OBJECT_HEIGHT;
	}

	public function get_ID():String {
		return null;
	}
}