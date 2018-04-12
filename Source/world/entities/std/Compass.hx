package world.entities.std;

import world.entities.EntityItem;

/**
 * ...
 * @author Matthias Faust
 */
class Compass extends EntityItem {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(176, 252));
	}
	
}