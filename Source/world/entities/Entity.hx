package world.entities;
import gfx.Gfx;
import gfx.Sprite;
import lime.math.Rectangle;
import lime.math.Vector2;
import world.Room;

/**
 * ...
 * @author Matthias Faust
 */
class Entity {
	private var room:Room;
	
	private var boundingBox:Rectangle;
	
	public var x(get, set):Float;
	public var y(get, set):Float;
	
	public var gridX(get, set):Int;
	public var gridY(get, set):Int;
	
	private var sprites:Array<Sprite> = [];
	
	private var type:Int = 0;
	
	public function new() {
		boundingBox = new Rectangle(0, 0, 1, 1);
		
		init();
	}
	
	public function init() {
		
	}
	
	function hasData(data:Dynamic, id:String):Bool {
		return Reflect.hasField(data, id);
	}
	
	function getData(data:Dynamic, id:String):Dynamic {
		if (hasData(data, id)) {
			return Reflect.field(data, id);
		}
		
		return 0;
	}
	
	public function parseData(data) {
		if (hasData(data, "type")) {
			this.type = data.type;
			init();
		}
	}
	
	public function setRoom(r:Room) {
		room = r;
	}

	public function update(deltaTime:Float) {
		for (spr in sprites) {
			spr.update(deltaTime);
		}
	}
	
	public function setSprite(spr:Sprite, ?index:Int = 0) {
		sprites[0] = spr;
	}
	
	public function render() {
		for (spr in sprites) {
			Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, spr);
		}
	}
	
	public function render_editor() {
		for (spr in sprites) {
			Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, spr);
		}
	}
	
	public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		return true;
	}
	
	public function setPosition(x:Int, y:Int) {
		this.x = x;
		this.y = y;
	}
	
	inline function get_x():Float {
		return boundingBox.x;
	}
	
	inline function set_x(v:Float):Float {
		return boundingBox.x = v;
	}
	
	inline function get_y():Float {
		return boundingBox.y;
	}
	
	inline function set_y(v:Float):Float {
		return boundingBox.y = v;
	}
	
	// grid
	
	inline function get_gridX():Int {
		return Std.int(x);
	}
	
	inline function set_gridX(v:Int):Int {
		x = v;
		
		return v;
	}
	
	inline function get_gridY():Int {
		return Std.int(y);
	}
	
	inline function set_gridY(v:Int):Int {
		y = v;
		
		return v;
	}
	
	private function isOutsideMap(x:Float, y:Float):Bool {
		return x < 0 || x >= Room.WIDTH || y < 0 || y >= Room.HEIGHT;
	}
}