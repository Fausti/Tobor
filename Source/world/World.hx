package world;

import world.entities.std.Charlie;
import tjson.TJSON;
/**
 * ...
 * @author Matthias Faust
 */
class World {
	public var factory:ObjectFactory;
	
	private var roomCurrent:Room;
	public var room(get, null):Room;
	
	public var roomList:Array<Room> = [];
	
	public var player:Charlie;
	
	public function new() {
		factory = new ObjectFactory();
		
		player = cast factory.create("OBJ_CHARLIE");
		player.setPosition(20, 14);
		
		addRoom(createRoom(0, 0, 0));
		switchRoom(0, 0, 0);
		
		player.setRoom(roomCurrent);
	}
	
	public function update(deltaTime:Float) {
		if (player != null) player.update(deltaTime);
		if (roomCurrent != null) roomCurrent.update(deltaTime);
	}
	
	public function render() {
		if (roomCurrent != null) roomCurrent.render();
		if (player != null) player.render();
	}
	
	public function render_editor() {
		if (roomCurrent != null) roomCurrent.render_editor();
		if (player != null) player.render_editor();
	}
	
	function get_room():Room {
		return roomCurrent;
	}
	
	public function createRoom(x:Int, y:Int, z:Int, ?data:Dynamic = null):Room {
		var r:Room = findRoom(x, y, z);
		
		if (r == null) {
			r = new Room(this);
			r.x = x;
			r.y = y;
			r.z = z;
		}
		
		return r;
	}
	
	public function addRoom(r:Room) {
		if (roomList.indexOf(r) == -1) {
			roomList.push(r);
		}
	}
	
	public function findRoom(x:Int, y:Int, z:Int):Room {
		for (r in roomList) {
			if (r.x == x && r.y == y && r.z == z) {
				return r;
			}
		}
		
		return null;
	}
	
	public function switchRoom(x:Int, y:Int, z:Int) {
		var r:Room = findRoom(x, y, z);
		
		if (r != null) roomCurrent = r;
	}
	
	// Save / Load
	
	public function save():String {
		var data:Map<String, Dynamic> = new Map<String, Dynamic>();

		data.set("player", player.saveData());
		
		for (r in roomList) {
			var worldData:Map<String, Dynamic> = new Map();
			
			worldData.set("x", r.x);
			worldData.set("y", r.y);
			worldData.set("z", r.z);
			
			worldData.set("data", r.save());
			
			data.set("ROOM_" + r.x + "_" + r.y + "_" + r.z, worldData);
		}
		
		return TJSON.encode(data, 'fancy');
	}
}