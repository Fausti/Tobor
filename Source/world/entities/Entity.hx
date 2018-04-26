package world.entities;
import gfx.Gfx;
import gfx.Sprite;
import lime.math.Rectangle;
import lime.math.Vector2;
import world.Inventory;
import world.ObjectFactory;
import world.Room;
import world.ObjectFactory.ObjectTemplate;
import world.World;
import world.entities.interfaces.IContainer;
import world.entities.interfaces.IElectric;
import world.entities.std.Charlie;
import world.entities.std.Water;

/**
 * ...
 * @author Matthias Faust
 */
class Entity {
	public var room:Room;
	
	private var boundingBox:Rectangle;
	
	public var z(default, null):Int = Room.LAYER_LEVEL_0;
	public var x(get, set):Float;
	public var y(get, set):Float;
	
	public var gridX(get, set):Int;
	public var gridY(get, set):Int;
	
	private var sprites:Array<Sprite> = [];
	
	public var type:Int = 0;
	public var subType:Int = 0;
	public var flag:Int = Marker.MARKER_NO;
	public var content:String = null;
	
	public var alive:Bool = true;
	
	public var visible:Bool = true;
	
	public var onRemove:Dynamic = null; // Callback
	
	// Water
	
	var drift:Int = -1;
	
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
	
	inline function hasData(data:Dynamic, id:String):Bool {
		return Reflect.hasField(data, id);
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
		render();
		
		if (flag != Marker.MARKER_NO) {
			var spr_marker:Sprite = null;
			
			switch(flag) {
				case 0:
					spr_marker = Marker.SPR_MARKER_0;
				case 1:
					spr_marker = Marker.SPR_MARKER_1;
				case 2:
					spr_marker = Marker.SPR_MARKER_2;
				case 3:
					spr_marker = Marker.SPR_MARKER_3;
				case 4:
					spr_marker = Marker.SPR_MARKER_4;
			}
			
			if (spr_marker != null) Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, spr_marker);
		}
	}
	
	public function isMoving():Bool {
		return false;
	}
	
	public function hasWeight():Bool {
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
	
	// Raum Ereignisse
	public function onAddToRoom() {
		
	}
	
	public function onRemoveFromRoom() {
		
	}
	
	public function onGameStart() {
		
	}
	
	public function onRoomStart() {
		
	}

	public function onRoomEnds() {
		
	}
	
	public inline function setPosition(x:Int, y:Int):Entity {
		this.x = x;
		this.y = y;
		
		return this;
	}
	
	public inline function getBoundingBox():Rectangle {
		return boundingBox;
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
	
	inline function isOutsideMap(x:Float, y:Float):Bool {
		return x < 0 || x >= Room.WIDTH || y < 0 || y >= Room.HEIGHT;
	}
	
	// Save / Load
	
	public function clone():Entity {
		var o = Type.createInstance(Type.getClass(this), []);
		
		o.x = x;
		o.y = y;
		// o.z = z;
		
		o.type = type;
		o.subType = subType;
		o.flag = flag;
		o.content = content;
		
		o.drift = drift;
		
		o.room = room;
		
		return o;
	}
	
	public function canSave():Bool {
		return true;
	}
	
	public function parseData(data) {
		if (hasData(data, "subType")) {
			this.subType = data.subType;
		}
		
		if (hasData(data, "drift")) {
			this.drift = data.drift;
		}
		
		if (hasData(data, "type")) {
			this.type = data.type;
		}
		
		if (hasData(data, "content")) {
			this.content = data.content;
		}
		
		if (Std.is(this, IElectric)) {
			if (hasData(data, "flag")) {
				this.flag = data.flag;
			}
		}
		
		if (hasData(data, "x")) {
			this.x = data.x;
		}
		
		if (hasData(data, "y")) {
			this.y = data.y;
		}
		
		/*
		if (hasData(data, "z")) {
			this.z = data.z;
		}
		*/
		
		init();
	}
	
	public function saveData():Map<String, Dynamic> {
		var data:Map<String, Dynamic> = new Map<String, Dynamic>();
		
		var def:ObjectTemplate = getTemplate();
		
		if (def != null) {
			data.set("id", def.name);
			data.set("type", type);
			data.set("subType", subType);
			if (content != null) data.set("content", content);
			if (Std.is(this, IElectric)) data.set("flag", flag);
			data.set("x", gridX);
			data.set("y", gridY);
			// data.set("z", z);
			
			data.set("drift", drift);
		} else {
			return null;
		}
		
		return data;
	}
	
	inline function getWorld():World {
		return room.world;
	}
	
	inline function getPlayer():Charlie {
		return getWorld().player;
	}
	
	inline function getFactory():ObjectFactory {
		return getWorld().factory;
	}
	
	inline function getInventory():Inventory {
		return getWorld().inventory;
	}
	
	inline function getTemplate():ObjectTemplate {
		return getFactory().findFromObject(this);
	}
	
	function getID():String {
		var template:ObjectTemplate = getTemplate();
		
		if (template != null) return template.name;
		
		return "ERROR";
	}
	
	function getGroupID():String {
		return getID().split("#")[0];
	}
	
	// Water
	
	public function setDrift(f:Int) {
		if (Std.is(this, Water)) this.drift = f;
	}
	
	// Electric stuff
	
	public function setMarker(f:Int) {
		if (Std.is(this, IElectric)) {
			this.flag = f;
			onSetMarker(f);
		}
	}
	
	public function onSetMarker(f:Int) {
		
	}
	
	// Content
	
	public function setContent(s:String) {
		if (Std.is(this, IContainer)) {
			this.content = s;
			onSetContent(s);
		}
	}
	
	public function onSetContent(s:String) {
		
	}
	
	public function switchStatus() {

	}
}