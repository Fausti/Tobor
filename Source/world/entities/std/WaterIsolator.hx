package world.entities.std;

import lime.math.Vector2;
import world.entities.Entity;
import world.entities.EntityStatic;

/**
 * ...
 * @author Matthias Faust
 */
class WaterIsolator extends EntityStatic {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(112, 156));
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (Std.is(e, Charlie) || Std.is(e, Isolator) || Std.is(e, EntityAI)) {
			return true;
		}
		
		return false;
	}
	
}