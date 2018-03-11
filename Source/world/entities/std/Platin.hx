package world.entities.std;

import world.entities.EntityCollectable;

/**
 * ...
 * @author Matthias Faust
 */
class Platin extends EntityCollectable {

	public function new() {
		super();
		
		sprites.push(Gfx.getSprite(128, 12));
	}
	
}