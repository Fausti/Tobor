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
		
			if (room.world.garlic > 0) {
				if (Utils.distance(x, y, player.x, player.y) < 4) { 
					// Richtung umkehren wenn Knoblauch aktiv
					targetDirection.x = -targetDirection.x;
					targetDirection.y = -targetDirection.y;
				}
			}
		}
		
		return targetDirection;
	}
	
	override function idle() {
		var player = room.getPlayer();
		var playerDirection = getDirectionToPlayer();
		
		// Wenn sich der Roboter nicht DIREKT in Spielerrichtung bewegen kann...
		if (!move(Direction.get(playerDirection.x, playerDirection.y), (SPEED))) {
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
	
	/*
	override function idle() {
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
	*/
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		if (Std.is(e, Charlie)) return true;
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
}