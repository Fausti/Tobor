package world.entities.std;

import world.entities.EntityFloor;
import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class IceDeadly extends EntityFloor {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(0, 180));
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (Std.is(e, Charlie) || Std.is(e, Robot) || Std.is(e, Android)) {
			return true;
		}
		
		return false;
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		if (!e.alive || !e.visible) return;
		
		if (Std.is(e, Charlie) || Std.is(e, Robot) || Std.is(e, Android)) {
			e.die();
		}
	}
}