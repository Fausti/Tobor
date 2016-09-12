package world.entities;

import gfx.Gfx;
import gfx.Sprite;
import world.entities.Entity;

/**
 * ...
 * @author Matthias Faust
 */
class EntityPushable extends EntityMoveable {
	
	public function new(?type:Int = 0) {
		super(type);
	}
	
	override public function canEnter(e:Entity):Bool {
		var blocked:Bool = false;
		
		var dx:Int = gridX - e.gridX;
		var dy:Int = gridY - e.gridY;
		
		if (dy != 0 && dx != 0) return false;
		
		if (room.outOfRoom(gridX + dx, gridY + dy)) return false;
		
		for (c in room.getEntitiesAt(gridX + dx, gridY + dy, this)) {
			if (!c.canEnter(this)) {
				return false;
			}
		}
		
		if (!isMoving) {
			move(dx, dy);
		}
		
		return !blocked;
	}
	
}