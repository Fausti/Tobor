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
	public var room:Room;
	
	private var boundingBox:Rectangle;
	
	public var z:Int = Room.LAYER_LEVEL_0;
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
		
		// dynamische Objekte werden durch Room.update() gelöscht
		if (Std.is(this, EntityStatic)) room.removeEntity(this);
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
	
	// darf betreten?
	public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		return true;
	}
	
	// wird betreten...
	public function willEnter(e:Entity, direction:Vector2, ?speed:Float = 0) {
		
	}
	
	// hat betreten...
	public function onEnter(e:Entity, direction:Vector2) {
		
	}
	
	// wird verlassen...
	public function onLeave(e:Entity, direction:Vector2) {
		
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
		o.z = z;
		o.type = type;
		
		o.room = room;
		
		return o;
	}
	
	public function canSave():Bool {
		return true;
	}
	
	public function parseData(data) {
		if (hasData(data, "type")) {
			this.type = data.type;
		}
		
		if (hasData(data, "x")) {
			this.x = data.x;
		}
		
		if (hasData(data, "y")) {
			this.y = data.y;
		}
		
		if (hasData(data, "z")) {
			this.z = data.z;
		}
		
		init();
	}
	
	public function saveData():Map<String, Dynamic> {
		var data:Map<String, Dynamic> = new Map<String, Dynamic>();
		
		var def:ObjectTemplate = getTemplate();
		
		if (def != null) {
			data.set("id", def.name);
			data.set("type", type);
			data.set("x", gridX);
			data.set("y", gridY);
			data.set("z", z);
		} else {
			return null;
		}
		
		return data;
	}
	
	function getTemplate():ObjectTemplate {
		return room.world.factory.findFromObject(this);
	}
	
	function getID():String {
		var template:ObjectTemplate = getTemplate();
		
		if (template != null) return template.name;
		
		return "ERROR";
	}
}