package world.entities;

import lime.math.Vector2;
import world.entities.std.Charlie;
import world.entities.std.Munition;
import world.entities.std.Sling;
import world.entities.std.Tunnel;

/**
 * ...
 * @author Matthias Faust
 */

typedef MoveData = {
	var distanceLeft:Float;
	var direction:Vector2;
	var speedMovement:Float; // Tiles per second
	
	var oldPositionX:Int;
	var oldPositionY:Int;
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
			
			oldPositionX: -1,
			oldPositionY: -1,
		}
	}
	
	override public function update(deltaTime:Float) {
		if (!isMoving() && wasMoving) {
			moveData.oldPositionX = gridX;
			moveData.oldPositionY = gridY;
			
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
		moveData.oldPositionX = gridX;
		moveData.oldPositionY = gridY;
			
		if (direction == Direction.NONE) return false;
		
		if (!isMoving()) {
			if (isOutsideMap(x + direction.x, y + direction.y)) return false;

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
		var distance:Float = 0.0;

		distance = deltaTime * moveData.speedMovement;

		if (distance > moveData.distanceLeft) {
			distance = moveData.distanceLeft;
			moveData.distanceLeft = 0.0;
		} else {
			moveData.distanceLeft = moveData.distanceLeft - distance;
		}
		
		x += (moveData.direction.x * distance);
		y += (moveData.direction.y * distance);
		
		if (moveData.distanceLeft == 0.0) {
			//if (Std.is(this, Charlie)) {
				// x = Math.round(moveData.oldPositionX + moveData.direction.x);
				// y = Math.round(moveData.oldPositionY + moveData.direction.y);
			//} else {
				x = Math.fround(x);
				y = Math.fround(y);
			//}
			
			var atTarget:Array<Entity> = room.getEntitiesAt(gridX, gridY, this);
			
			var oldDirection = moveData.direction;
			moveData.direction = Direction.NONE;
			
			// Sortieren, damit Schleuder als erstes eingesammelt wird!
			atTarget.sort(function (a, b) {
				if (Std.is(a, Sling) && !Std.is(b, Sling)) return -1;
				if (Std.is(b, Sling) && !Std.is(a, Sling)) return 1;
				return 0;
			});
			
			var onMunition:Bool = false;
			
			for (e in atTarget) {
				if (alive && visible) {
					if (Std.isOfType(e, Munition)) {
						if (!onMunition) {
							if (!Std.isOfType(this, Charlie)) onMunition = true;
							e.onEnter(this, oldDirection);
						}
					} else {
						e.onEnter(this, oldDirection);
					}
				} else if (Std.is(this, Charlie) && Std.is(e, Tunnel)) {
					// Sonderfall Tunnel
					e.onEnter(this, oldDirection);
				}
			}
			
			
		}
	}
	
	function onStartMoving() {
		
	}
	
	function onStopMoving() {
		
	}
	
	override public function onRoomEnds() {
		if (!alive) trace("dead entity: ", this);
		
		if (moveData.oldPositionX == -1 || moveData.oldPositionY == -1) return;
		if (!isMoving()) return;
		
		// alte Position wiederherstellen
		// x = Math.round(moveData.oldPositionX + moveData.direction.x);
		// y = Math.round(moveData.oldPositionY + moveData.direction.y);
		
		x = moveData.oldPositionX;
		y = moveData.oldPositionY;
		
		return;
	}
}