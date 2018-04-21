package world.entities.std;

import world.entities.EntityItem;

/**
 * ...
 * @author Matthias Faust
 */
class Lamp extends EntityItem {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(144, 132));
	}
	
	override public function render() {
		getWorld().game.addLight(x + 0.5, y + 0.5, 3);
		
		super.render();
	}
	
	override public function onUse(item:InventoryItem, x:Float, y:Float) {
		var list = room.findEntityAround(x, y, Torch);
		var count:Int = 0;

		for (e in list) {
			e.type = 1;
			count++;
		}
		
		if (count > 0) {
			// Sound.play(Sound.SND_DISSOLVE_WALL);
			if (getWorld().checkFirstUse("USED_LAMP")) {
				
			} else {
				getWorld().markFirstUse("USED_LAMP");
				getWorld().showPickupMessage("USED_LAMP", false, function () {
					getWorld().addPoints(1500);
					getWorld().hideDialog();
				}, 1500);
			}
		}
	}
}