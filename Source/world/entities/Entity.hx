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
import world.entities.std.*;
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
		return Math.round(x); // Std.int(x);
	}
	
	inline function set_gridX(v:Int):Int {
		x = v;
		
		return v;
	}
	
	inline function get_gridY():Int {
		return Math.round(y); // Std.int(y);
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
	
	public function saveData():EntityData {
		var def:ObjectTemplate = getTemplate();
		/*
		var data:Map<String, Dynamic> = new Map<String, Dynamic>();
		
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
		*/
		
		if (def != null) {
			return {
				id: def.name, 
				type: type, 
				subType: subType, 
				content: content, 
				flag: flag, 
				x: gridX, 
				y: gridY, 
				drift: drift 
			};
		}
		
		return null;
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
	
	// Editor
	
	var fullTiles:Array<Int> = [];
	var halfTiles:Map<Vector2, Array<Int>> = new Map<Vector2, Array<Int>>();
	
	public function isFullTile():Bool {
		return (fullTiles.indexOf(type) > -1);
	}
	
	public function isHalfTile():Bool {
		for (tiles in halfTiles) {
			if (tiles.indexOf(type) > -1) return true;
		}
		
		return false;
	}
	
	public function isHalfDirection(d:Vector2):Bool {
		var list = halfTiles.get(d);
		
		if (list == null) return false;
		
		if (list.indexOf(type) > 1) return true;
		
		return false;
	}
	
	public function getHalfTile(d:Vector2, ?index:Int = -1):Int {
		var list = halfTiles.get(d);
		
		if (list == null) return 0;
		
		if (index == -1) {
			return list[Std.random(list.length)];
		} else {
			return list[index];
		}
	}
	
	public function getHalfDirection():Vector2 {
		for (tiles in halfTiles.keys()) {
			if (halfTiles[tiles].indexOf(type) > -1) return tiles;
		}
		
		return Direction.NONE;
	}
	
	function fixType(e:Entity):Int {
		// sind wir bereits ein Eckentile?
		if (isHalfTile()) return type;
		
		// wenn nicht, passen wir uns bitte an...
		var d = e.getHalfDirection();
		
		if (d != Direction.NONE) {
			d = Direction.rotate(d, 4);
				
			return getHalfTile(d);
		}
		
		return type;
	}
	
	function checkCombine(e:Entity, ?reverse:Bool = false):Bool {
		var cl = Type.getClass(this);
		var sameClass = Std.is(e, cl);
		
		if (sameClass) return true;
		
		if (!sameClass && Std.is(e, Sand)) {
			if (!reverse) return true;
			if (e.isHalfTile()) return true;
		} else if (!sameClass && Std.is(e, Wood)) {
			if (!reverse) return true;
			if (e.isHalfTile()) return true;
		} else if (!sameClass && Std.is(e, Grass)) {
			if (!reverse) return true;
		} else if (!sameClass && Std.is(e, MountainPath)) {
			if (!reverse) return true;
		} else if (!sameClass && Std.is(e, Mountain)) {
			if (!reverse) return true;
			if (e.isHalfTile()) return true;
		} else if (!sameClass && Std.is(e, Path)) {
			if (!reverse) return true;
		} else if (!sameClass && Std.is(e, Wall)) {
			if (!reverse) return true;
			if (e.isHalfTile()) return true;
		} else if (!sameClass && Std.is(e, Water)) {
			if (!reverse) return true;
			if (e.isHalfTile()) return true;
		}
		
		return false;
	}
	
	function combine(e:Entity, ?reverse:Bool = false) {
		var cl = Type.getClass(this);
		var sameClass = Std.is(e, cl);
		
		var newType:Int = -1;
		var newSubType:Int = -1;
		
		if (sameClass) {
			if (isHalfTile() && subType == 0) {
				type = 0;
				return;
			}
		}
		
		if (!reverse) {
			if (!isHalfTile()) return;
		}
		
		if (!sameClass && Std.is(e, Water)) {
			if (reverse) newType = fixType(e);
			
			switch(e.type) {
				case 0:
					newSubType = 16;
				case 1:
					newSubType = 17;
			}
		} else if (!sameClass && Std.is(e, Sand)) {
			if (reverse) newType = fixType(e);
			
			newSubType = 1;
		} else if (!sameClass && Std.is(e, Wood)) {
			if (reverse) newType = fixType(e);
			
			switch(e.type) {
			case 0:
				newSubType = 2;
			case 5:
				newSubType = 3;
			case 6:
				newSubType = 4;
			default:
				newSubType = 2 + Std.random(3);
			}
		} else if (!sameClass && Std.is(e, Grass)) {
			newSubType = 5;
		} else if (!sameClass && Std.is(e, MountainPath)) {
			newSubType = 18;
		} else if (!sameClass && Std.is(e, Mountain)) {
			if (reverse) newType = fixType(e);
			
			switch(e.type) {
				case 0:
					newSubType = 6;
				case 1:
					newSubType = 7;
				case 2:
					newSubType = 8;
				case 3:
					newSubType = 9;
				default:
					newSubType = 6 + Std.random(4);
			}
		} else if (!sameClass && Std.is(e, Path)) {
			newSubType = 10;
		} else if (!sameClass && Std.is(e, Wall)) {
			if (reverse) newType = fixType(e);
			
			switch(e.type) {
				case 0:
					newSubType = 11;
				case 5:
					newSubType = 12;
				case 10:
					newSubType = 13;
				case 11:
					newSubType = 14;
				case 16:
					newSubType = 15;
				default:
					if (e.type >= 1 && e.type <= 4) {
						newSubType = 11;
					} else if (e.type >= 6 && e.type <= 9) {
						newSubType = 12;
					} else if (e.type >= 12 && e.type <= 15) {
						newSubType = 14;
					}
			}
		}
		
		// trace("old: ", this, type, subType, e, e.type, e.subType);
		
		if (subType == 0) {
			if (subType != newSubType && newSubType > -1) subType = newSubType;
			if (type != newType && newType > 0) type = newType;
		}
		
		// trace("new: ", this, type, subType, e, e.type, e.subType);
	}
	
	function renderSubType() {
		if (subType == 0) return;
		
		var subSpr:Sprite = null;
			
		switch(subType) {
			case 1: // Sand
				subSpr = Sand.SPR_SAND[0];
				
			case 2: // Wald - 0
				subSpr = Wood.SPR_WOOD[0];
			case 3: // Wald - 5
				subSpr = Wood.SPR_WOOD[5];
			case 4: // Wald - 6
				subSpr = Wood.SPR_WOOD[6];
					
			case 5: // Grass - 1
				subSpr = Grass.SPR_GRASS[1];
					
			case 6: // Mountain - 0
				subSpr = Mountain.SPR_MOUNTAIN[0];
			case 7: // Mountain - 1
				subSpr = Mountain.SPR_MOUNTAIN[1];
			case 8: // Mountain - 2
				subSpr = Mountain.SPR_MOUNTAIN[2];
			case 9: // Mountain - 3
				subSpr = Mountain.SPR_MOUNTAIN[3];
					
			case 10: // Pfad - 0
				subSpr = Path.SPR_PATH;
					
			case 11: // Mauer - 0
				subSpr = Wall.SPR_WALL[0];
			case 12:
				subSpr = Wall.SPR_WALL[5];
			case 13:
				subSpr = Wall.SPR_WALL[10];
			case 14:
				subSpr = Wall.SPR_WALL[11];
			case 15:
				subSpr = Wall.SPR_WALL[16];
				
			case 16:
				subSpr = Water.SPR_WATER[0];
			case 17:
				subSpr = Water.SPR_WATER[1];
				
			case 18:
				if (getInventory().containsCompass) {
					subSpr = MountainPath.SPR_MOUNTAINPATH_EDITOR;
				} else {
					subSpr = MountainPath.SPR_MOUNTAINPATH;
				}
		}
			
		if (subSpr != null) {
			Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, subSpr);
		}
	}
	
	function canEnterSubType(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (subType >= 2 && subType <= 4) return false; // Wald
		if (subType >= 6 && subType <= 9) return false; // Berg
		if (subType >= 11 && subType <= 16) return false; // Mauer
		
		return true;
	}
	
	public function canBeUnder(e:Entity):Bool {
		return false;
	}
	
	// können Objekte kombiniert werden?
	public function canCombine(e:Entity, ?reverse:Bool = false):Bool {
		return false;
	}
	
	// kombiniere Objekte
	public function doCombine(e:Entity, ?reverse:Bool = false) {
		
	}
}

typedef EntityData = {
	id:String, 
	type:Int, 
	subType:Int, 
	content:String, 
	flag:Int, 
	x:Int, 
	y:Int, 
	drift:Int 
};