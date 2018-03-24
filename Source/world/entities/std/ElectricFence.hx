package world.entities.std;

import lime.math.Vector2;
import world.entities.Entity;
import world.entities.EntityPushable;

/**
 * ...
 * @author Matthias Faust
 */
class ElectricFence extends EntityPushable {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(64, 12));
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (Std.is(e, Charlie) || Std.is(e, EntityAI)) {
			if (Std.is(e, Robot)) {
				// Roboter haben Hemmungen in den Zaun zu laufen!
				if (Std.random(10) == 0) return false;
			}
			
			return true;
		}
		
		return super.canEnter(e, direction, speed);
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		if (Std.is(e, Charlie) || Std.is(e, EntityAI)) {
			e.die();
			die();
		}
	}
}