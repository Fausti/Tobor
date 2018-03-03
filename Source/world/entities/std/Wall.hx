package world.entities.std;

import gfx.Gfx;
import gfx.Sprite;
import world.entities.EntityStatic;

/**
 * ...
 * @author Matthias Faust
 */
class Wall extends EntityStatic {

	public function new() {
		super();
		
		sprites.push(Gfx.getSprite(160, 0));
	}
	
}