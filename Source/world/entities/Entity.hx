package world.entities;
import gfx.Gfx;
import gfx.Sprite;
import lime.math.Rectangle;
import lime.math.Vector2;
import world.Room;
import world.ObjectFactory.ObjectTemplate;

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
	
	public var type:Int = 0;
	
	public var alive:Bool = true;
	
	public function new() {
		boundingBox = new Rectangle(0, 0, 1, 1);
		
		init();
	}
	
	public function init() {
		
	}
	
	public function die() {
		alive = false;
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
	
	public function isMoving():Bool {
		return false;
	}
	
	public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		return true;
	}
	
	public function onEnter(e:Entity, direction:Vector2) {
		
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
	
	public function collisionAt(cx:Float, cy:Float):Bool {
		if (!alive) return false;
		
		return boundingBox.intersects(new Rectangle(cx, cy, 1, 1));
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
	
	// Save / Load
	
	public function clone():Entity {
		var o = Type.createInstance(Type.getClass(this), []);
		
		o.x = x;
		o.y = y;
		o.type = type;
		
		return o;
	}
	
	public function canSave():Bool {
		return true;
	}
	
	public function saveData():Map<String, Dynamic> {
		var data:Map<String, Dynamic> = new Map<String, Dynamic>();
		
		var def:ObjectTemplate = room.world.factory.findIDFromObject(this);
		
		if (def != null) {
			data.set("id", def.name);
			data.set("type", type);
			data.set("x", gridX);
			data.set("y", gridY);
		} else {
			return null;
		}
		
		return data;
	}
}