package world.entities.std;

import world.entities.EntityItem;

/**
 * ...
 * @author Matthias Faust
 */
class Garlic extends EntityItem {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(192, 24));
	}
	
	override public function onUse(item:InventoryItem, x:Float, y:Float) {
		room.world.garlic = room.world.garlic + 60;
		
		removeFromInventory();
	}
}