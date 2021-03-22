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
		if (Std.isOfType(e, Android)) return false;
		if (Std.isOfType(e, Charlie) || Std.isOfType(e, EntityAI)) return true;
		
		return false;
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		if (Std.isOfType(e, Charlie) || Std.isOfType(e, EntityAI)) {
			if (Std.isOfType(e, Android)) return;
			
			var robot:Robot = new Robot();
			robot.init();
			
			room.spawnEntity(x, y, robot);
			
			die();
		}
	}
}