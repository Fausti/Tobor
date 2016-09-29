package world.entities;

import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class ObjectMoveable extends ObjectDynamic {

	// Bewegung
	var direction:Vector2 = new Vector2();
	var movement:Vector2 = new Vector2();
	var speed:Float = 1 / 4;
	var timeLeft:Float = 0.0;
	var friction:Float = 1.0;
	
	public function new(?type:Int = 0) {
		super(type);
		
		isStatic = false;
	}
	
	override public function update(deltaTime:Float) {
		super.update(deltaTime);
		
		if (isMoving) {
			if (timeLeft < deltaTime) timeLeft = deltaTime;
			timeLeft -= deltaTime;
			
			// trace("M: " + timeLeft, deltaTime);
			
			var perc:Float = Utils.clamp((getMovingSpeed() - timeLeft) / getMovingSpeed(), 0.0, 1.0);
			
			movement.x = perc * Tobor.OBJECT_WIDTH * direction.x;
			movement.y = perc * Tobor.OBJECT_HEIGHT * direction.y;
			
			if (timeLeft <= 0.0) {
				timeLeft = 0.0;
				
				movement.setTo(0, 0);
				
				position.x = Std.int((gridX + direction.x) * Tobor.OBJECT_WIDTH);
				position.y = Std.int((gridY + direction.y) * Tobor.OBJECT_HEIGHT);
				
				direction.setTo(0.0, 0.0);
				
				for (e in room.getEntitiesAt(gridX, gridY, this)) {
					e.onEnter(this);
				}
				
				onStopMoving();
			}
			
			changed = true;
		}
	}
	
	function onStartMoving() {
		
	}
	
	function onStopMoving() {
		
	}
	
	function getMovingSpeed():Float {
		return speed * friction;
	}
	
	public var isMoving(get, null):Bool;
	function get_isMoving():Bool {
		return (direction.x != 0.0 || direction.y != 0.0);
	}
	
	public function move(dirX:Int, dirY:Int) {
		if (!isAlive) return;
		if (isMoving) return;
		if (dirX == 0 && dirY == 0) return;
		
		var canMove:Bool = true;
		friction = 1.0;
		
		if (room.outOfRoom(gridX + dirX, gridY + dirY)) {
			canMove = false;
		} else {
			/*
			for (e in room.getEntitiesAt(gridX, gridY, this)) {
				friction = Math.max(friction, e.getFriction());
			}
			*/
			
			for (e in room.getEntitiesAt(gridX + dirX, gridY + dirY, this)) {
				friction = Math.max(friction, e.getFriction());
				if (!e.canEnter(this)) canMove = false;
			}
		}
		
		if (canMove) {
			direction.x = dirX;
			direction.y = dirY;
			
			timeLeft = getMovingSpeed();
			
			onStartMoving();
		}
	}
	
	override
	function get_x():Float {
		return position.x + movement.x;
	}
	
	override
	function set_x(v:Float):Float {
		if (v != position.x) {
			position.x = v;
			changed = true;
		}
		
		return v;
	}
	
	override
	function get_y():Float {
		return position.y + movement.y;
	}
	
	override
	function set_y(v:Float):Float {
		if (v != position.y) {
			position.y = v;
			changed = true;
		}
		
		return v;
	}
	
	override function set_gridX(v:Int):Int {
		changed = true;
		return super.set_gridX(v);
	}
	
	override function set_gridY(v:Int):Int {
		changed = true;
		return super.set_gridY(v);
	}
}