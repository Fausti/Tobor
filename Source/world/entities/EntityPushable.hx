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
	
	override public function isSolid(e:Entity):Bool {
		var blocked:Bool = false;
		
		var dx:Int = gridX - e.gridX;
		var dy:Int = gridY - e.gridY;
		
		if (dy != 0 && dx != 0) return true;
		
		if (room.outOfRoom(gridX + dx, gridY + dy)) return true;
		
		for (c in room.getEntitiesAt(gridX + dx, gridY + dy, this)) {
			if (c.isSolid(this)) {
				return true;
			}
		}
		
		if (!isMoving) {
			move(dx, dy);
		}
		
		return blocked;
	}
	
}