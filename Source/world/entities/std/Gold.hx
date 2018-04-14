package world.entities.std;

import lime.math.Vector2;
import world.entities.Entity;
import world.entities.EntityCollectable;

/**
 * ...
 * @author Matthias Faust
 */
class Gold extends EntityCollectable {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(96, 12));
	}
	
	override public function onPickup() {
		room.world.gold++;
		Sound.play(Sound.SND_PICKUP_GOLD);
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		if (getWorld().gold < 150) {
			super.onEnter(e, direction);
		} else {
			if (!getWorld().checkFirstUse("TOO_MUCH_GOLD")) {
				getWorld().markFirstUse("TOO_MUCH_GOLD");
				getWorld().showMessage("TXT_TOO_MUCH_GOLD", false);
			}
		}
	}
}