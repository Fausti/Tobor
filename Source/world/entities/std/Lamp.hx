package world.entities.std;

import world.entities.EntityItem;

/**
 * ...
 * @author Matthias Faust
 */
class Lamp extends EntityItem {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(144, 132));
	}
	
}