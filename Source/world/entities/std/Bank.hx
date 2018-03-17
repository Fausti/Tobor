package world.entities.std;

import world.entities.EntityStatic;

/**
 * ...
 * @author Matthias Faust
 */
class Bank extends EntityStatic {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(48, 12));
	}
	
}