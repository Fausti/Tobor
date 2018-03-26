package world.entities.std;

import world.entities.EntityItem;

/**
 * ...
 * @author Matthias Faust
 */
class Flippers extends EntityItem {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(96, 144));
	}
	
}