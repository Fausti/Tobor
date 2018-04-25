package world.entities.std;

import world.entities.EntityItem;

/**
 * ...
 * @author Matthias Faust
 */
class Key extends EntityItem {
	public static var SPR_KEY:Array<Sprite> = Gfx.getSprites(null, 0, 48, 0, 16);
	
	public function new() {
		super();
	}
	
	override public function render() {
		Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_KEY[type]);
	}
	
	override public function onPickup() {
		if (addToInventory()) {
			Sound.play(Sound.SND_JINGLE_1);
		} else {
			Sound.play(Sound.SND_PICKUP_KEY);
		}
	}
}