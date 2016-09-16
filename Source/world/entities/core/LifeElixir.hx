package world.entities.core;

import world.entities.ObjectItem;

/**
 * ...
 * @author Matthias Faust
 */
class LifeElixir extends ObjectItem {

	public function new(?type:Int=0) {
		super(type);
		
		gfx = new Sprite(Tobor.Tileset.find("SPR_LEBEN"));
	}
	
}