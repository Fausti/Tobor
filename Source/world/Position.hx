package world;

/**
 * ...
 * @author Matthias Faust
 */

class Position {
	public var x:Int;
	public var y:Int;
	public var z:Int;
	
	public var id(get, null):String;
	
	public function new(?x:Int = 0, ?y:Int = 0, ?z:Int = 0) {
		this.x = x;
		this.y = y;
		this.z = z;
	}
	
	inline function get_id():String {
		return Std.string(x) + Std.string(y) + Std.string(z);
	}
}