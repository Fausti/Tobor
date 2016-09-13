package world.entities.core;

import world.entities.Object;

/**
 * ...
 * @author Matthias Faust
 */
class Bank extends Object {

	public function new(?type:Int=0) {
		super(type);
		
		gfx = new Sprite(Tobor.Tileset.find("SPR_BANK"));
	}
	
}