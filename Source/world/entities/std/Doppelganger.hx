package world.entities.std;

import world.entities.EntityAI;
import lime.math.Vector2;
import lime.math.Rectangle;

/**
 * ...
 * @author Matthias Faust
 */
class Doppelganger extends EntityAI {
	public static var PLAYER_SPEED:Float = 4;
	
	var sprStanding:Sprite;
	var sprWalking_0:Sprite;
	var sprWalking_1:Sprite;
	
	public function new() {
		super();
		
		sprStanding = Gfx.getSprite(16, 0);
		
		sprWalking_0 = Gfx.getSprite(32, 0);
		sprWalking_1 = Gfx.getSprite(48, 0);
		
		z = Room.LAYER_LEVEL_0 + 1;
	}
	
	override public function render() {
		var spr:Sprite = null;
		
		var animPhase:Float = Math.fceil(moveData.distanceLeft) - moveData.distanceLeft;
			
		if (animPhase <= 0.5) {
			spr = sprWalking_0;
		} else {
			spr = sprWalking_1;
		}
		
		if (spr != null) Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, spr);
	}
	
	override function idle() {
		var player = room.getPlayer();
		
		// Bewegungen...
		if (!alive) return;
		
		var targetDirection = Direction.NONE;
		
		if (Input.isKeyDown(Tobor.KEY_LEFT)) {
			targetDirection = Direction.E;
		} else if (Input.isKeyDown(Tobor.KEY_RIGHT)) {
			targetDirection = Direction.W;
		} else if (Input.isKeyDown(Tobor.KEY_UP)) {
			targetDirection = Direction.S;
		} else if (Input.isKeyDown(Tobor.KEY_DOWN)) {
			targetDirection = Direction.N;
		}
		
		if (targetDirection == Direction.NONE) {
			targetDirection = Direction.getRandom();
		}
		
		if (move(targetDirection, (PLAYER_SPEED))) {
			move(Direction.getRandom(), (PLAYER_SPEED));
		}
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (Std.isOfType(e, Charlie) || Std.isOfType(e, Robot) || Std.isOfType(e, Android)) return true;
		
		return false;
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		// if (isMoving()) return;
		
		if (Std.isOfType(e, Robot) || Std.isOfType(e, Android)) {
			// e.die();
			die();
		}
	}
	
	override function onStartMoving() {
		Sound.play(Sound.SND_CHARLIE_STEP);
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
	
	override public function die() {
		room.spawnEntity(x, y, new Explosion());
		
		Sound.play(Sound.SND_EXPLOSION_ROBOT);
		
		super.die();
	}
}