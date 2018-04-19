package world.entities.std;

import world.InventoryItem;
import world.entities.EntityItem;

/**
 * ...
 * @author Matthias Faust
 */
class Food extends EntityItem {
	var SPR_FOOD:Array<Sprite>;
	
	public function new() {
		super();
	
		SPR_FOOD = [
			Gfx.getSprite(192, 252),
			Gfx.getSprite(192 + 16, 252)
		];
	}
	
	override public function render() {
		Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_FOOD[type]);
	}
	
	override public function onUse(item:InventoryItem, x:Float, y:Float) {
		getWorld().food = getWorld().food + 60;
		removeFromInventory();
	}
}