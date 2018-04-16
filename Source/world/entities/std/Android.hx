package world.entities.std;

import world.entities.EntityAI;
import world.entities.interfaces.IEnemy;

/**
 * ...
 * @author Matthias Faust
 */
class Android extends EntityAI implements IEnemy {
	public static var SPEED:Float = 1.5;
	var robotSpeed:Float = 0;
	
	public function new() {
		super();
		
		robotSpeed = SPEED + (Math.random());
		
		sprites[0] = new Animation([
			Gfx.getSprite(208, 252),
			Gfx.getSprite(208 + 16, 252),
			Gfx.getSprite(208 + 32, 252)
		], 0.75);
		
		cast(sprites[0], Animation).start();
	}
	
}