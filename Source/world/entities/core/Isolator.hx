package world.entities.core;

import gfx.Sprite;

/**
 * ...
 * @author Matthias Faust
 */
class Isolator extends EntityPushable {

	public function new() {
		super();
		
		gfx = new Sprite(Tobor.Tileset.find("SPR_ISOLATOR"));
	}
	
}