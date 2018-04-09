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
		
		Sound.play(Sound.SND_USE_GARLIC);
		
		if (getWorld().checkFirstUse("USED_GARLIC")) {
			removeFromInventory();
		} else {
			getWorld().markFirstUse("USED_GARLIC");
			getWorld().showPickupMessage("OBJ_GARLIC_USE", false, function () {
				getWorld().addPoints(1000);
				removeFromInventory();
				getWorld().hideDialog();
			}, 1000);
		}
	}
}