package world.entities.std;

import world.entities.EntityItem;

/**
 * ...
 * @author Matthias Faust
 */
class ExclamationMark extends EntityItem {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(192, 12));
	}
	
}