package world.entities;
import lime.math.Vector2;
import world.entities.Entity;
import world.entities.std.Charlie;

/**
 * ...
 * @author Matthias Faust
 */
class EntityCollectable extends EntityStatic {
	public function new() {
		super();
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		if (Std.is(e, Charlie)) {
			
			onPickup();
			die();
		}
	}
	
	public function onPickup() {
		
	}
}