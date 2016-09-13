package world.entities.core;

import world.entities.ObjectPickup;

/**
 * ...
 * @author Matthias Faust
 */
class AcidFlask extends ObjectPickup {

	public function new(?type:Int=0) {
		super(type);
		
		gfx = new Sprite(Tobor.Tileset.find("SPR_SAEURE_FLASCHE"));
	}
	
}