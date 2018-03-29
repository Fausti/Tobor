package world.entities.std;

import world.entities.EntityItem;

/**
 * ...
 * @author Matthias Faust
 */
class Elexir extends EntityItem {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(224, 24));
	}
	
	override public function onUse(item:InventoryItem, x:Float, y:Float) {
		if (room.world.lives < 3) {
			room.world.lives++;
			
			removeFromInventory();
		}
	}
}