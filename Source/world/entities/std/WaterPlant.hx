package world.entities.std;

import world.entities.EntityFloor;
import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class WaterPlant extends EntityFloor {
	public function new() {
		super();
		
		setSprite(Gfx.getSprite(144, 72));
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (Std.is(e, Charlie)) {
			return true;
		}
		
		return false;
	}
}