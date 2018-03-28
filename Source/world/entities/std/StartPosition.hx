package world.entities.std;

import world.entities.Entity;

/**
 * ...
 * @author Matthias Faust
 */
class StartPosition extends Entity {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(128, 156));
	}
	
	override public function onGameStart() {
		if (!getWorld().editing) room.removeEntity(this);
	}
}