package world.entities;

import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */

typedef MoveData = {
	var distanceLeft:Float;
	var direction:Vector2;
	var speedMovement:Float; // Tiles per second
}

class EntityMoveable extends EntityDynamic {
	var wasMoving:Bool = false;
	var moveData:MoveData;
	
	public function new() {
		super();
		
		moveData = {
			direction: Direction.NONE,
			speedMovement:0.0,
			distanceLeft: 0.0,
		}
	}
	
	override public function update(deltaTime:Float) {
		if (!isMoving() && wasMoving) {
			onStopMoving();
			wasMoving = false;
		}
		
		if (isMoving()) {
			processMovement(deltaTime);
			wasMoving = true;
		}
		
		super.update(deltaTime);
	}
	
	override public function isMoving():Bool {
		if (moveData.direction != Direction.NONE) {
			return true;
		} else {
			return false;
		}
	}
	
	public function changeSpeed(spd:Float) {
		moveData.speedMovement = Config.getSpeed(spd);
	}
	
	public function changeDirection(dir:Vector2) {
		moveData.direction = dir;
	}
	
	public function move(direction:Vector2, speed:Float, ?dist:Int = 1):Bool {
		if (direction == Direction.NONE) return false;
		
		if (!isMoving()) {
			if (isOutsideMap(x + direction.x, y + direction.y)) return false;
			
			// Geschwindigkeit anpassen
			speed = Config.getSpeed(speed);
			
			var atTarget:Array<Entity> = room.getCollisionsAt(gridX + direction.x, gridY + direction.y);
			
			// kann Feld betreten werden?
			if (dist == 1) { // Tunnel ignorieren dies hier...
				for (e in atTarget) {
					if (!e.canEnter(this, direction, speed)) return false;
				}
			}
			
			// dann bewegen wir uns mal...
			moveData.direction = direction;
			moveData.speedMovement = speed;
			moveData.distanceLeft = dist;
			
			// informieren wir mal jeden auf dem Zielfeld das wir es demnächst betreten
			for (e in atTarget) {
				e.willEnter(this, direction, speed);
			}
			
			// auf dem Startfeld auch alle Objekte informieren...
			var atStart:Array<Entity> = room.getCollisionsAt(gridX, gridY, this);
			for (e in atStart) {
				e.onLeave(this, direction);
			}
			
			onStartMoving();
			
			return true;
		}
		
		return false;
	}
	
	function processMovement(deltaTime:Float) {
		var distance:Float = 0;

		distance = deltaTime * moveData.speedMovement;
		
		if (distance > moveData.distanceLeft) {
			distance = moveData.distanceLeft;
			moveData.distanceLeft = 0.0;
		} else {
			moveData.distanceLeft -= distance;
		}
		
		x += (moveData.direction.x * distance);
		y += (moveData.direction.y * distance);
		
		if (moveData.distanceLeft == 0.0) {
			x = Math.fround(x);
			y = Math.fround(y);
			
			var atTarget:Array<Entity> = room.getEntitiesAt(gridX, gridY, this);
			
			var oldDirection = moveData.direction;
			moveData.direction = Direction.NONE;
			
			for (e in atTarget) {
				e.onEnter(this, oldDirection);
			}
			
			
		}
	}
	
	function onStartMoving() {
		
	}
	
	function onStopMoving() {
		
	}
}