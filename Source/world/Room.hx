package world;

import world.World;
import world.entities.Entity;
import world.entities.EntityDynamic;
import world.entities.EntityStatic;
import world.entities.std.Charlie;

/**
 * ...
 * @author Matthias Faust
 */
class Room {
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
	
	function get_length():Int {
		return listAll.length;
	}
	
	public function new(w:World, ?x:Int = 0, ?y:Int = 0, ?z:Int = 0) {
		this.world = w;
		this.x = x;
		this.y = y;
		this.z = z;
	}
	
	public function update(deltaTime:Float) {
		listRemove = [];
		
		for (e in listDynamic) {
			if (e.alive) e.update(deltaTime);
			
			if (!e.alive) {
				listRemove.push(e);
			}
		}
		
		for (e in listRemove) {
			removeEntity(e);
		}
	}
	
	public function render() {
		for (e in listAll) {
			e.render();
		}
	}
	
	public function render_editor() {
		for (e in listState) {
			e.render_editor();
		}
	}
	
	public function addEntity(e:Entity) {
		if (e == null) {
			trace("addEntity: object is null!");
			return;
		}
		
		if (Std.is(e, Charlie)) {
			trace("Player shouldn't added to rooms!");
			return;
		}
		
		if (getEntitiesAt(e.x, e.y).length > 0) {
			// Position ist schon belegt :(
			return;
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
	
	public function getEntitiesAt(x:Float, y:Float, ?without:Entity = null):Array<Entity> {
		var listTarget:Array<Entity> = listAll.filter(function(e):Bool {
			return e.gridX == Std.int(x) && e.gridY == Std.int(y);
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
}