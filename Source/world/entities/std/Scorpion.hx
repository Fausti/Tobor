package world.entities.std;

import world.entities.EntityAI;
import world.entities.interfaces.IEnemy;

import lime.math.Vector2;
import lime.math.Rectangle;

/**
 * ...
 * @author Matthias Faust
 */
class Scorpion extends EntityAI implements IEnemy {
	public static var SPEED:Float = 1.5;
	
	var SPR_SCORPION_0:Array<Sprite>;
	var SPR_SCORPION_1:Array<Sprite>;
	var SPR_SCORPION_NEST:Sprite;
	
	var robotSpeed:Float = 0;
	
	var timeLeft:Float = 5;
	
	public function new() {
		super();
		
		robotSpeed = SPEED + (Math.random());
		
		SPR_SCORPION_0 = [Gfx.getSprite(176, 168), Gfx.getSprite(144, 168)];
		SPR_SCORPION_1 = [Gfx.getSprite(176 + 16, 168), Gfx.getSprite(144 + 16, 168)];
		SPR_SCORPION_NEST = Gfx.getSprite(176 + 32, 168);
		
		type = 0;
	}
	
	override public function render() {
		var animPhase:Float = Math.fceil(moveData.distanceLeft) - moveData.distanceLeft;
		
		if (type == 0) {
			Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_SCORPION_NEST);
		} else {
			// Blickrichtung
			var renderDir:Int = 0;
			
			if (moveData.direction.x <= 0) {
				renderDir = 0;
			} else {
				renderDir = 1;
			}
			
			if (animPhase <= 0.5) {
				Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_SCORPION_0[renderDir]);
			} else {
				Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_SCORPION_1[renderDir]);
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
	
	override public function update(deltaTime:Float) {
		if (timeLeft > 0) {
			timeLeft = timeLeft - deltaTime;
			if (timeLeft < 0) {
				timeLeft = 0;
				type = 1;
			}
		}
		
		if (timeLeft == 0 && type == 1) {
			super.update(deltaTime);
		}
	}
	
	override function idle() {
		// verbuddeln?
		if (Utils.chance(25)) {
			var onSand:Bool = false;
			
			for (e in room.getAllEntitiesAt(x, y, this)) {
				if (Std.is(e, Sand)) onSand = true;
			}
			
			if (onSand) {
				type = 0;
				timeLeft = 5 + Std.random(10);
				return;
			}
		}
		
		var player = room.getPlayer();
		
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
			move(getRandomDirection(targetDirection), (robotSpeed));
		} else {
			
		}
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (Std.is(e, Android)) return true;
		if (Std.is(e, Charlie)) return true;
		if (Std.is(e, ElectricFence)) return true;
		
		if (Std.is(e, Robot)) {
			if (Utils.chance(10)) return true;
		}
		
		return false;
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		// if (isMoving()) return;
		
		if (Std.is(e, Robot) || Std.is(e, Android) || Std.is(e, Charlie)) {
			e.die();
			// if (Utils.chance(5)) stress = stress + 1;
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