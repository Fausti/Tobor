package world.entities;
import world.entities.Entity;
import world.entities.core.Charlie;

/**
 * ...
 * @author Matthias Faust
 */
class EntityPickup extends Entity {

	public function new(?type:Int = 0) {
		super(type);
	}
	
	override public function onEnter(e:Entity) {
		if (e == room.world.player) {
			destroy();
		}
		
		super.onEnter(e);
	}
}