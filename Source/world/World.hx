package world;
import world.entity.Charlie;

/**
 * ...
 * @author Matthias Faust
 */
class World {
	
	public var player:Charlie;
	
	var currentRoom:Room;
	var rooms:Array<Room> = [];
	
	public function new() {
		player = new Charlie();
		player.gridX = 0;
		player.gridY = 0;
		
		var room = new Room(0, 0, 0);
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
}