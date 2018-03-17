package world.entities.std;

import world.entities.EntityItem;

/**
 * ...
 * @author Matthias Faust
 */
class Clock extends EntityItem {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(176, 12));
	}
	
}