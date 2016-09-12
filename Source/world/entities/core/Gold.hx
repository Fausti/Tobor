package world.entities.core;

import world.entities.Entity;
import world.entities.EntityPickup;

/**
 * ...
 * @author Matthias Faust
 */
class Gold extends EntityPickup {

	public function new() {
		super();
		
		gfx = new Sprite(Tobor.Tileset.find("SPR_GOLD"));
	}
	
	override
	public function canEnter(e:Entity):Bool {
		if (Std.is(e, EntityPushable)) return false;
		
		return true;
	}
	
	override public function onEnter(e:Entity) {
		if (e == room.world.player) {
			room.world.player.gold++;
		}
		
		super.onEnter(e);
	}
}