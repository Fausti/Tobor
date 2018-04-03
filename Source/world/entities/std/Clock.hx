package world.entities.std;

import world.InventoryItem;
import world.entities.EntityItem;

/**
 * ...
 * @author Matthias Faust
 */
class Clock extends EntityItem {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(176, 12));
	}
	
	override public function onUse(item:InventoryItem, x:Float, y:Float) {
		getWorld().doSaveGame();
		removeFromInventory();
	}
}