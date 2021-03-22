package world.entities.std;

import world.entities.EntityAI;
import world.entities.interfaces.IElectric;
import lime.math.Vector2;
import lime.math.Rectangle;

/**
 * ...
 * @author Matthias Faust
 */
class NPC extends EntityAI implements IElectric {
	public static var SPEED:Float = 0.75;
	var robotSpeed:Float = 0;
	
	var SPR_NPC_0:Sprite;
	var SPR_NPC_1:Sprite;
	
	var SPR_NPC_LAYER_0:Sprite;
	var SPR_NPC_LAYER_1:Sprite;
	
	var COLORS = [
		[Color.YELLOW, Color.ORANGE],
		[Color.RED, Color.DARK_RED],
		[Color.NEON_GREEN, Color.DARK_GREEN],
		[Color.LIGHT_BLUE, Color.DARK_BLUE],
		[Color.GRAY, Color.DARK_GRAY]
	];
	
	var waitTime:Float = 2;
	var timeLeft:Float = 2;
	
	public function new() {
		super();
		
		robotSpeed = SPEED;
	
		SPR_NPC_0 = Gfx.getSprite(128, 276);
		SPR_NPC_1 = Gfx.getSprite(128 + 16, 276);
		
		SPR_NPC_LAYER_0 = Gfx.getSprite(128 + 32, 276);
		SPR_NPC_LAYER_1 = Gfx.getSprite(128 + 48, 276);
		
		timeLeft = waitTime;
	}
	
	override public function update(deltaTime:Float) {
		if (timeLeft > 0) {
			timeLeft = timeLeft - deltaTime;
			if (timeLeft < 0) timeLeft = 0.0;
		}
		
		super.update(deltaTime);
	}
	
	override public function render() {
		var animPhase:Float = Math.fceil(moveData.distanceLeft) - moveData.distanceLeft;
		var c:Int;
		
		switch(flag) {
			case Marker.MARKER_0:
				c = 0;
			case Marker.MARKER_1:
				c = 1;
			case Marker.MARKER_2:
				c = 2;
			case Marker.MARKER_3:
				c = 3;
			case Marker.MARKER_4:
				c = 4;
			default:
				c = 4;
		}
		
		if (animPhase <= 0.5) {
			Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_NPC_0);
			Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_NPC_LAYER_0, COLORS[c][0]);
			Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_NPC_LAYER_1, COLORS[c][1]);
		} else {
			Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_NPC_1);
			Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_NPC_LAYER_0, COLORS[c][0]);
			Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_NPC_LAYER_1, COLORS[c][1]);
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
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (Std.isOfType(e, Charlie)) return true;
		
		return false;
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		if (!e.alive) return;
		if (!e.visible) return;
		if (!Std.isOfType(e, Charlie)) return;
		
		if (timeLeft == 0.0) {
			if (flag != Marker.MARKER_NO) {
				getWorld().showMessage("TXT_" + room.getID() + "_NPC_NR_" + flag, false);
			}
			
			timeLeft = waitTime;
		}
	}
	
	override function idle() {
		if (Utils.chance(50)) return;
		
		var player = room.getPlayer();
		
		// Bewegungen...
		if (!alive) return;
		
		var targetDirection = Direction.getRandom();
		
		if (room.world.garlic > 0) {
			targetDirection = getDirectionToPlayer();
		}
		
		move(targetDirection, (robotSpeed));
	}
	
	override function getDirectionToPlayer(?ignoreGarlic:Bool = false):Vector2 {
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
					if (Utils.distance(x, y, player.x, player.y) < 5) { 
						// Richtung umkehren wenn Knoblauch aktiv
						targetDirection.x = -targetDirection.x;
						targetDirection.y = -targetDirection.y;
					} else {
						targetDirection = Direction.getRandom();
					}
				}
			}
		// }
		
		targetDirection = Direction.normalize(targetDirection);
		
		if (targetDirection == Direction.NONE) targetDirection = Direction.getRandom();
		
		return targetDirection;
	}
}