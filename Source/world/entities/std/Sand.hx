package world.entities.std;

import lime.math.Vector2;
import world.entities.Entity;
import world.entities.EntityFloor;
import world.entities.EntityMoveable;

/**
 * ...
 * @author Matthias Faust
 */
class Sand extends EntityFloor {

	public function new() {
		super();
	}
	
	override public function init() {
		super.init();
		
		switch(type) {
			case 0:
				setSprite(Gfx.getSprite(0, 24));
			case 1:
				setSprite(Gfx.getSprite(16, 24));
			case 2:
				setSprite(Gfx.getSprite(32, 24));
			case 3:
				setSprite(Gfx.getSprite(48, 24));
			case 4:
				setSprite(Gfx.getSprite(64, 24));
		}
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (Std.is(e, Charlie) || Std.is(e, EntityAI)) return true;
		
		return false;
	}
	
	override public function willEnter(e:Entity, direction:Vector2, ?speed:Float = 0) {
		super.willEnter(e, direction, Charlie.PLAYER_SPEED);
		
		var ee:EntityMoveable = cast e;
		ee.changeSpeed(Charlie.PLAYER_SPEED / 4);
	}
}