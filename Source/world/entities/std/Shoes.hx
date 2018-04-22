package world.entities.std;

import world.entities.EntityItem;

/**
 * ...
 * @author Matthias Faust
 */
class Shoes extends EntityItem {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(112, 144));
	}
	
	override public function onPickup() {
		if (addToInventory()) {
			Sound.play(Sound.SND_JINGLE_1);
		} else {
			Sound.play(Sound.SND_PICKUP_MISC);
		}
	}
	
}