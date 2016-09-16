package world.entities.core;

import world.entities.ObjectItem;

/**
 * ...
 * @author Matthias Faust
 */
class Garlic extends ObjectItem {

	public function new(?type:Int=0) {
		super(type);
		
		gfx = new Sprite(Tobor.Tileset.find("SPR_KNOBLAUCH"));
	}
	
}