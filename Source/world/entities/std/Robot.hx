package world.entities.std;

import lime.math.Vector2;
import world.entities.Entity;
import world.entities.EntityAI;
import lime.math.Rectangle;

/**
 * ...
 * @author Matthias Faust
 */
class Robot extends EntityAI {
	public static var SPEED:Float = 2.0;
	
	var stress:Int = 0;
	var maxStress:Int = 150;
	
	public function new() {
		super();
	
		type = Std.random(7);
		
		var c0:Color = Color.palette[Std.random(Color.palette.length - 1)];
		var c1:Color = Color.palette[Std.random(Color.palette.length - 1)];
		var c2:Color = Color.palette[Std.random(Color.palette.length - 1)];
		
		var mx:Int = 32 * type;
		
		sprites[0] = new Animation([
			Gfx.getSprite(mx + 0, 84),
			Gfx.getSprite(mx + 16, 84)
		], 0.75);
		
		sprites[1] = new Animation([
			Gfx.getSprite(mx + 0, 96),
			Gfx.getSprite(mx + 16, 96)
		], 0.75);
		
		sprites[2] = new Animation([
			Gfx.getSprite(mx + 0, 108),
			Gfx.getSprite(mx + 16, 108)
		], 0.75);
		
		sprites[0].color = c0;
		cast(sprites[0], Animation).start();
		sprites[1].color = c1;
		cast(sprites[1], Animation).start();
		sprites[2].color = c2;
		cast(sprites[2], Animation).start();
	}
	
	function getDirectionToPlayer():Vector2 {
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
		
			if (room.world.garlic > 0) {
				if (Utils.distance(x, y, player.x, player.y) < 4) { 
					// Richtung umkehren wenn Knoblauch aktiv
					targetDirection.x = -targetDirection.x;
					targetDirection.y = -targetDirection.y;
				}
			}
		// }
		
		targetDirection = Direction.normalize(targetDirection);
		
		if (targetDirection == Direction.NONE) targetDirection = Direction.getRandom();
		
		return targetDirection;
	}
	
	function isFree(direction:Vector2):Bool {
		// nicht ausserhalb des Raumes!
		if (isOutsideMap(x, y)) return false;
		
		// alle Objekte auf dem Zielfeld fragen
		var atTarget:Array<Entity> = room.getCollisionsAt(gridX + direction.x, gridY + direction.y);
			
		for (e in atTarget) {
			// wenn eines davon nicht betreten werden kann, sind die restlichen uninteressant
			// das Feld ist somit blockiert
			if (!e.canEnter(this, direction, SPEED)) return false;
		}
		
		return true;
	}
	
	function calcStress() {
		// Spieler ist tot...
		if (!room.getPlayer().visible) {
			stress = 0;
			return;
		}
		
		var freeTiles:Int = 0;
		
		for (d in Direction.STAR) {
			if (isFree(d)) freeTiles++;
		}
		
		var chance:Float = Utils.random(0, 100);
		
		
	}
	
	override function idle() {
		// altes Verhalten?
		if (Config.robotBehavior == 1) {
			idleOld();
			return;
		}
		
		var player = room.getPlayer();
		
		// Stresslevel, weil falls Roboter stirbt brauchen wir hier nichts weiter machen
		// calcStress();
		
		// Bewegungen...
		if (!alive) return;
		
		var targetDirection = getDirectionToPlayer();
		
		// Sonderfall bei diagonaler Bewegung
		if (Direction.isDiagonal(targetDirection)) {
			// freie Nachbarfelder suchen
			var free:Array<Vector2> = [];
			
			for (d in Direction.getParts(targetDirection)) {
				if (isFree(d)) free.push(d);
			}
			
			// ist EIN Feld blockiert, horizontal | vertikal gehen
			if (free.length == 1) {
				targetDirection = free[0];
			}
			
			// bei ZWEI oder KEINEM freien Nachbarfeld diagonal gehen
		}
		
		// Können wir uns aufs Zielfeld begeben?
		var canMove:Bool = move(targetDirection, SPEED);
		
		// Solange Zielrichtung blockiert
		while (!canMove) {
			stress++;
			
			if (!alive) break;
			
			var chance:Float = Utils.random(0, 100);
			var dodgeDirection:Vector2 = Direction.NONE;
			
			if (Direction.isDiagonal(targetDirection)) {
				// freie Nachbarfelder suchen
				var free:Array<Vector2> = [];
			
				for (d in Direction.getParts(targetDirection)) {
					if (isFree(d)) free.push(d);
				}
			
				if (free.length == 2) {
					// 3.1
					if (chance < 50) {
						dodgeDirection = free[0];
					} else {
						dodgeDirection = free[1];
					}
				} else if (free.length == 1) {
					// 3.2
					dodgeDirection = free[0];
				} else {
					if (isFree(Direction.rotate(targetDirection, 4))) {
						// 3.3
						if (chance < 70) {
							dodgeDirection = Direction.rotate(targetDirection, 4);
						} else if (chance < 85) {
							dodgeDirection = Direction.rotate(targetDirection, 2);
						} else {
							dodgeDirection = Direction.rotate(targetDirection, -2);
						}
					} else {
						// 3.4
						if (chance < 35) {
							dodgeDirection = Direction.rotate(targetDirection, 2);
						} else if (chance < 70) {
							dodgeDirection = Direction.rotate(targetDirection, -2);
						} else if (chance < 85) {
							dodgeDirection = Direction.rotate(targetDirection, 3);
						} else {
							dodgeDirection = Direction.rotate(targetDirection, -3);
						}
					}
				}
			} else {
				var rotation:Int = 0;
				
				if (chance < 70) {
					rotation = 4;
				} else if (chance < 78) {
					rotation = 3;
				} else if (chance < 86) {
					rotation = -3;
				} else if (chance < 88) {
					rotation = 2;
				} else if (chance < 90) {
					rotation = -2;
				} else if (chance < 95) {
					rotation = 1;
				} else if (chance < 100) {
					rotation = -1;
				} else {
					trace("Nanu?! Fausti, du bist ein Trottel!");
				}
				
				dodgeDirection = Direction.rotate(targetDirection, rotation);
			}
			
			canMove = move(dodgeDirection, SPEED);
			
			if (canMove) stress--;
			
			if (stress > maxStress) {
				die();
			}
		}
	}
	
	override public function render() {
		super.render();
		
		if (Config.robotStress) {
			var strStress:String = Std.string(stress).lpad(3, " ");
			Tobor.fontSmall.drawString(x * Tobor.TILE_WIDTH - 4, y * Tobor.TILE_HEIGHT + 1, strStress, Color.ORANGE, new Color(0, 0, 0, 0.75));
		}
	}
	
	function idleOld() {
		var playerDirectionX = 0;
		var playerDirectionY = 0;
		
		var player = room.getPlayer();
		
		if (player.visible) {
			if (player.gridX < gridX) {
				playerDirectionX = -1;
			} else if (player.gridX > gridX) {
				playerDirectionX = 1;
			}
		
			if (player.gridY < gridY) {
				playerDirectionY = -1;
			} else if (player.gridY > gridY) {
				playerDirectionY = 1;
			}
		
			if (room.world.garlic > 0) {
				if (Utils.distance(x, y, player.x, player.y) < 4) { 
					// Richtung umkehren wenn Knoblauch aktiv
					playerDirectionX = -playerDirectionX;
					playerDirectionY = -playerDirectionY;
				}
			}
		}
		
		// Wenn sich der Roboter nicht DIREKT in Spielerrichtung bewegen kann...
		if (!move(Direction.get(playerDirectionX, playerDirectionY), (SPEED))) {
			// ... soll er versuchen in eine zufällige Richtung zu gehen
			
			if (!move(Direction.getRandomAll(), (SPEED))) {
				stress++;
			} else {
				stress--;
			}
			
		} else {
			
		}
		
		if (stress > maxStress) {
			die();
		}
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (Std.is(e, Charlie)) return true;
		if (Std.is(e, ElectricFence)) return true;
		
		return false;
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		if (isMoving()) return;
		
		if (Std.is(e, Robot)) {
			e.die();
		}
	}
	
	override public function die() {
		room.spawnEntity(x, y, new Explosion());
		
		Sound.play(Sound.SND_EXPLOSION_ROBOT);
		
		super.die();
	}
	
	override function onStartMoving() {
		Sound.play(Sound.SND_ROBOT_STEP);
	}
	
	override function onStopMoving() {

	}
	
	override public function collisionAt(cx:Float, cy:Float):Bool {
		if (!alive) return false;
		
		var r = boundingBox.intersects(new Rectangle(cx, cy, 1, 1));
		return r;
	}
	
	override public function move(direction:Vector2, speed:Float, ?dist:Int = 1):Bool {
		// Geschwindigkeit anpassen
		speed = Config.getSpeed(speed);
		
		return super.move(direction, speed, dist);
	}
}