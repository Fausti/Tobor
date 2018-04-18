package world.entities.std;

import world.entities.EntityItem;

/**
 * ...
 * @author Matthias Faust
 */
class Knife extends EntityItem {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(48, 168));
	}
	
}