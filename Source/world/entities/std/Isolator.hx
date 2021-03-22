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
		if (Std.isOfType(e, IceBlock)) return false;
		
		if (!(Std.isOfType(e, Charlie) || Std.isOfType(e, EntityPushable) || Std.isOfType(e, Bullet))) return false;
		if (isOutsideMap(x + direction.x, y + direction.y)) return false;
		
		var atTarget:Array<Entity> = room.getCollisionsAt(x + direction.x, y + direction.y);
			
		for (e in atTarget) {
			if (!e.canEnter(this, direction, speed)) return false;
		}
		
		move(direction, speed);
		
		return true;
	}
	
	override public function hasWeight():Bool {
		return (!Std.isOfType(this, SoftIsolator));
	}
}