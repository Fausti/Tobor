package world.entities.std;

import world.entities.EntityPushable;

/**
 * ...
 * @author Matthias Faust
 */
class Isolator extends EntityPushable {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(240, 0));
	}
}