package world.entities.std;

import world.InventoryItem;
import world.entities.EntityItem;

/**
 * ...
 * @author Matthias Faust
 */
class Shovel extends EntityItem {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(192, 132));
	}

	override public function onUse(item:InventoryItem, x:Float, y:Float) {
		var atPosition = room.findEntityAt(getPlayer().x, getPlayer().y, Spot);
		var diggedUp:Int = 0;
		
		if (atPosition.length > 0) {
			for (e in atPosition) {
				if (e.content != null) {
					var unpacked:Entity = getFactory().create(e.content);
			
					if (unpacked != null) {
						room.spawnEntity(x, y, unpacked);
					}
					
					diggedUp++;
				}
				
				e.die();
			}
		}
		
		if (diggedUp > 0) {
			if (!getWorld().checkFirstUse("USED_SHOVEL")) {
				getWorld().markFirstUse("USED_SHOVEL");
				getWorld().showPickupMessage("USED_SHOVEL", false, function () {
					getWorld().addPoints(1500);
					getWorld().hideDialog();
				}, 1500);
			}
		}
	}
}