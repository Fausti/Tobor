package world.entities.std;

import world.entities.EntityDynamic;
import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class SandWallDissolve extends EntityDynamic {
	var timeLeft:Float = 5.0;
	
	public function new() {
		super();
		
		var anim = new Animation([
			Gfx.getSprite(64, 168),
			Gfx.getSprite(64 + 16, 168),
			Gfx.getSprite(64 + 32, 168),
			Gfx.getSprite(64 + 48, 168),
			Gfx.getSprite(64 + 64, 168)
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