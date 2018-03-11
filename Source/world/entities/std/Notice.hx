package world.entities.std;

import world.entities.EntityCollectable;

/**
 * ...
 * @author Matthias Faust
 */
class Notice extends EntityCollectable {

	public function new() {
		super();
		
		sprites.push(Gfx.getSprite(208, 12));
	}
	
}