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
	
	public function update(deltaTime:Float) {
		if (player != null) player.update(deltaTime);
		if (roomCurrent != null) roomCurrent.update(deltaTime);
	}
	
	public function render() {
		if (roomCurrent != null) roomCurrent.render();
		if (player != null) player.render();
	}
}