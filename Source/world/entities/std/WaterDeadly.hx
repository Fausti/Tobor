package world.entities.std;

import lime.math.Vector2;
/**
 * ...
 * @author Matthias Faust
 */
class WaterDeadly extends EntityDynamic {
	var ANIM_WATER:Animation;
	
	public function new() {
		super();
		
		initSprites();
	}
	
	function initSprites() {
		if (ANIM_WATER == null) {
			ANIM_WATER = new Animation([
				Gfx.getSprite(16, 72),
				Gfx.getSprite(32, 72),
				Gfx.getSprite(48, 72),
				Gfx.getSprite(64, 72),
			], 2.0);
		
			ANIM_WATER.onAnimationEnd = function () {
				ANIM_WATER.start(true);
			}
		
			ANIM_WATER.start(true);
		}
		
		setSprite(ANIM_WATER);
	}
	
	override public function init() {
		super.init();
		
		initSprites();
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		return Std.is(e, Charlie);
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		if (Std.is(e, Charlie) && e.visible) {
			e.die();
		}
	}
}