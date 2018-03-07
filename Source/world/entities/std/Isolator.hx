package world.entities.std;

import lime.math.Vector2;

import world.entities.EntityPushable;

/**
 * ...
 * @author Matthias Faust
 */
class Isolator extends EntityPushable {

	public function new() {
		super();
		
		sprites.push(Gfx.getSprite(240, 0));
	}
}