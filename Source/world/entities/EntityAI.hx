package world.entities;

import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class EntityAI extends EntityMoveable {
	var waitTicks:Float = 0;
	
	public function new() {
		super();
		
		z = Room.LAYER_LEVEL_0 + 1;
	}
	
	
	override public function update(deltaTime:Float) {
		super.update(deltaTime);
		
		if (!isMoving()) {
			if (waitTicks != 0) {
				waitTicks = -1;
				
				if (waitTicks < 0) waitTicks = 0;
			} else {
				idle();
			}
		}
	}
	
	function idle() {
		
	}
	
	function getDirectionToPlayer(?ignoreGarlic:Bool = false):Vector2 {
		var targetDirection:Vector2 = new Vector2();
		
		var player = room.getPlayer();
		
		// if (player.visible) {
			if (player.gridX < gridX) {
				targetDirection.x = -1;
			} else if (player.gridX > gridX) {
				targetDirection.x = 1;
			}
		
			if (player.gridY < gridY) {
				targetDirection.y = -1;
			} else if (player.gridY > gridY) {
				targetDirection.y = 1;
			}
		
			if (!ignoreGarlic) {
				if (room.world.garlic > 0) {
					if (Utils.distance(x, y, player.x, player.y) < 4) { 
						// Richtung umkehren wenn Knoblauch aktiv
						targetDirection.x = -targetDirection.x;
						targetDirection.y = -targetDirection.y;
					}
				}
			}
		// }
		
		targetDirection = Direction.normalize(targetDirection);
		
		if (targetDirection == Direction.NONE) targetDirection = Direction.getRandom();
		
		return targetDirection;
	}
	
	function isFree(direction:Vector2, speed:Float):Bool {
		// nicht ausserhalb des Raumes!
		if (isOutsideMap(x, y)) return false;
		
		// alle Objekte auf dem Zielfeld fragen
		var atTarget:Array<Entity> = room.getCollisionsAt(gridX + direction.x, gridY + direction.y);
			
		for (e in atTarget) {
			// wenn eines davon nicht betreten werden kann, sind die restlichen uninteressant
			// das Feld ist somit blockiert
			if (!e.canEnter(this, direction, speed)) return false;
		}
		
		return true;
	}
	
	override public function hasWeight():Bool {
		return true;
	}
}