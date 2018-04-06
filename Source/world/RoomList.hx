package world;

/**
 * ...
 * @author Matthias Faust
 */
class RoomList {
	var list:Map<String, Room>;
	
	public function new() {
		list = new Map<String, Room>();
	}
	
	public function iterator() {
		return list.iterator();
	}
	
	public function add(r:Room) {
		if (list.get(r.position.id) != null) {
			trace('RoomList.add: room with coords ' + r.position.x + ", " + r.position.y + ', ' + r.position.z + 'already exists!');
			return;
		}
		
		if (r.position == null) {
			trace('RoomList.add: room position is null!');
			return;
		}
		
		list.set(r.position.id, r);
	}
	
	public function find(x:Int, y:Int, z:Int):Room {
		return list.get(new Position(x, y, z).id);
	}
}