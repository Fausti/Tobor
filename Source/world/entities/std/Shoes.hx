package world.entities.std;

import world.entities.EntityItem;

/**
 * ...
 * @author Matthias Faust
 */
class Shoes extends EntityItem {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(112, 144));
	}
	
}