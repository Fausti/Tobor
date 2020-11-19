package world;

import lime.math.Rectangle;
import world.Position;
import world.World;
import world.entities.Entity;
import world.entities.EntityRoof;
import world.entities.std.Charlie;

import world.entities.std.Robot;
import world.entities.std.Android;
import world.entities.std.Shark;
import world.entities.std.Scorpion;

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
	public static inline var LAYER_OVERLAY:Int = 15;
	public static inline var LAYER_LEVEL_1:Int = 20;
	public static inline var LAYER_ROOF:Int = 30;
	
	public static inline var LAYER_DRIFT:Int = 98;
	public static inline var LAYER_MARKER:Int = 99;
	
	public static inline var WIDTH:Int = 40;
	public static inline var HEIGHT:Int = 28;
	
	public static inline var DARKNESS_OFF:Int = 0;
	public static inline var DARKNESS_HALF:Int = 1;
	public static inline var DARKNESS_FULL:Int = 2;
	
	public static inline var PATCH_REMOVE:Int = 0;
	
	public var config = {
		"music": "",
		"darkness": Room.DARKNESS_OFF,
	};
	
	public var world:World;
	public var position:Position;
	
	// Objectlisten
	private var entities:EntityList;
	public var length(get, null):Int;
	
	public var robots:Int = 0;
	
	public var underRoof:Bool = false;
	public var underRoofOld:Bool = false;
	
	public var treeTimer:Float = 0;
	
	var listRemove:Array<Entity>;
	
	public var saveData:Array<EntityData> = null;
	public var loaded:Bool = true;
	
	public var patches:List<RoomPatch> = null;
	
	function get_length():Int {
		return entities.length;
	}
	
	public function new(w:World, ?x:Int = 0, ?y:Int = 0, ?z:Int = 0) {
		this.world = w;
		this.position = new Position(x, y, z);
		
		entities = new EntityList(this);
	}
	
	public function start() {
		for (e in entities.getAll()) {
			e.onGameStart();
		}
	}
	
	public function clear(?clearState:Bool = false) {
		entities.clear(clearState);
	}
	
	public function update(deltaTime:Float) {
		listRemove = [];
		
		// Anzahl lebender Roboter
		robots = 0;
		for (e in entities.getTicking()) {
			if (Std.is(e, Robot) || Std.is(e, Android)) robots++;
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
		
		if (treeTimer != 0.0) {
			treeTimer = treeTimer - deltaTime;
			if (treeTimer < 0) treeTimer = 0.0;
		}

		underRoof = false;
		
		if (world.player.visible) {
			//var atPlayerPos:Array<Entity> = getAllEntitiesAt(world.player.x, world.player.y, world.player);
			//var atPlayerPos:Array<Entity> = findEntityAt(world.player.x, world.player.y, EntityRoof);
			var atPlayerPos:Array<Entity> = getCollisionsAt(world.player.x, world.player.y);
			for (e in atPlayerPos) {
				if (Std.is(e, EntityRoof)) {
					if (world.player.gridX == e.gridX && world.player.gridY == e.gridY) {
						underRoof = true;
						underRoofOld = underRoof;
						return;
					}
				}
			}
			
			underRoofOld = false;
		} else {
			underRoof = underRoofOld;
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
	
	public function renderPreview() {
		var playerDrawn:Bool = false;
		
		entities.getState().sort(function (a:Entity, b:Entity):Int {
			if (a.z < b.z) return -1;
			if (a.z > b.z) return 1;
			return 0;
		});
		
		for (e in entities.getState()) {
			if (e.z > world.player.z) {
				if (!playerDrawn) {
					playerDrawn = true;
					if (world.player != null) {
						//if (editMode) {
							world.player.render_editor();
						//} else {
							//if (world.player.visible) world.player.render();
						//}
					}
				}
			}
			
			// if (editMode) {
				e.render_editor();
			//} else {
				// if (e.visible) e.render();
			//}
		}
		
		if (!playerDrawn) {
			if (world.player != null) {
				//if (editMode) {
					world.player.render_editor();
				//} else {
					//if (world.player.visible) world.player.render();
				//}
			}
		}
	}
	
	public function onRoomStart() {
		if (world.isLoading) return;
		
		saveData = null;
		
		for (e in entities.getAll()) {
			e.onRoomStart();
		}
		
		getPlayer().onRoomStart();
		
		// Raummusik spielen
		
		Sound.playMusic(config.music);
	}
	
	public function onRoomEnd() {
		if (world.isLoading) return;
		
		// Musik anhalten...
		Sound.stopMusic(config.music);
		
		for (e in entities.getAll()) {
			e.onRoomEnds();
		}
		
		getPlayer().onRoomEnds();
		
		// Savedata nur vorbereiten wenn NICHT im Editor!
		if (!world.editing) saveData = save();
		
		// saveData = save();
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
	}
	
	public function removeEntity(e:Entity) {
		entities.remove(e);
	}
	
	public function addEntityState(e:Entity) {
		if (Std.is(e, Charlie)) {
			trace("Player shouldn't added to rooms!");
			return;
		}
		
		entities.addState(e);
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
	
	public function getEntitiesAt(x:Float, y:Float, ?without:Entity = null, ?withoutType:Dynamic = null):Array<Entity> {
		var listTarget:Array<Entity> = entities.getAt(x, y, without, withoutType);
		
		var remTarget:Array<Entity> = listTarget.filter(function (e) {
			if (!Std.is(e, EntityRoof)) return true; return false;
		});
				
		if (world.player.gridX == x && world.player.gridY == y) remTarget.push(world.player);
		
		return remTarget;
	}
	
	public function getAllEntitiesAt(x:Float, y:Float, ?without:Entity = null, ?withType:Dynamic = null):Array<Entity> {
		var listTarget:Array<Entity> = entities.getAt(x, y, without);
		
		if (world.player.gridX == x && world.player.gridY == y) {
			if (without != world.player) listTarget.push(world.player);
		}
		
		if (withType != null) {
			var remTarget:Array<Entity> = listTarget.filter(function (e) {
				if (Std.is(e, withType)) return true; return false;
			});
			
			listTarget = remTarget;
		}
		
		return listTarget;
	}
	
	public function findAll(cl:Dynamic):Array<Entity> {
		var listTarget:Array<Entity> = [];
		
		for (e in entities.getAll()) {
			if (Std.is(e, cl)) listTarget.push(e);
		}
		
		return listTarget;
	}
	
	public function findAllInState(cl:Dynamic):Array<Entity> {
		var listTarget:Array<Entity> = [];
		
		for (e in entities.getState()) {
			if (Std.is(e, cl)) listTarget.push(e);
		}
		
		return listTarget;
	}
	
	public function findHeavyEntitiesAt(x:Float, y:Float):Array<Entity> {
		var listTarget:Array<Entity> = entities.getAll().filter(function(e):Bool {
			return e.gridX == Std.int(x) && e.gridY == Std.int(y) && e.alive && e.hasWeight();
		});
		
		if (world.player.gridX == x && world.player.gridY == y) listTarget.push(world.player);
				
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
	
	public function addTreeTimer(v:Float) {
		treeTimer = v;
	}
	
	// Save / Load
	
	public function saveState() {
		entities.saveState();
	}
	
	public function restoreState() {
		entities.restoreState();
	}
	
	public function setData(data) {
		saveData = data;
		loaded = false;
	}
	
	public function load() {
		// Savegame Edit!!!
		/*
		var fix:Bool = false;
		if (position.id == "512") fix = true;
		*/
		
		for (entry in cast(saveData, Array<Dynamic>)) {
			var template:ObjectTemplate = world.factory.findFromID(entry.id);
			
			if (template != null) {
				var skip:Bool = false;
				
				/*
				if (fix) {
					if (entry.x == 7 && entry.y == 14) {
						if (entry.id == "OBJ_BEDROCK_0") continue;
						trace(entry);
					}
				}
				*/
				if (patches != null) {
					for (patch in patches) {
						switch (patch.cmd) {
							case Room.PATCH_REMOVE:
								if (entry.x == patch.x && entry.y == patch.y && entry.id == patch.objID) {
									patches.remove(patch);
									skip = true;
								}
							default:
						}
					}
				}
				
				if (skip) continue;
				
				var obj = template.create();
				obj.parseData(entry);
			
				addEntityState(obj);
			} else {
				trace("There is no Entity with ID of: " + entry.id);
			}
		}
		
		loaded = true;
	}
	
	public function save():Array<EntityData> {
		if (entities.length > 0) entities.saveState();
		
		var data:Array<EntityData> = [];
		
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
	
	public function findStartPosition():ActionTarget {
		if (saveData == null) {
			for (e in entities.getState()) {
				if (Std.is(e, StartPosition)) {
					var at:ActionTarget = new ActionTarget();
					at.gridX = Std.int(e.x);
					at.gridY = Std.int(e.y);
					
					return at;
				}
			}
		} else {
			for (el in saveData) {
				var eid = el.id;

				if (eid == "OBJ_START_POSITION") {
					var at:ActionTarget = new ActionTarget();
					at.gridX = el.x;
					at.gridY = el.y;
					
					return at;
				}
			}
		}
		
		return null;
	}
	
	// Treppe im geladenen Raum suchen...
	function findStairsOld(stairsX:Int, stairsY:Int, stairsType:Int):Entity {
		for (e in entities.getState()) {
			if (Std.is(e, Stairs)) {
				if (e.type == stairsType && e.gridX == stairsX && e.gridY == stairsY) {
					return e;
				}
			}
		}
		
		return null;
	}
	
	// Treppe in SaveData suchen...
	public function findStairs(stairsX:Int, stairsY:Int, stairsType:Int):ActionTarget {
		var at:ActionTarget = new ActionTarget();
		
		if (saveData == null) {
			var e = findStairsOld(stairsX, stairsY, stairsType);
			if (e != null) {
				at.gridX = e.gridX;
				at.gridY = e.gridY;
				at.roomX = position.x;
				at.roomY = position.y;
				at.roomZ = position.z;
				
				return at;
			}
			
			return null;
		}
		
		var searchFor = ["OBJ_STAIRS_UP", "OBJ_STAIRS_DOWN"];
		
		for (el in saveData) {
			var eid = el.id;

			if (eid == searchFor[stairsType]) {
				at.gridX = el.x;
				at.gridY = el.y;
				at.roomX = position.x;
				at.roomY = position.y;
				at.roomZ = position.z;
				
				if (at.gridX == stairsX && at.gridY == stairsY) {
					return at;
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
	
	public function findTeleportTargetState(_type:Int, _content:String):ActionTarget {
		var at:ActionTarget = new ActionTarget();
		
		if (saveData == null) return null;
		
		var searchFor = ["OBJ_TELEPORT_END_0", "OBJ_TELEPORT_END_1"];
		
		for (el in saveData) {
			var eid = el.id;
			
			if (eid == searchFor[_type]) {
				var ec = el.content;
				if (ec == _content) {
					at.gridX = el.x;
					at.gridY = el.y;
					at.roomX = position.x;
					at.roomY = position.y;
					at.roomZ = position.z;
				
					return at;
				}
			}
		}
		
		return null;
	}
	
	public function getID():String {
		return "ROOM_" + position.id;
	}
	
	public function getName():String {
		return GetText.getFromWorld("TXT_" + getID());
	}
	
	// STATIC
	
	public static function isOutsideMap(x:Float, y:Float):Bool {
		return x < 0 || x >= Room.WIDTH || y < 0 || y >= Room.HEIGHT;
	}
}

typedef RoomPatch = {
	cmd:Int,
	x:Int,
	y:Int,
	objID:String
};