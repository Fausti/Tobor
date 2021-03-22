package world.entities.std;

import world.entities.EntityAI;
import world.entities.interfaces.IEnemy;
import lime.math.Vector2;
import lime.math.Rectangle;

/**
 * ...
 * @author Matthias Faust
 */
class Android extends EntityAI implements IEnemy {
	var SPR_ANDROID:Array<Sprite>;
	public static var SPEED:Float = 1.5;
	var robotSpeed:Float = 0;
	
	public function new() {
		super();
		
		robotSpeed = SPEED;
		
		SPR_ANDROID = [Gfx.getSprite(176, 120), Gfx.getSprite(176 + 16, 120), Gfx.getSprite(176 + 32, 120)];
		
		type = 0;
	}
	
	override public function render() {
		Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_ANDROID[type]);
	}
	
	override function idle() {
		var mSpeed:Float = robotSpeed;
		var player = room.getPlayer();
		
		// Bewegungen...
		if (!alive) return;
		
		var freeTile:Int = 0;
		for (dd in Direction.ALL) {
			if (dd != Direction.NONE) {
				if (isFree(dd, mSpeed)) freeTile++;
			}
		}
		
		if (freeTile == 0) {
			die();
			return;
		}
		
		var targetDirection:Vector2 = Direction.NONE;
		
		if (Utils.distance(x, y, player.x, player.y) <= 12) {
			targetDirection = getDirectionToPlayer(true);
			mSpeed = mSpeed + 1.5;
		} else {
			targetDirection = Direction.getRandom();
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
			var chance:Float = Utils.random(0, 100);
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
		if (Std.isOfType(e, Android)) return false;
		if (Std.isOfType(e, Charlie)) return true;
		if (Std.isOfType(e, Doppelganger)) return true;
		if (Std.isOfType(e, ElectricFence)) return true;
		
		if (Std.isOfType(e, Robot)) {
			if (Utils.chance(10)) return true;
		}
		
		return false;
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		if (!e.alive) return;
		if (!e.visible) return;
		
		// if (isMoving()) return;
		
		if (Std.isOfType(e, Robot)) {
			e.die();			
		}
		
		if (Std.isOfType(e, Charlie)) {
			e.die();
			
			if (getWorld().checkFirstUse("KILLED_BY_ANDROID")) {
					
			} else {
				getWorld().markFirstUse("KILLED_BY_ANDROID");
				getWorld().showPickupMessage("KILLED_BY_ANDROID", false, function () {
					getWorld().hideDialog();
				});
			}
		}
	}
	
	override public function die() {
		room.spawnEntity(x, y, new Explosion());
		
		Sound.play(Sound.SND_EXPLOSION_ROBOT);
		
		super.die();
	}
	
	override function onStartMoving() {
		type++;
		
		if (type >= 3) {
			type = 0;
		}
		
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
	
	override function processMovement(deltaTime:Float) {
		super.processMovement(deltaTime);
		
		var atTarget:Array<Entity> = room.getCollisionsAt(x, y, this);
			
		if (atTarget.indexOf(getPlayer()) != -1) {
			getPlayer().die();
		}
	}
}