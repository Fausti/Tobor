package world.entities.std;

import gfx.Animation;
import gfx.Sprite;
import world.entities.EntityMoveable;

/**
 * ...
 * @author Matthias Faust
 */
class Charlie extends EntityMoveable {
	var sprStanding:Sprite;
	var sprWalking:Animation;
	
	public function new() {
		super();
		
		sprStanding = Gfx.getSprite(16, 0);
		
		sprWalking = new Animation([
			Gfx.getSprite(32, 0),
			Gfx.getSprite(48, 0)
		], 0.5);
			
		sprites[0] = sprStanding;
	}
	
	override function onStartMoving() {
		sprites[0] = sprWalking;
		sprWalking.start(false);
	}
	
	override function onStopMoving() {
		sprites[0] = sprStanding;
		sprWalking.stop();
	}
}