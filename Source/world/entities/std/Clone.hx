package world.entities.std;

import world.entities.EntityItem;

/**
 * ...
 * @author Matthias Faust
 */
class Clone extends EntityItem {

	public function new() {
		super();
		setSprite(Gfx.getSprite(128, 60));
	}
	
}