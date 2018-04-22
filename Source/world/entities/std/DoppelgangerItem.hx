package world.entities.std;

import world.entities.EntityCollectable;

/**
 * ...
 * @author Matthias Faust
 */
class DoppelgangerItem extends EntityCollectable {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(160, 132));
	}
	
	override public function onPickup() {
		var d:Doppelganger = new Doppelganger();
		room.spawnEntity(x, y, d);
		
		super.onPickup();
	}
}