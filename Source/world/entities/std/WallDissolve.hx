package world.entities.std;

import lime.math.Vector2;
import world.entities.Entity;
import world.entities.EntityDynamic;

/**
 * ...
 * @author Matthias Faust
 */
class WallDissolve extends EntityDynamic {
	var timeLeft:Float = 5.0;
	
	public function new() {
		super();
		
		var anim = new Animation([
			Gfx.getSprite(0, 60),
			Gfx.getSprite(16, 60),
			Gfx.getSprite(32, 60),
			Gfx.getSprite(48, 60),
			Gfx.getSprite(64, 60)
		], timeLeft);
		
		anim.onAnimationEnd = function () {
			die();
		}
		
		setSprite(anim);
		
		anim.start();
	}
	
	override public function update(deltaTime:Float) {
		super.update(deltaTime);
		
		timeLeft = timeLeft - deltaTime;
		if (timeLeft < 0) die();
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		return false;
	}
}