package world.entities.std;

import world.entities.EntityPushable;
import world.entities.interfaces.IElectric;
import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class IceBlock extends EntityPushable implements IElectric {
	public var timeStamp:Float = 0;
	
	public function new() {
		super();
		
		setSprite(Gfx.getSprite(144, 324));
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (!(Std.isOfType(e, Charlie) || Std.isOfType(e, Bullet))) return false;
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
	
	override public function die() {
		// alle Objekte unter dem Iceblock informieren das er das Feld nun verlässt...
		// ... entgültig!
		var underMe = room.getAllEntitiesAt(gridX, gridY, this);
		
		for (e in underMe) {
			if (e.alive && e.visible) {
				e.onLeave(this, Direction.NONE);
			}
		}
		
		super.die();
	}
}