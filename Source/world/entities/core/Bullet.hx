package world.entities.core;

import world.entities.ObjectItem;

/**
 * ...
 * @author Matthias Faust
 */
class Bullet extends ObjectItem {
	var SPRITES:Array<Sprite>;
	
	public function new(?type:Int=0) {
		super(type);
		
		SPRITES = [
			new Sprite(Tobor.Tileset.find("SPR_MUNITION_0")),
			new Sprite(Tobor.Tileset.find("SPR_MUNITION_1")),
			new Sprite(Tobor.Tileset.find("SPR_MUNITION_2")),
			new Sprite(Tobor.Tileset.find("SPR_MUNITION_3")),
			new Sprite(Tobor.Tileset.find("SPR_MUNITION_4")),
			new Sprite(Tobor.Tileset.find("SPR_MUNITION_5")),
		];
		
		updateSprite();
	}
	
	function updateSprite() {
		gfx = SPRITES[type];
	}
	
}