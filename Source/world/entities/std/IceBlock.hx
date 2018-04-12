package world.entities.std;

import world.entities.EntityPushable;
import world.entities.interfaces.IElectric;
import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class IceBlock extends EntityPushable implements IElectric {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(144, 324));
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (!(Std.is(e, Charlie) || Std.is(e, Isolator))) return false;
		if (isOutsideMap(x + direction.x, y + direction.y)) return false;
		
		var atTarget:Array<Entity> = room.getCollisionsAt(x + direction.x, y + direction.y);
			
		for (e in atTarget) {
			if (!e.canEnter(this, direction, speed)) return false;
		}
		
		move(direction, speed);
		
		return true;
	}
	
	override public function hasWeight():Bool {
		return true;
	}
}