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
	
	
	override public function canEnter(e:Entity):Bool {
		if (Std.is(e, Charlie)) {
			return true;
		} else if (Std.is(e, EntityAI)) {
			return true;
		}
		
		return super.canEnter(e);
	}
	
	override public function onEnter(e:Entity) {
		if (Std.is(e, Charlie) || Std.is(e, EntityAI)) {
			destroy();
			e.die();
		}
		
		super.onEnter(e);
	}
}