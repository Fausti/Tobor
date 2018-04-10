package world.entities.std;

import world.entities.EntityItem;

/**
 * ...
 * @author Matthias Faust
 */
class Acid extends EntityItem {

	public function new() {
		super();
	}
	
	override public function init() {
		super.init();
		
		setSprite(Gfx.getSprite(208, 24));
	}
	
	override public function onUse(item:InventoryItem, x:Float, y:Float) {
		var list = room.findEntityAround(x, y, Wall);
		var count:Int = 0;

		for (e in list) {
			if (e.type == 0) {
				room.spawnEntity(e.x, e.y, new WallDissolve());
				e.die();
				count++;
			}
		}
		
		if (count > 0) {
			Sound.play(Sound.SND_DISSOLVE_WALL);
			if (getWorld().checkFirstUse("USED_ACID")) {
				removeFromInventory();
			} else {
				getWorld().markFirstUse("USED_ACID");
				getWorld().showPickupMessage("OBJ_ACID_USE", false, function () {
					getWorld().addPoints(1500);
					removeFromInventory();
					getWorld().hideDialog();
				}, 1500);
			}
		}
	}
}