package world;

import world.entities.Entity;
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
	
	var listState:Array<Entity>;
	
	public var length(get, null):Int;
	
	public function new(room:Room) {
		this.room = room;
		
		clear();
	}
	
	public function clear() {
		listAll = [];
		listTicking = [];
		listElectric = [];
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
	}
	
	public function getAt(x:Float, y:Float, ?without:Entity = null):Array<Entity> {
		var listTarget:Array<Entity> = listAll.filter(function(e):Bool {
			return e.gridX == Std.int(x) && e.gridY == Std.int(y);
		});
		
		if (without != null) listTarget.remove(without);
		
		return listTarget;
	}
	
	public function getAll():Array<Entity> {
		return listAll;
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