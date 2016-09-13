package world.entities.core;

import world.entities.ObjectPickup;

/**
 * ...
 * @author Matthias Faust
 */
class Magnet extends ObjectPickup {
	var SPRITES:Array<Sprite>;
	
	public function new(?type:Int=0) {
		super(type);
		
		SPRITES = [
			new Sprite(Tobor.Tileset.find("SPR_MAGNET_0")),
			new Sprite(Tobor.Tileset.find("SPR_MAGNET_1"))
		];
		
		updateSprite();
	}
	
	function updateSprite() {
		gfx = SPRITES[type];
	}
}