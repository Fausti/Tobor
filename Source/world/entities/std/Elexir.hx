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
			
			if (getWorld().checkFirstUse("USED_ELEXIR")) {
					
			} else {
				getWorld().markFirstUse("USED_ELEXIR");
				getWorld().showPickupMessage("OBJ_ELEXIR_USE", false, function () {
					getWorld().addPoints(4500);
					getWorld().hideDialog();
				}, 4500);
			}
		}
	}
}