package world.entities.std;

import world.entities.EntityStatic;
import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class Goal extends EntityStatic {
	static var SPR_GOAL:Array<Sprite>;
	
	public function new() {
		super();
		
		initSprites();
	}
	
	function initSprites() {
		if (SPR_GOAL == null) {
			SPR_GOAL = [];
			
			for (iy in 0 ... 2) {
				for (ix in 0 ... 3) {
					SPR_GOAL.push(Gfx.getSprite(160 + ix * 16, 216 + iy * 12));
				}
			}
		}
		
		setSprite(SPR_GOAL[type]);
	}
	
	override public function init() {
		super.init();
		initSprites();
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (Std.is(e, Charlie)) return true;
		
		return super.canEnter(e, direction, speed);
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		if (Std.is(e, Charlie)) {
			getWorld().episodeWon = true;
		}
	}
}