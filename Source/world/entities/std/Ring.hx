package world.entities.std;

import world.entities.EntityItem;

/**
 * ...
 * @author Matthias Faust
 */
class Ring extends EntityItem {
	var SPR_RING:Array<Sprite> = [];
	
	public function new() {
		super();
			
		SPR_RING = [
			Gfx.getSprite(0, 276),
			Gfx.getSprite(16, 276),
			Gfx.getSprite(32, 276),
			Gfx.getSprite(48, 276),
		];
	}
	
	override public function render() {
		Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_RING[type]);
	}
}