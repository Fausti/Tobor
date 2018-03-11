package world.entities.std;

import world.entities.EntityCollectable;

/**
 * ...
 * @author Matthias Faust
 */
class Clock extends EntityCollectable {

	public function new() {
		super();
		
		sprites.push(Gfx.getSprite(176, 12));
	}
	
}