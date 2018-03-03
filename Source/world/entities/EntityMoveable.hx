package world.entities;

import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */

typedef MoveData = {
	var twoPhases:Bool;
	
	var distanceLeft:Float;
	var distanceRest:Float;
	
	var direction:Vector2;
	var speedMovement:Float; // Tiles per second
}

class EntityMoveable extends EntityDynamic {
	var moveData:MoveData;
	
	public function new() {
		super();
		
		moveData = {
			direction: Direction.NONE,
			speedMovement:0.0,
			distanceLeft: 0.0,
			distanceRest: 0.0,
			
			twoPhases: false,
		}
	}
	
	override public function update_begin(deltaTime:Float) {
		moveData.distanceRest = 0.0;
		
		if (isMoving()) {
			processMovement(deltaTime);
		}
	}
	
	override public function update_end(deltaTime:Float) {
		if (isMoving() && (moveData.distanceRest > 0.0)) {
			processMovement(deltaTime);
		}
		
		update(deltaTime);
	}
	
	public function isMoving():Bool {
		if (moveData.direction != Direction.NONE) {
			return true;
		} else {
			return false;
		}
	}
	
	public function move(direction:Vector2, speed:Float):Bool {
		if (direction == Direction.NONE) return false;
		
		if (!isMoving()) {
			if (isOutsideMap(x + direction.x, y + direction.y)) return false;
			
			var atTarget:Array<Entity> = room.getEntitiesAt(x + direction.x, y + direction.y);
			
			for (e in atTarget) {
				if (!e.canEnter(this, direction, speed)) return false;
			}
			
			// dann bewegen wir uns mal...
			moveData.direction = direction;
			moveData.speedMovement = speed;
			moveData.distanceLeft = 1.0;
			
			onStartMoving();
			
			return true;
		}
		
		return false;
	}
	
	function processMovement(deltaTime:Float) {
		var distance:Float = 0;

		if (moveData.distanceRest == 0.0) {
			distance = deltaTime * moveData.speedMovement;
		} else {
			distance = moveData.distanceRest;
			moveData.distanceRest = 0.0;
		}
		
		// auf 3 Stellen nach dem Komma runden
		// distance = Utils.fixedFloat(distance, 3);
		
		if (distance > moveData.distanceLeft) {
			distance = moveData.distanceLeft;
			
			if (moveData.twoPhases) {
				moveData.distanceRest = moveData.distanceLeft;
			} else {
				moveData.distanceRest = 0.0;
			}
			
			moveData.distanceLeft = 0.0;
		} else {
			moveData.distanceRest = 0.0;
			moveData.distanceLeft -= distance;
		}
		
		x += (moveData.direction.x * distance);
		y += (moveData.direction.y * distance);
		
		if (moveData.distanceLeft == 0.0) {
			moveData.direction = Direction.NONE;
			
			x = Math.fround(x);
			y = Math.fround(y);
			
			onStopMoving();
		}
	}
	
	function onStartMoving() {
		
	}
	
	function onStopMoving() {
		// trace("" + this + ": " + moveData);
	}
}