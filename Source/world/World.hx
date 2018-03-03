package world;
import world.entities.std.Charlie;

/**
 * ...
 * @author Matthias Faust
 */
class World {
	public var roomCurrent:Room;
	public var roomList:Array<Room> = [];
	
	public var player:Charlie;
	
	public function new() {
		player = new Charlie();
		player.setPosition(20, 14);
		
		var room = new Room(this);
		
		roomCurrent = room;
		roomList.push(room);
		
		player.setRoom(roomCurrent);
	}
	
	public function update_begin(deltaTime:Float) {
		if (player != null) player.update_begin(deltaTime);
		if (roomCurrent != null) roomCurrent.update_begin(deltaTime);
	}
	
	public function update_end(deltaTime:Float) {
		if (player != null) player.update_end(deltaTime);
		if (roomCurrent != null) roomCurrent.update_end(deltaTime);
	}
	
	public function render() {
		if (roomCurrent != null) roomCurrent.render();
		if (player != null) player.render();
	}
}