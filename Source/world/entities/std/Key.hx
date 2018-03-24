package world.entities.std;

import world.entities.EntityItem;

/**
 * ...
 * @author Matthias Faust
 */
class Key extends EntityItem {

	public function new() {
		super();
	}
	
	override public function init() {
		var spr:Sprite = null;
		
		spr = Gfx.getSprite(type * 16, 48);
		
		if (spr != null) {
			setSprite(spr);
		}
	}
	
	override public function onPickup() {
		addToInventory();
		
		Sound.play(Sound.SND_PICKUP_KEY);
	}
}