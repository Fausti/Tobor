package world.entities;
import world.Room;

/**
 * ...
 * @author Matthias Faust
 */
class ObjectDynamic extends Object {

	public function new(?type:Int=0) {
		super(type);
	}
	
	override public function setRoom(room:Room) {
		super.setRoom(room);
		
		room.register(this);
	}
	
	override public function destroy() {
		room.unregister(this);
		
		super.destroy();
	}
}