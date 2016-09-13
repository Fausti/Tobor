package world.entities.core;

import gfx.Sprite;
import gfx.Color;
import world.entities.Object;

/**
 * ...
 * @author Matthias Faust
 */
class Door extends Object {
	var SPRITES:Array<Sprite>;
	var SPRITES_MONO:Array<Sprite>;
	
	var SPRITE_0:Sprite;
	var SPRITE_1:Sprite;
	var SPRITE_2:Sprite;
	var COLORS_0:Array<Color>;
	var COLORS_1:Array<Color>;
	
	public function new(?type:Int=0) {
		super(type);
		
		SPRITE_0 = new Sprite(Tobor.Tileset.find("SPR_TUER_MASK_0"));
		SPRITE_1 = new Sprite(Tobor.Tileset.find("SPR_TUER_MASK_1"));
		SPRITE_2 = new Sprite(Tobor.Tileset.find("SPR_TUER_MASK_2"));
		
		COLORS_0 = [
			Color.YELLOW,
			Color.DARK_GREEN,
			Color.GRAY,
			Color.PURPLE,
			Color.DARK_RED,
			Color.RED,
			Color.ORANGE,
			Color.GREEN,
			Color.LIGHT_GREEN,
			Color.LIGHT_BLUE,
			Color.BLUE,
			Color.BLUE2,
			Color.DARK_BLUE,
			Color.BROWN,
			Color.BLACK
		];
		
		COLORS_1 = [
			Color.DARK_GREEN,
			Color.YELLOW,
			
			Color.WHITE,
			Color.ORANGE,
			
			Color.RED,
			Color.DARK_RED,
			
			Color.PURPLE,
			Color.BLUE,
			
			Color.LIGHT_BLUE,
			Color.LIGHT_GREEN,
			
			Color.BLACK,
			Color.BROWN,
			
			Color.DARK_BLUE,
			Color.BROWN,
			Color.BLACK
		];
		
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
	
	override
	public function draw() {
		if (gfx == null) return;
		
		if (Tobor.MONO_MODE) {
			Gfx.drawTexture(x, y, 16, 12, gfx.getUV());
		} else {
			Gfx.drawTexture(x, y, 16, 12, SPRITE_0.getUV());
			Gfx.drawTexture(x, y, 16, 12, SPRITE_1.getUV(), COLORS_0[type]);
			Gfx.drawTexture(x, y, 16, 12, SPRITE_2.getUV(), COLORS_1[type]);
		}
	}
}