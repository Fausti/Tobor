package world.entities;
import lime.math.Vector2;
import world.entities.Entity;
import world.entities.std.Charlie;
import world.entities.std.Isolator;

/**
 * ...
 * @author Matthias Faust
 */
class EntityCollectable extends EntityStatic {
	public function new() {
		super();
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (Std.is(e, EntityPushable)) {
			return false;
		}
		
		return true;
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