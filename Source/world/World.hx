package world;
import world.entities.std.Charlie;

/**
 * ...
 * @author Matthias Faust
 */
class World {
	public var factory:Objects;
	
	public var roomCurrent:Room;
	public var roomList:Array<Room> = [];
	
	public var player:Charlie;
	
	public function new() {
		factory = new Objects();
		
		player = cast factory.create("OBJ_CHARLIE");
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
	
	public function render_editor() {
		if (roomCurrent != null) roomCurrent.render_editor();
		if (player != null) player.render_editor();
	}
}