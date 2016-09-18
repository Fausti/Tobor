package world.entities.core;

import gfx.Sprite;

/**
 * ...
 * @author Matthias Faust
 */
class Isolator extends ObjectPushable {
	var SPR_ISOLATOR:Sprite;
	var SPR_ISOLATOR_BODEN:Sprite;
	
	public function new(?type=0) {
		super(type);
		
		SPR_ISOLATOR = new Sprite(Tobor.Tileset.find("SPR_ISOLATOR"));
		SPR_ISOLATOR_BODEN = new Sprite(Tobor.Tileset.find("SPR_ISOLATOR_BODEN"));
		
		if (type == 0) {
			gfx = SPR_ISOLATOR;
		} else {
			gfx = SPR_ISOLATOR_BODEN;
		}
	}
	
	override public function canEnter(e:Object):Bool {
		if (type == 1) {
			if (isPlayer(e)) return true;
		}
		
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