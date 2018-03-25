package world.entities.std;

import world.entities.EntityStatic;

/**
 * ...
 * @author Matthias Faust
 */
class Grate extends EntityStatic {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(240, 84));
	}
	
}