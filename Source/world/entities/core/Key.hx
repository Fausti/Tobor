package world.entities.core;

import gfx.Sprite;
import gfx.Color;
import world.Room;
import world.entities.Inventory.InventoryItem;
import world.entities.ObjectItem;

/**
 * ...
 * @author Matthias Faust
 */
class Key extends ObjectItem {
	var SPRITES:Array<Sprite>;
	var SPRITES_MONO:Array<Sprite>;
	
	var SPRITE_0:Sprite;
	var SPRITE_1:Sprite;
	var COLORS:Array<Color>;
	
	public function new(?type:Int=0) {
		super(type);
		
		SPRITE_0 = new Sprite(Tobor.Tileset.find("SPR_SCHLUESSEL_MASK_0"));
		SPRITE_1 = new Sprite(Tobor.Tileset.find("SPR_SCHLUESSEL_MASK_1"));
		
		COLORS = [
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
	
	override
	public function draw() {
		if (gfx == null) return;
		
		if (Tobor.MONO_MODE) {
			Gfx.drawTexture(x, y, 16, 12, gfx.getUV());
		} else {
			Gfx.drawTexture(x, y, 16, 12, SPRITE_0.getUV());
			Gfx.drawTexture(x, y, 16, 12, SPRITE_1.getUV(), COLORS[type]);
		}
	}
	
	function updateSprite() {
		if (Tobor.MONO_MODE) {
			gfx = SPRITES_MONO[type];
		} else {
			gfx = SPRITES[type];
		}
	}
	
	override public function onUse(item:InventoryItem, inRoom:Room) {
		onDrop(item, inRoom);
	}
}