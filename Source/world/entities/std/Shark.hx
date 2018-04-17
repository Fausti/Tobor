package world.entities.std;

import world.entities.EntityAI;
import lime.math.Vector2;
import lime.math.Rectangle;

/**
 * ...
 * @author Matthias Faust
 */
class Shark extends EntityAI {
	public static var SPEED:Float = 1.0;
	
	var sprLeft:Array<Sprite>;
	var sprRight:Array<Sprite>;
	
	var isHunting:Bool = false;
	
	public function new() {
		super();
		
		sprLeft = [Gfx.getSprite(112, 120), Gfx.getSprite(128, 120)];
		sprRight = [Gfx.getSprite(144, 120), Gfx.getSprite(160, 120)];
	}
	
	override public function render() {
		var renderSprite:Sprite = null;
		
		if (isHunting) {
			if (moveData.direction.x <= 0) {
				renderSprite = sprLeft[0];
			} else {
				renderSprite = sprRight[0];
			}
			
			if (renderSprite != null) Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, renderSprite);
		} else {
			if (moveData.direction.x <= 0) {
				renderSprite = sprLeft[1];
			} else {
				renderSprite = sprRight[1];
			}
			
			if (renderSprite != null) Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, renderSprite);
		}
	}
	
	override public function die() {
		room.spawnEntity(x, y, new Explosion());
		
		Sound.play(Sound.SND_EXPLOSION_ROBOT);
		
		super.die();
	}
	
	override public function collisionAt(cx:Float, cy:Float):Bool {
		if (!alive) return false;
		
		var r = boundingBox.intersects(new Rectangle(cx, cy, 1, 1));
		return r;
	}
	
	override public function move(direction:Vector2, speed:Float, ?dist:Int = 1):Bool {
		// Geschwindigkeit anpassen
		speed = Config.getSpeed(speed);
		
		if (direction == Direction.NONE) return false;
		
		if (!isMoving()) {
			if (isOutsideMap(x + direction.x, y + direction.y)) return false;
			
			var atTarget:Array<Entity> = room.getCollisionsAt(gridX + direction.x, gridY + direction.y);
			
			var numWater:Int = 0;
			
			// kann Feld betreten werden?
			if (dist == 1) { // Tunnel ignorieren dies hier...
				for (e in atTarget) {
					if (!e.canEnter(this, direction, speed)) return false;
					
					// auf Wasser prüfen!
					if (Std.is(e, WaterDeadly)) numWater++;
					else if (Std.is(e, Water)) {
						if (e.type == 0 || e.type == 1) numWater++;
					}
				}
			}
			
			// kann nicht ausserhalb von Wasser
			if (numWater == 0) return false;
			
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
	
	override function getDirectionToPlayer(?ignoreGarlic:Bool = false):Vector2 {
		var targetDirection:Vector2 = new Vector2();
		
		var player = room.getPlayer();
		
		if (player.visible) {
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
		} else {
			isHunting = false;
		}
		
		targetDirection = Direction.normalize(targetDirection);
		
		if (targetDirection == Direction.NONE) targetDirection = Direction.getRandom();
		
		return targetDirection;
	}
	
	override function idle() {
		var mSpeed:Float = SPEED;
		var player = room.getPlayer();
		
		// Bewegungen...
		if (!alive) return;
		
		var targetDirection:Vector2 = Direction.NONE;
		
		var inWater:Bool = false;
		
		for (e in room.getEntitiesAt(getPlayer().x, getPlayer().y)) {
			if (Std.is(e, Water)) inWater = true;
		}
		
		if (inWater) {
			if (Utils.distance(x, y, player.x, player.y) <= 12) {
				targetDirection = getDirectionToPlayer(true);
				isHunting = true;
				mSpeed = mSpeed + 1.0;
			} else {
				targetDirection = Direction.getRandom();
				isHunting = false;
			}
		} else {
			targetDirection = Direction.getRandom();
			isHunting = false;
		}
		
		// Sonderfall bei diagonaler Bewegung
		if (Direction.isDiagonal(targetDirection)) {
			// freie Nachbarfelder suchen
			var free:Array<Vector2> = [];
			
			for (d in Direction.getParts(targetDirection)) {
				if (isFree(d, mSpeed)) free.push(d);
			}
			
			// ist EIN Feld blockiert, horizontal | vertikal gehen
			if (free.length == 1) {
				targetDirection = free[0];
			}
			
			// bei ZWEI oder KEINEM freien Nachbarfeld diagonal gehen
		}
		
		// Können wir uns aufs Zielfeld begeben?
		var canMove:Bool = move(targetDirection, mSpeed);
		
		if (!canMove) {
			var dodgeDirection:Vector2 = Direction.NONE;
			
			if (Direction.isDiagonal(targetDirection)) {
				dodgeDirection = Direction.getParts(targetDirection)[Std.random(2)];
			} else {
				dodgeDirection = Direction.rotate(targetDirection, 4);
			}
			
			canMove = move(dodgeDirection, mSpeed);
			
			if (!canMove) {
				move(getRandomDirection(dodgeDirection), mSpeed);
			}
		}
	}
	
	function getRandomDirection(targetDirection:Vector2):Vector2 {
		var rotation:Int = 0;
		var chance:Float = Utils.random(0, 100);
		
		if (chance < 40) {
			rotation = 4;
		} else if (chance < 50) {
			rotation = 3;
		} else if (chance < 60) {
			rotation = -3;
		} else if (chance < 70) {
			rotation = 2;
		} else if (chance < 80) {
			rotation = -2;
		} else if (chance < 90) {
			rotation = 1;
		} else if (chance < 100) {
			rotation = -1;
		} else {
			trace("Nanu?! Fausti, du bist ein Trottel!");
		}
				
		targetDirection = Direction.rotate(targetDirection, rotation);
		
		return targetDirection;
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (Std.is(e, Charlie)) return true;
		
		return false;
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		if (!e.alive) return;
		if (!e.visible) return;
		
		// if (isMoving()) return;
		
		if (Std.is(e, Charlie)) {
			e.die();
			
			if (getWorld().checkFirstUse("KILLED_BY_SHARK")) {
					
			} else {
				getWorld().markFirstUse("KILLED_BY_SHARK");
				getWorld().showPickupMessage("KILLED_BY_SHARK", false, function () {
					getWorld().hideDialog();
				});
			}
		}
	}
}