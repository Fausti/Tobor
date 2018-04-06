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
		var arr:Array<Sprite> = [];
		
		for (i in 0 ... Std.random(4) + 1) {
			arr.push(Gfx.getSprite(16, 72));
		}
		
		arr.push(Gfx.getSprite(32, 72));
		arr.push(Gfx.getSprite(48, 72));
		arr.push(Gfx.getSprite(64, 72));
				
		
		if (ANIM_WATER == null) {
			ANIM_WATER = new Animation(arr, 2.0 + Math.random() * 2);
		
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