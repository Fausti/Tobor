package world.entities.core;

import world.entities.Entity;
import world.entities.EntityPushable;

/**
 * ...
 * @author Matthias Faust
 */
class Elektrozaun extends EntityPushable {

	public function new() {
		super();
		
		gfx = new Sprite(Tobor.Tileset.find("SPR_ELEKTROZAUN"));
	}
	
	
	override public function isSolid(e:Entity):Bool {
		if (Std.is(e, Charlie)) {
			return false;
		} else if (Std.is(e, EntityAI)) {
			return false;
		}
		
		return super.isSolid(e);
	}
}