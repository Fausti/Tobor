package world;
import haxe.ds.StringMap;
import sys.io.File;
import tjson.TJSON;
import world.entities.core.Charlie;

/**
 * ...
 * @author Matthias Faust
 */
class World {
	
	public var player:Charlie;
	
	var currentRoom:Room;
	public var rooms:Array<Room> = [];
	
	public function new() {
		player = new Charlie();
		player.gridX = 0;
		player.gridY = 0;
		
		var room = new Room(this, 0, 0, 0);
		addRoom(room);
		
		switchRoom(room);
	}
	
	public function addRoom(newRoom:Room) {
		var existingRoom:Room = findRoom(newRoom.worldX, newRoom.worldY, newRoom.worldZ);
		
		if (existingRoom == null) {
			rooms.push(newRoom);
		} else {
			trace("Tried to add existing room to room list!");
		}
	}
	
	public function findRoom(x:Int, y:Int, level:Int):Room {
		for (room in rooms) {
			if (room.worldX == x && room.worldY == y && room.worldZ == level) return room;
		}
		
		return null;
	}
	
	public function switchRoom(nextRoom) {
		if (currentRoom != null) {
			// unload
			currentRoom.remove(player);
		}
		
		currentRoom = nextRoom;
		currentRoom.add(player);
		
		currentRoom.redraw = true;
		
		// init room
	}
	
	public var room(get, set):Room;
	
	inline function get_room():Room {
		return currentRoom;
	}
	
	inline function set_room(nextRoom:Room):Room {
		switchRoom(nextRoom);
		
		return currentRoom;
	}
	
	// Save / Load
	
	public function load(fileName:String) {
		currentRoom = null;
		rooms = [];
		
		var fin = File.read(fileName, false);
		var fileData = fin.readAll().toString();
		fin.close();
		
		var data = TJSON.parse(fileData);
		
		for (key in Reflect.fields(data)) {
			switch(key) {
			case "player":
				parsePlayer(Reflect.field(data, "player"));
			default:
				if (StringTools.startsWith(key, "ROOM_")) {
					parseRoom(Reflect.field(data, key));
				} else {
					Debug.error(this, "Unknown key '" + key + "' in WorldData!");
				}
			}
		}
		
		/*
		for (roomData in data.data) {
			
		}
		*/
	}
	
	function parseRoom(data) {
		var rx:Int = -1;
		var ry:Int = -1;
		var rz:Int = -1;
		var rdata = null;
		
		for (key in Reflect.fields(data)) {
			switch(key) {
			case "x":
				rx = Reflect.field(data, "x");
			case "y":
				ry = Reflect.field(data, "y");
			case "z":
				rz = Reflect.field(data, "z");
			case "data":
				rdata = Reflect.field(data, "data");
			default:
			}
		}
		
		var newRoom:Room = new Room(this, rx, ry, rz);
		newRoom.load(rdata);
		
		addRoom(newRoom);
		switchRoom(newRoom);
	}
	
	function parsePlayer(data) {
		for (key in Reflect.fields(data)) {
			player.parseData(key, Reflect.field(data, key));
		}
	}
	
	public function save(fileName:String) {
		var data:Map<String, Dynamic> = new Map<String, Dynamic>();
		
		data.set("name", "Tobor I");
		data.set("player", player.saveData());
		
		for (r in rooms) {
			var rData:Map<String, Dynamic> = new Map();
			
			rData.set("x", r.worldX);
			rData.set("y", r.worldY);
			rData.set("z", r.worldZ);
			
			rData.set("data", r.save());
			
			data.set("ROOM_" + r.worldZ + "" + r.worldX + "" + r.worldY, rData);
		}
		
		var fout = File.write(fileName, false);
		fout.writeString(TJSON.encode(data, 'fancy'));
		fout.close();
	}
}