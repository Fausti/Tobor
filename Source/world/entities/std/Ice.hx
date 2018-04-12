package world.entities.std;

import lime.math.Vector2;
import world.ObjectFactory.ObjectTemplate;
import world.entities.Entity;
import world.entities.EntityFloor;
import world.entities.EntityMoveable;
import world.entities.EntityStatic;

/**
 * ...
 * @author Matthias Faust
 */
class Ice extends EntityFloor {
	var SPR_ICE:Array<Sprite>;
	
	public function new() {
		super();
		
		initSprites();
	}
	
	function initSprites() {
		if (SPR_ICE == null) {
			SPR_ICE = [];
			
			for (i in 0 ... 5) {
				SPR_ICE.push(Gfx.getSprite(64 + i * 16, 324));
			}
		}
		
		setSprite(SPR_ICE[type]);
	}
	
	override public function init() {
		super.init();
		
		initSprites();
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (Std.is(e, Charlie) || Std.is(e, Robot)) {
			var canMove:Bool = true;
			var onMe = room.getAllEntitiesAt(x, y, this);
			
			for (ee in onMe) {
				if (ee.isMoving()) canMove = false;
			}
			
			return canMove;
		}
		
		return false;
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		if (Std.is(e, Charlie) || Std.is(e, Robot)) {
			var m:EntityMoveable = cast e;
			var canMove:Bool = false;

			var spd:Float = 0;
			if (Std.is(e, Charlie)) {
				spd = Charlie.PLAYER_SPEED;
			} else if (Std.is(e, Robot)) {
				spd = Robot.SPEED;
			}
			
			if (direction != null) canMove = m.move(direction, spd / 2);
		}
	}
}