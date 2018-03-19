package world;

import world.World;
import world.entities.Entity;
import world.entities.EntityDynamic;
import world.entities.EntityStatic;
import world.entities.std.Charlie;
import world.entities.std.Robot;
import world.ObjectFactory.ObjectTemplate;

/**
 * ...
 * @author Matthias Faust
 */
class Room {
	public static inline var LAYER_FLOOR:Int = 0;
	public static inline var LAYER_LEVEL_0:Int = 10;
	public static inline var LAYER_LEVEL_1:Int = 20;
	public static inline var LAYER_ROOF:Int = 30;
	
	public static inline var WIDTH:Int = 40;
	public static inline var HEIGHT:Int = 28;
	
	public var world:World;
	public var x:Int;
	public var y:Int;
	public var z:Int;
	
	// Savestate Liste
	private var listState:Array<Entity> = [];
	
	// Objectlisten
	private var listAll:Array<Entity> = [];
	private var listDynamic:Array<Entity> = [];
	private var listStatic:Array<Entity> = [];
	
	// Liste mit zu löschenden Objekten
	private var listRemove:Array<Entity> = [];

	public var length(get, null):Int;
	public var lengthState(get, null):Int;
	
	public var robots:Int = 0;
	
	function get_length():Int {
		return listAll.length;
	}
	
	function get_lengthState():Int {
		return listState.length;
	}
	
	public function new(w:World, ?x:Int = 0, ?y:Int = 0, ?z:Int = 0) {
		this.world = w;
		this.x = x;
		this.y = y;
		this.z = z;
	}
	
	public function update(deltaTime:Float) {
		listRemove = [];
		
		robots = 0;
		for (e in listDynamic) {
			if (Std.is(e, Robot)) robots++;
		}
		
		for (e in listDynamic) {
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
		
		listAll.sort(function (a:Entity, b:Entity):Int {
			if (a.z < b.z) return -1;
			if (a.z > b.z) return 1;
			return 0;
		});
	}
	
	public function render() {
		var playerDrawn:Bool = false;
		
		for (e in listAll) {
			if (e.z > world.player.z) {
				if (!playerDrawn) {
					playerDrawn = true;
					if (world.player != null) world.player.render();
				}
			}
			
			e.render();
		}
		
		if (!playerDrawn) if (world.player != null) world.player.render();
	}
	
	public function render_editor() {
		var playerDrawn:Bool = false;
		
		for (e in listState) {
			if (e.z > world.player.z) {
				if (!playerDrawn) {
					playerDrawn = true;
					if (world.player != null) world.player.render();
				}
			}
			
			e.render_editor();
		}
		
		if (!playerDrawn) if (world.player != null) world.player.render();
	}
	
	public function spawnEntity(x:Float, y:Float, e:Entity) {
		e.x = x;
		e.y = y;
		
		addEntity(e, true);
	}
	
	public function addEntity(e:Entity, ?ignoreCollision = false) {
		if (e == null) {
			trace("addEntity: object is null!");
			return;
		}
		
		if (Std.is(e, Charlie)) {
			trace("Player shouldn't added to rooms!");
			return;
		}
		
		if (!ignoreCollision) {
			if (getEntitiesAt(e.x, e.y).length > 0) {
				// Position ist schon belegt :(
				return;
			}
		}
		
		if (listAll.indexOf(e) == -1) {
			listAll.push(e);
		}
		
		var list:Array<Entity> = null;
		
		if (Std.is(e, EntityDynamic)) {
			list = listDynamic;
		} else if (Std.is(e, EntityStatic)) {
			list = listStatic;
		}
		
		if (list != null) {
			if (list.indexOf(e) == -1) {
				list.push(e);
			}
		}
		
		e.setRoom(this);
		e.init();
	}
	
	public function addEntity_editor(e:Entity) {
		if (Std.is(e, Charlie)) {
			trace("Player shouldn't added to rooms!");
			return;
		}
		
		if (getEntitiesAt_editor(e.x, e.y).length > 0) {
			// Position ist schon belegt :(
			return;
		}
		
		if (listState.indexOf(e) == -1) {
			listState.push(e);
		}
		
		e.setRoom(this);
	}
	
	public function removeEntity(e:Entity) {
		e.setRoom(null);
		
		listAll.remove(e);
		listStatic.remove(e);
		listDynamic.remove(e);
	}
	
	public function removeEntity_editor(e:Entity) {
		e.setRoom(null);
		
		listState.remove(e);
	}
	
	public function getCollisionsAt(x:Float, y:Float, ?without:Entity = null):Array<Entity> {
		var listTarget:Array<Entity> = listAll.filter(function(e):Bool {
			return e.collisionAt(x, y);
		});
		
		if (without != null) listTarget.remove(without);
		
		return listTarget;
	}
	
	public function getEntitiesAt(x:Float, y:Float, ?without:Entity = null):Array<Entity> {
		var listTarget:Array<Entity> = listAll.filter(function(e):Bool {
			return e.gridX == Std.int(x) && e.gridY == Std.int(y) && e.alive;
		});
		
		if (without != null) listTarget.remove(without);
		
		return listTarget;
	}
	
	public function getEntitiesAt_editor(x:Float, y:Float):Array<Entity> {
		var listTarget:Array<Entity> = listState.filter(function(e):Bool {
			return e.gridX == Std.int(x) && e.gridY == Std.int(y);
		});
		
		return listTarget;
	}
	
	public function findEntityAt(x:Float, y:Float, cl:Dynamic):Array<Entity> {
		var listTarget:Array<Entity> = listAll.filter(function(e):Bool {
			return e.gridX == Std.int(x) && e.gridY == Std.int(y) && e.alive && Std.is(e, cl);
		});
		
		return listTarget;
	}
	
	public function getPlayer():Charlie {
		return world.player;
	}
	
	// Save / Load
	
	public function clear(?state:Bool = false) {
		listAll = [];
		listDynamic = [];
		listStatic = [];
	
		listRemove = [];
		
		if (state) {
			listState = [];
		}
	}
	
	public function saveState() {
		listState = [];
		
		for (e in listAll) {
			listState.push(e.clone());
		}
		
		clear();
	}
	
	public function loadState() {
		clear();
		
		for (e in listState) {
			addEntity(e.clone());
		}
	}
	
	public function load(data) {
		listState = [];
		
		for (entry in cast(data, Array<Dynamic>)) {
			var template:ObjectTemplate = world.factory.findFromID(entry.id);
			
			var obj = template.create();
			obj.parseData(entry);
			
			obj.init();
			
			addEntity_editor(obj);
		}
	}
	
	public function save():Array<Map<String, Dynamic>> {
		var data:Array<Map<String, Dynamic>> = [];
		
		for (e in listAll) {
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
	
	public function save_editor():Array<Map<String, Dynamic>> {
		var data:Array<Map<String, Dynamic>> = [];
		
		for (e in listState) {
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
}