package world.entities.core;

import world.entities.EntityPickup;

/**
 * ...
 * @author Matthias Faust
 */
class Key extends EntityPickup {
	var SPRITES:Array<Sprite>;
	var SPRITES_MONO:Array<Sprite>;
	
	public function new(?type:Int=0) {
		super(type);
		
		SPRITES = [
			new Sprite(Tobor.Tileset.find("SPR_SCHLUESSEL_0")),
			new Sprite(Tobor.Tileset.find("SPR_SCHLUESSEL_1")),
			new Sprite(Tobor.Tileset.find("SPR_SCHLUESSEL_2")),
			new Sprite(Tobor.Tileset.find("SPR_SCHLUESSEL_3")),
			new Sprite(Tobor.Tileset.find("SPR_SCHLUESSEL_4")),
			new Sprite(Tobor.Tileset.find("SPR_SCHLUESSEL_5")),
			new Sprite(Tobor.Tileset.find("SPR_SCHLUESSEL_6")),
			new Sprite(Tobor.Tileset.find("SPR_SCHLUESSEL_7")),
			new Sprite(Tobor.Tileset.find("SPR_SCHLUESSEL_8")),
			new Sprite(Tobor.Tileset.find("SPR_SCHLUESSEL_9")),
			new Sprite(Tobor.Tileset.find("SPR_SCHLUESSEL_10")),
			new Sprite(Tobor.Tileset.find("SPR_SCHLUESSEL_11")),
			new Sprite(Tobor.Tileset.find("SPR_SCHLUESSEL_12")),
			new Sprite(Tobor.Tileset.find("SPR_SCHLUESSEL_13")),
			new Sprite(Tobor.Tileset.find("SPR_SCHLUESSEL_14")),
		];
		
		SPRITES_MONO = [
			new Sprite(Tobor.Tileset.find("SPR_SCHLUESSEL_MONO_0")),
			new Sprite(Tobor.Tileset.find("SPR_SCHLUESSEL_MONO_1")),
			new Sprite(Tobor.Tileset.find("SPR_SCHLUESSEL_MONO_2")),
			new Sprite(Tobor.Tileset.find("SPR_SCHLUESSEL_MONO_3")),
			new Sprite(Tobor.Tileset.find("SPR_SCHLUESSEL_MONO_4")),
			new Sprite(Tobor.Tileset.find("SPR_SCHLUESSEL_MONO_5")),
			new Sprite(Tobor.Tileset.find("SPR_SCHLUESSEL_MONO_6")),
			new Sprite(Tobor.Tileset.find("SPR_SCHLUESSEL_MONO_7")),
			new Sprite(Tobor.Tileset.find("SPR_SCHLUESSEL_MONO_8")),
			new Sprite(Tobor.Tileset.find("SPR_SCHLUESSEL_MONO_9")),
			new Sprite(Tobor.Tileset.find("SPR_SCHLUESSEL_MONO_10")),
			new Sprite(Tobor.Tileset.find("SPR_SCHLUESSEL_MONO_11")),
			new Sprite(Tobor.Tileset.find("SPR_SCHLUESSEL_MONO_12")),
			new Sprite(Tobor.Tileset.find("SPR_SCHLUESSEL_MONO_13")),
			new Sprite(Tobor.Tileset.find("SPR_SCHLUESSEL_MONO_14")),
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