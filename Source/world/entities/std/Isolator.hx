package world.entities.std;

import lime.math.Vector2;
import world.entities.Entity;
import world.entities.EntityPushable;

/**
 * ...
 * @author Matthias Faust
 */
class Isolator extends EntityPushable {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(240, 0));
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (!(Std.is(e, Charlie) || Std.is(e, EntityPushable) || Std.is(e, Bullet))) return false;
		if (isOutsideMap(x + direction.x, y + direction.y)) return false;
		
		var atTarget:Array<Entity> = room.getCollisionsAt(x + direction.x, y + direction.y);
			
		for (e in atTarget) {
			if (!e.canEnter(this, direction, speed)) return false;
		}
		
		move(direction, speed);
		
		return true;
	}
}