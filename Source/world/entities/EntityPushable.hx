package world.entities;

import lime.math.Vector2;
import world.entities.std.Charlie;
import world.entities.std.IceBlock;

/**
 * ...
 * @author Matthias Faust
 */
class EntityPushable extends EntityMoveable {

	public function new() {
		super();
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (Std.is(e, IceBlock)) return false;
		
		if (!(Std.is(e, Charlie) || Std.is(e, EntityPushable))) return false;
		if (isOutsideMap(x + direction.x, y + direction.y)) return false;
		
		var atTarget:Array<Entity> = room.getCollisionsAt(x + direction.x, y + direction.y);
			
		for (e in atTarget) {
			if (!e.canEnter(this, direction, speed)) return false;
		}
		
		move(direction, speed);
		
		return true;
	}
}