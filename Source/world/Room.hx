package world;

import lime.math.Rectangle;
import world.World;
import world.entities.Entity;
import world.entities.EntityRoof;
import world.entities.std.Charlie;
import world.entities.std.Robot;
import world.ObjectFactory.ObjectTemplate;
import world.entities.std.StartPosition;
import world.entities.std.TeleportEnd;
import world.entities.std.Stairs;

/**
 * ...
 * @author Matthias Faust
 */
class Room {
	public static inline var LAYER_FLOOR:Int = 0;
	public static inline var LAYER_LEVEL_0:Int = 10;
	public static inline var LAYER_LEVEL_1:Int = 20;
	public static inline var LAYER_ROOF:Int = 30;
	
	public static inline var LAYER_DRIFT:Int = 98;
	public static inline var LAYER_MARKER:Int = 99;
	
	public static inline var WIDTH:Int = 40;
	public static inline var HEIGHT:Int = 28;
	
	public var world:World;
	public var x:Int;
	public var y:Int;
	public var z:Int;
	
	// Objectlisten
	private var entities:EntityList;
	public var length(get, null):Int;
	
	public var robots:Int = 0;
	public var underRoof:Bool = false;
	
	var listRemove:Array<Entity>;
	
	function get_length():Int {
		return entities.length;
	}
	
	public function new(w:World, ?x:Int = 0, ?y:Int = 0, ?z:Int = 0) {
		this.world = w;
		this.x = x;
		this.y = y;
		this.z = z;
		
		entities = new EntityList(this);
	}
	
	public function start() {
		for (e in entities.getAll()) {
			e.onGameStart();
			e.onRoomStart();
		}
	}
	
	public function clear() {
		entities.clear();
	}
	
	public function update(deltaTime:Float) {
		listRemove = [];
		
		// Anzahl lebender Roboter
		robots = 0;
		for (e in entities.getTicking()) {
			if (Std.is(e, Robot)) robots++;
		}
		
		for (e in entities.getTicking()) {
			if (e.alive) {
				e.update(deltaTime);
			}
			
			if (!e.alive) {
				listRemove.push(e);
			}
		}
		
		for (e in listRemove) {
			removeEntity(e);
		}

		underRoof = false;
		
		if (world.player.visible) {
			var atPlayerPos:Array<Entity> = getAllEntitiesAt(world.player.x, world.player.y, world.player);
			for (e in atPlayerPos) {
				if (Std.is(e, EntityRoof)) {
					underRoof = true;
					return;
				}
			}
		}
	}
	
	public function render(?editMode:Bool = false) {
		var playerDrawn:Bool = false;
		
		entities.getAll().sort(function (a:Entity, b:Entity):Int {
			if (a.z < b.z) return -1;
			if (a.z > b.z) return 1;
			return 0;
		});
		
		for (e in entities.getAll()) {
			if (e.z > world.player.z) {
				if (!playerDrawn) {
					playerDrawn = true;
					if (world.player != null) {
						if (editMode) world.player.render_editor();
						else {
							if (world.player.visible) world.player.render();
						}
					}
				}
			}
			
			if (editMode) e.render_editor();
			else {
				if (e.visible) e.render();
			}
		}
		
		if (!playerDrawn) {
			if (world.player != null) {
				if (editMode) world.player.render_editor();
				else {
					if (world.player.visible) world.player.render();
				}
			}
		}
	}
	
	public function onRoomStart() {
		for (e in entities.getAll()) {
			e.onRoomStart();
		}
	}
	
	public function onRoomEnd() {
		for (e in entities.getAll()) {
			e.onRoomEnds();
		}
	}
	
	public function spawnEntity(x:Float, y:Float, e:Entity) {
		e.x = x;
		e.y = y;
		
		addEntity(e);
	}
	
	public function addEntity(e:Entity) {
		if (Std.is(e, Charlie)) {
			trace("Player shouldn't added to rooms!");
			return;
		}
		
		entities.add(e);
		
		entities.getAll().sort(function (a:Entity, b:Entity):Int {
			if (a.z < b.z) return -1;
			if (a.z > b.z) return 1;
			return 0;
		});
	}
	
	public function removeEntity(e:Entity) {
		entities.remove(e);
	}
	
	public function getCollisionsAt(x:Float, y:Float, ?without:Entity = null):Array<Entity> {
		var listTarget:Array<Entity> = entities.getAll().filter(function(e):Bool {
			return e.collisionAt(x, y);
		});
		
		if (world.player.collisionAt(x, y)) listTarget.push(world.player);
		
		if (without != null) listTarget.remove(without);
		
		return listTarget;
	}
	
	public function getCollisionsWithAI(x:Float, y:Float, ?w:Float = 1, ?h:Float = 1, ?without:Entity = null):Array<Entity> {
		var bb:Rectangle = new Rectangle(x, y, w, h);
		
		var listTarget:Array<Entity> = entities.getAI().filter(function(e):Bool {
			if (!e.alive) return false;
			return e.getBoundingBox().intersects(bb);
		});
		
		if (world.player.getBoundingBox().intersects(bb)) listTarget.push(world.player);
		
		if (without != null) listTarget.remove(without);
		
		return listTarget;
	}
	
	public function getEntitiesAt(x:Float, y:Float, ?without:Entity = null):Array<Entity> {
		var listTarget:Array<Entity> = entities.getAt(x, y, without);
		
		var remTarget:Array<Entity> = listTarget.filter(function (e) {
			if (!Std.is(e, EntityRoof)) return true; return false;
		});
				
		if (world.player.gridX == x && world.player.gridY == y) remTarget.push(world.player);
		
		return remTarget;
	}
	
	public function getAllEntitiesAt(x:Float, y:Float, ?without:Entity = null):Array<Entity> {
		var listTarget:Array<Entity> = entities.getAt(x, y, without);
		
		if (world.player.gridX == x && world.player.gridY == y) listTarget.push(world.player);
		
		return listTarget;
	}
	
	public function findAll(cl:Dynamic):Array<Entity> {
		var listTarget:Array<Entity> = [];
		
		for (e in entities.getAll()) {
			if (Std.is(e, cl)) listTarget.push(e);
		}
		
		return listTarget;
	}
	
	public function findEntityAt(x:Float, y:Float, cl:Dynamic):Array<Entity> {
		var listTarget:Array<Entity> = entities.getAll().filter(function(e):Bool {
			return e.gridX == Std.int(x) && e.gridY == Std.int(y) && e.alive && Std.is(e, cl);
		});
		
		if (Std.is(world.player, cl)) {
			if (world.player.gridX == x && world.player.gridY == y) listTarget.push(world.player);
		}
		
		return listTarget;
	}
	
	public function findEntityAround(x:Float, y:Float, cl:Dynamic):Array<Entity> {
		var list:Array<Entity> = [];
		
		for (mx in 0 ... 3) {
			for (my in 0 ... 3) {
				for (e in findEntityAt(x + mx - 1, y + my - 1, cl)) {
					list.push(e);
				}
			}
		}
		
		return list;
	}
	
	public function getPlayer():Charlie {
		return world.player;
	}
	
	// Save / Load
	
	public function saveState() {
		entities.saveState();
	}
	
	public function restoreState() {
		entities.restoreState();
	}
	
	public function load(data) {
		for (entry in cast(data, Array<Dynamic>)) {
			var template:ObjectTemplate = world.factory.findFromID(entry.id);
			
			if (template != null) {
				var obj = template.create();
				obj.parseData(entry);
			
				addEntity(obj);
			} else {
				trace("There is no Entity with ID of: " + entry.id);
			}
		}
		
		saveState();
	}
	
	public function save():Array<Map<String, Dynamic>> {
		entities.saveState();
		
		var data:Array<Map<String, Dynamic>> = [];
		
		for (e in entities.getState()) {
			if (e != null) {
				if (!Std.is(e, Charlie)) {
					if (e.canSave()) {
						data.push(e.saveData());
					}
				}
			}
		}
		
		return data;
	}
	
	public function switchStatus(f:Int, ?e:Entity = null) {
		for (ee in entities.getElectric()) {
			if (e != ee) if (ee.flag == f) ee.switchStatus();
		}
	}
	
	public function getInventory():Inventory {
		return world.inventory;
	}
	
	public function removeStateEntity(cl:Dynamic) {
		entities.removeState(cl);
	}
	
	public function findStartPosition():StartPosition {
		for (e in entities.getState()) {
			if (Std.is(e, StartPosition)) return cast e;
		}
		
		return null;
	}
	
	public function findStairs(stairsX:Int, stairsY:Int, stairsType:Int):Entity {
		for (e in entities.getState()) {
			if (Std.is(e, Stairs)) {
				if (e.type == stairsType && e.gridX == stairsX && e.gridY == stairsY) {
					return e;
				}
			}
		}
		
		return null;
	}
	
	public function findTeleportTarget(_type:Int, _content:String):Entity {
		for (e in findAll(TeleportEnd)) {
			if (e.type == _type && e.content == _content) return e;
		}
		
		return null;
	}
	
	public function findTeleportTargetState(_type:Int, _content:String):Entity {
		for (e in entities.getState()) {
			if (Std.is(e, TeleportEnd)) {
				if (e.type == _type && e.content == _content) return e;
			}
		}
		
		return null;
	}
	
	public function getID():String {
		return "ROOM_" + x + "" + y + "" + z;
	}
	
	public function getName():String {
		return Text.getFromWorld("TXT_" + getID());
	}
	
	// STATIC
	
	public static function isOutsideMap(x:Float, y:Float):Bool {
		return x < 0 || x >= Room.WIDTH || y < 0 || y >= Room.HEIGHT;
	}
}