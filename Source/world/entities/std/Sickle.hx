package world.entities.std;

import world.entities.EntityItem;

/**
 * ...
 * @author Matthias Faust
 */
class Sickle extends EntityItem {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(240, 228));
	}
	
}