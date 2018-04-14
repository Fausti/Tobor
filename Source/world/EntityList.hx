package world;

import world.entities.Entity;
import world.entities.EntityAI;
import world.entities.EntityDynamic;
import world.entities.interfaces.IElectric;

/**
 * ...
 * @author Matthias Faust
 */
class EntityList {
	var room:Room;
	
	var listAll:Array<Entity>;
	var listTicking:Array<Entity>;
	var listElectric:Array<Entity>;
	var listAI:Array<Entity>;
	
	var listState:Array<Entity> = [];
	
	public var length(get, null):Int;
	
	public function new(room:Room) {
		this.room = room;
		
		clear();
	}
	
	public function clear() {
		listAll = [];
		listTicking = [];
		listElectric = [];
		listAI = [];
	}
	
	public function addState(e:Entity) {
		listState.push(e);
		
		e.room = room;
		e.init();
	}
	
	public function add(e:Entity) {
		if (e == null) return;
		
		if (listAll.indexOf(e) == -1) {
			listAll.push(e);
		}
		
		if (Std.is(e, EntityDynamic)) {
			if (listTicking.indexOf(e) == -1) {
				listTicking.push(e);
			}
		}
		
		if (Std.is(e, IElectric)) {
			if (listElectric.indexOf(e) == -1) {
				listElectric.push(e);
			}
		}
		
		if (Std.is(e, EntityAI)) {
			if (listAI.indexOf(e) == -1) {
				listAI.push(e);
			}
		}
		
		listAll.sort(function (a:Entity, b:Entity):Int {
			if (a.z < b.z) return -1;
			if (a.z > b.z) return 1;
			return 0;
		});
		
		e.room = room;
		e.init();
		e.onAddToRoom();
	}
	
	public function remove(e:Entity) {
		if (e == null) return;
		
		e.onRemoveFromRoom();
		
		listAll.remove(e);
		listTicking.remove(e);
		listElectric.remove(e);
		listAI.remove(e);
	}
	
	public function removeState(cl:Dynamic) {
		for (e in listAll) {
			if (Std.is(e, cl)) {
				remove(e);
			}
		}
		
		for (e in listState) {
			if (Std.is(e, cl)) {
				listState.remove(e);
			}
		}
	}
	
	public function getAt(x:Float, y:Float, ?without:Entity = null, ?withoutType:Dynamic = null):Array<Entity> {
		var listTarget:Array<Entity>;
		
		if (withoutType == null) {
			listTarget = listAll.filter(function(e):Bool {
				return e.gridX == Std.int(x) && e.gridY == Std.int(y);
			});
		} else {
			listTarget = listAll.filter(function(e):Bool {
				return e.gridX == Std.int(x) && e.gridY == Std.int(y) && !Std.is(e, withoutType);
			});
		}
		
		if (without != null) listTarget.remove(without);
		
		return listTarget;
	}
	
	public function getAll():Array<Entity> {
		return listAll;
	}
	
	public function getAI():Array<Entity> {
		return listAI;
	}
	
	public function getElectric():Array<Entity> {
		return listElectric;
	}
	
	public function getTicking():Array<Entity> {
		return listTicking;
	}
	
	public function getState():Array<Entity> {
		return listState;
	}
	
	public function saveState() {
		listState = [];
		
		for (e in listAll) {
			if (e != null) {
				listState.push(e.clone());
			}
		}
	}
	
	public function restoreState() {
		clear();
		
		for (e in listState) {
			if (e != null) {
				add(e.clone());
			}
		}
	}
	
	function get_length():Int {
		return listAll.length;
	}
}