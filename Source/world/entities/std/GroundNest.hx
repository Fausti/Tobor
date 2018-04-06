package world.entities.std;

import world.entities.EntityStatic;
import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class GroundNest extends EntityStatic {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(240, 24));
	}

	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (Std.is(e, Charlie) || Std.is(e, EntityAI)) return true;
		
		return false;
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		if (Std.is(e, Charlie) || Std.is(e, EntityAI)) {
			var robot:Robot = new Robot();
			robot.init();
			
			room.spawnEntity(x, y, robot);
			
			die();
		}
	}
}