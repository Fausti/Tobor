package world.entities;

import lime.math.Vector2;
import world.entities.std.Doppelganger;

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
		var distance:Float = 1000.0;
		
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
			
			distance = Utils.distance(x, y, player.x, player.y);
		
			if (!ignoreGarlic) {
				if (room.world.garlic > 0) {
					if (distance < 4) { 
						// Richtung umkehren wenn Knoblauch aktiv
						targetDirection.x = -targetDirection.x;
						targetDirection.y = -targetDirection.y;
					}
				}
			}
		// }
		
		for (e in room.findAll(Doppelganger)) {
			if (e.alive) {
				var d:Float = Utils.distance(x, y, e.x, e.y);
				
				if (d < distance) {
					if (e.gridX < gridX) {
						targetDirection.x = -1;
					} else if (e.gridX > gridX) {
						targetDirection.x = 1;
					}
		
					if (e.gridY < gridY) {
						targetDirection.y = -1;
					} else if (e.gridY > gridY) {
						targetDirection.y = 1;
					}
					
					distance = d;
				}
			}
		}
		
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