package world.entities.std;

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
		room.world.points++;
		Sound.play(Sound.SND_PICKUP_GOLD);
	}
}