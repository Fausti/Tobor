package world.entities.std;

import world.entities.EntityDynamic;

/**
 * ...
 * @author Matthias Faust
 */
class Explosion extends EntityDynamic {
	var SPR_EXPLOSION:Animation;
	
	public function new() {
		super();
	}
	
	override public function init() {
		SPR_EXPLOSION = new Animation([
			Gfx.getSprite(64, 0),
			Gfx.getSprite(64 + 16 * 1, 0),
			Gfx.getSprite(64 + 16 * 2, 0),
			Gfx.getSprite(64 + 16 * 3, 0),
			Gfx.getSprite(64 + 16 * 4, 0),
			Gfx.getSprite(64 + 16 * 5, 0),
		], 5);
		
		SPR_EXPLOSION.onAnimationEnd = function() {
			die();
		};
		
		sprites[0] = SPR_EXPLOSION;
		SPR_EXPLOSION.start();
	}
}