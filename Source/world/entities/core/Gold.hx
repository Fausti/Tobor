package world.entities.core;

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
	public function isSolid(e:Entity):Bool {
		if (Std.is(e, EntityPushable)) return true;
		
		return false;
	}
}