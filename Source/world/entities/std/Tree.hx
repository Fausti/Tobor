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
		room.addTreeTimer(15);
		removeFromInventory();
		
		if (!getWorld().checkFirstUse("USED_TREE")) {
			getWorld().markFirstUse("USED_TREE");
			getWorld().showPickupMessage("USED_TREE", false, function () {
				getWorld().addPoints(3000);
				getWorld().hideDialog();
			}, 3000);
		}
	}
}