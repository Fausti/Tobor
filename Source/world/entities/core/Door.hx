package world.entities.core;

import world.entities.Entity;

/**
 * ...
 * @author Matthias Faust
 */
class Door extends Entity {
	var SPRITES:Array<Sprite>;
	var SPRITES_MONO:Array<Sprite>;
	
	public function new(?type:Int=0) {
		super(type);
		
		SPRITES = [
			new Sprite(Tobor.Tileset.find("SPR_TUER_0")),
			new Sprite(Tobor.Tileset.find("SPR_TUER_1")),
			new Sprite(Tobor.Tileset.find("SPR_TUER_2")),
			new Sprite(Tobor.Tileset.find("SPR_TUER_3")),
			new Sprite(Tobor.Tileset.find("SPR_TUER_4")),
			new Sprite(Tobor.Tileset.find("SPR_TUER_5")),
			new Sprite(Tobor.Tileset.find("SPR_TUER_6")),
			new Sprite(Tobor.Tileset.find("SPR_TUER_7")),
			new Sprite(Tobor.Tileset.find("SPR_TUER_8")),
			new Sprite(Tobor.Tileset.find("SPR_TUER_9")),
			new Sprite(Tobor.Tileset.find("SPR_TUER_10")),
			new Sprite(Tobor.Tileset.find("SPR_TUER_11")),
			new Sprite(Tobor.Tileset.find("SPR_TUER_12")),
			new Sprite(Tobor.Tileset.find("SPR_TUER_13")),
			new Sprite(Tobor.Tileset.find("SPR_TUER_14")),
		];
		
		SPRITES_MONO = [
			new Sprite(Tobor.Tileset.find("SPR_TUER_MONO_0")),
			new Sprite(Tobor.Tileset.find("SPR_TUER_MONO_1")),
			new Sprite(Tobor.Tileset.find("SPR_TUER_MONO_2")),
			new Sprite(Tobor.Tileset.find("SPR_TUER_MONO_3")),
			new Sprite(Tobor.Tileset.find("SPR_TUER_MONO_4")),
			new Sprite(Tobor.Tileset.find("SPR_TUER_MONO_5")),
			new Sprite(Tobor.Tileset.find("SPR_TUER_MONO_6")),
			new Sprite(Tobor.Tileset.find("SPR_TUER_MONO_7")),
			new Sprite(Tobor.Tileset.find("SPR_TUER_MONO_8")),
			new Sprite(Tobor.Tileset.find("SPR_TUER_MONO_9")),
			new Sprite(Tobor.Tileset.find("SPR_TUER_MONO_10")),
			new Sprite(Tobor.Tileset.find("SPR_TUER_MONO_11")),
			new Sprite(Tobor.Tileset.find("SPR_TUER_MONO_12")),
			new Sprite(Tobor.Tileset.find("SPR_TUER_MONO_13")),
			new Sprite(Tobor.Tileset.find("SPR_TUER_MONO_14")),
		];
		
		updateSprite();
	}
	
	function updateSprite() {
		if (Tobor.MONO_MODE) {
			gfx = SPRITES_MONO[type];
		} else {
			gfx = SPRITES[type];
		}
	}
}