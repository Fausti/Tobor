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
	
}