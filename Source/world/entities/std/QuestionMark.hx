package world.entities.std;

import world.entities.EntityStatic;

/**
 * ...
 * @author Matthias Faust
 */
class QuestionMark extends EntityStatic {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(144, 12));
	}
	
}