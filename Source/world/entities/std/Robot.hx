package world.entities.std;

import lime.math.Vector2;
import world.entities.Entity;
import world.entities.EntityAI;
import lime.math.Rectangle;
import world.entities.interfaces.IEnemy;

/**
 * ...
 * @author Matthias Faust
 */
class Robot extends EntityAI implements IEnemy {
	public static var SPEED:Float = 1.5;
	
	var stress:Int = 0;
	var maxStress:Int = 150;
	
	var robotSpeed:Float = 0;
	
	var sprLayer0:Array<Sprite>;
	var sprLayer1:Array<Sprite>;
	
	var justSpawned:Bool = true;
	
	public function new() {
		super();
	
		robotSpeed = SPEED + (Math.random());
		
		type = Std.random(7);
		
		var c:Array<Color> = [
			Color.palette[Std.random(Color.palette.length - 1)]
		];
		
		var cc:Color = Color.palette[Std.random(Color.palette.length - 1)];
		while (cc == c[0]) {
			cc = Color.palette[Std.random(Color.palette.length - 1)];
		}
		
		c.push(cc);
		
		cc = Color.palette[Std.random(Color.palette.length - 1)];
		while (cc == c[0] || cc == c[1]) {
			cc = Color.palette[Std.random(Color.palette.length - 1)];
		}
		
		c.push(cc);
		
				
		var mx:Int = 32 * type;
		
		sprLayer0 = [Gfx.getSprite(mx + 0, 84), Gfx.getSprite(mx + 0, 96), Gfx.getSprite(mx + 0, 108)];
		sprLayer1 = [Gfx.getSprite(mx + 16, 84), Gfx.getSprite(mx + 16, 96), Gfx.getSprite(mx + 16, 108)];
		
		for (i in 0 ... 3) {
			sprLayer0[i].color = c[i];
			sprLayer1[i].color = c[i];
		}
	}
	
	function calcStress() {
		// Spieler ist tot...
		if (!room.getPlayer().visible) {
			stress = 0;
			return;
		}
		
		var freeTiles:Int = 0;
		
		for (d in Direction.STAR) {
			if (isFree(d, robotSpeed)) freeTiles++;
		}
		
		var chance:Float = Utils.random(0, 100);
		
		
	}
	
	override function idle() {
		// altes Verhalten?
		// if (Config.robotBehavior == 1) {
			idleOld();
			return;
		// }
		
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
				if (isFree(d, robotSpeed)) free.push(d);
			}
			
			// ist EIN Feld blockiert, horizontal | vertikal gehen
			if (free.length == 1) {
				targetDirection = free[0];
			}
			
			// bei ZWEI oder KEINEM freien Nachbarfeld diagonal gehen
		}
		
		// Können wir uns aufs Zielfeld begeben?
		var canMove:Bool = move(targetDirection, robotSpeed);
		
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
					if (isFree(d, robotSpeed)) free.push(d);
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
					if (isFree(Direction.rotate(targetDirection, 4), robotSpeed)) {
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
			
			canMove = move(dodgeDirection, robotSpeed);
			
			if (canMove) stress--;
			
			if (stress > maxStress) {
				die();
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
	
	override public function render() {
		// super.render();
		
		var animPhase:Float = Math.fceil(moveData.distanceLeft) - moveData.distanceLeft;
		
		if (animPhase <= 0.5) {
			for (i in 0 ... 3) {
				Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, sprLayer0[i]);
			}
		} else {
			for (i in 0 ... 3) {
				Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, sprLayer1[i]);
			}
		}
		
		if (Config.robotStress) {
			var strStress:String = Std.string(stress).lpad(3, " ");
			Tobor.fontSmall.drawString(x * Tobor.TILE_WIDTH - 4, y * Tobor.TILE_HEIGHT + 1, strStress, Color.ORANGE, new Color(0, 0, 0, 0.75));
		}
	}
	
	function idleOld() {
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
				if (isFree(d, robotSpeed)) free.push(d);
			}
			
			// ist EIN Feld blockiert, horizontal | vertikal gehen
			if (free.length == 1) {
				targetDirection = free[0];
			}
			
			// bei ZWEI oder KEINEM freien Nachbarfeld diagonal gehen
		}
		
		// Wenn sich der Roboter nicht DIREKT in Spielerrichtung bewegen kann...
		if (!move(targetDirection, (robotSpeed))) {
			// ... soll er versuchen in eine zufällige Richtung zu gehen
			
			// if (!move(Direction.getRandomAll(), (robotSpeed))) {
			if (!move(getRandomDirection(targetDirection), (robotSpeed))) {
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
		if (Std.is(e, Android)) return true;
		if (Std.is(e, Charlie)) return true;
		if (Std.is(e, Doppelganger)) return true;
		if (Std.is(e, ElectricFence)) return true;
		
		if (Std.is(e, Robot)) {
			if (Utils.chance(10)) return true;
		}
		
		return false;
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		// if (isMoving()) return;
		
		if (Std.is(e, Robot) || Std.is(e, Android)) {
			// e.die();
			if (Utils.chance(5)) stress = stress + 1;
		}
	}
	
	override public function die() {
		if (justSpawned) return;
		
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
	
	override public function update(deltaTime:Float) {
		justSpawned = false;
		super.update(deltaTime);
	}
}