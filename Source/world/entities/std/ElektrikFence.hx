package world.entities.std;

import world.entities.EntityPushable;

/**
 * ...
 * @author Matthias Faust
 */
class ElektrikFence extends EntityPushable {

	public function new() {
		super();
		
		sprites.push(Gfx.getSprite(64, 12));
	}
	
}