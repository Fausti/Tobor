package world.entities.std;

import world.entities.EntityItem;

/**
 * ...
 * @author Matthias Faust
 */
class Tree extends EntityItem {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(80, 24));
	}
	
	override public function onUse(item:InventoryItem, x:Float, y:Float) {
		room.addTreeTimer(30);
		removeFromInventory();
	}
}