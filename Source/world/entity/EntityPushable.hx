package world.entity;

import gfx.Gfx;
import gfx.Sprite;
import world.entity.Entity;

/**
 * ...
 * @author Matthias Faust
 */
class EntityPushable extends EntityMoveable {

	public function new() {
		super();
		
		gfx = new Sprite(Tobor.Tileset.find("Isolator_0"));
	}
	
	override public function isSolid(e:Entity):Bool {
		var blocked:Bool = false;
		
		var dx:Int = gridX - e.gridX;
		var dy:Int = gridY - e.gridY;
		
		// trace(dx, dy);
		
		if (dy != 0 && dx != 0) return true;
		
		if (room.outOfRoom(gridX + dx, gridY + dy)) return true;
		
		for (c in room.getEntitiesAt(gridX + dx, gridY + dy, this)) {
			if (c.isSolid(this)) {
				// trace("Blocked!");
				return true;
			}
		}
		
		if (!isMoving) {
			// trace("Moving!");
			move(dx, dy);
		}
		
		return blocked;
	}
	
}