package world.entities.std;

import lime.math.Vector2;
/**
 * ...
 * @author Matthias Faust
 */
class SoftIsolator extends Isolator {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(128, 132));
	}

	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (!(Std.is(e, Charlie) || Std.is(e, EntityPushable) || Std.is(e, Bullet) || Std.is(e, EntityAI))) return false;
		if (isOutsideMap(x + direction.x, y + direction.y)) return false;
		
		if (Std.is(e, Charlie) || Std.is(e, EntityAI)) {
			return true;
		}
		
		var atTarget:Array<Entity> = room.getCollisionsAt(x + direction.x, y + direction.y);
			
		for (e in atTarget) {
			if (!e.canEnter(this, direction, speed)) return false;
		}
		
		move(direction, speed);
		
		return true;
	}
}