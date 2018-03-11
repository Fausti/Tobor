package world.entities.std;

import world.entities.EntityCollectable;

/**
 * ...
 * @author Matthias Faust
 */
class ExclamationMark extends EntityCollectable {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(192, 12));
	}
	
}