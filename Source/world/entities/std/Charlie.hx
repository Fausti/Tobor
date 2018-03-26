package world.entities.std;

import gfx.Animation;
import gfx.Sprite;
import lime.math.Vector2;
import world.entities.Entity;
import world.entities.EntityMoveable;

/**
 * ...
 * @author Matthias Faust
 */
class Charlie extends EntityMoveable {
	var sprStanding:Sprite;
	var sprWalking:Animation;
	
	var sprStandingOverall:Sprite;
	var sprWalkingOverall:Animation;
	
	public var walkInTunnel:Bool = false;
	var lastTunnelStep:Int = 0;
	
	public function new() {
		super();
		
		// normal
		
		sprStanding = Gfx.getSprite(16, 0);
		
		sprWalking = new Animation([
			Gfx.getSprite(32, 0),
			Gfx.getSprite(48, 0)
		], 0.75);
		
		// Blaumann
		
		sprStandingOverall = Gfx.getSprite(0, 156);
		
		sprWalkingOverall = new Animation([
			Gfx.getSprite(16, 156),
			Gfx.getSprite(32, 156)
		], 0.75);
			
		sprites[0] = sprStanding;
		
		z = Room.LAYER_LEVEL_0 + 1;
	}
	
	override public function update(deltaTime:Float) {
		super.update(deltaTime);
		
		if (isMoving()) {
			if (walkInTunnel) {
				var step = Math.floor(moveData.distanceLeft);
				
				if (step < lastTunnelStep) {
					Sound.play(Sound.SND_TUNNEL_STEP);
					lastTunnelStep = step;
				}
			}
		}
	}
	
	override public function isMoving():Bool {
		if (!visible) return true;
		
		return super.isMoving();
	}
	
	override function onStartMoving() {
		if (room.world.inventory.containsOverall) {
			sprites[0] = sprWalkingOverall;
			sprWalkingOverall.start(false);
		} else {
			sprites[0] = sprWalking;
			sprWalking.start(false);
		}
		
		if (moveData.distanceLeft > 1.0) {
			walkInTunnel = true;
			lastTunnelStep = Math.floor(moveData.distanceLeft);
		}
		
		if (walkInTunnel) {
			Sound.play(Sound.SND_TUNNEL_STEP);
		} else {
			Sound.play(Sound.SND_CHARLIE_STEP);
		}
	}
	
	override function onStopMoving() {
		checkForOverall();
		
		if (walkInTunnel) {
			Sound.play(Sound.SND_TUNNEL_STEP);
			walkInTunnel = false;
		} else {
			Sound.play(Sound.SND_CHARLIE_STEP);
		}
	}
	
	override public function die() {
		var e:Explosion = new Explosion();
		
		e.onRemove = function() {
			room.world.player.visible = true;
			room.world.lives--;
		}
		
		room.spawnEntity(x, y, e);
		
		Sound.play(Sound.SND_EXPLOSION_CHARLIE);
		
		visible = false;
		
		super.die();
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		if (visible && Std.is(e, Robot)) {
			die();
		}
	}
	
	public function hasOverall():Bool {
		return room.world.inventory.containsOverall;
	}
	
	public function checkForOverall() {
		if (hasOverall()) {
			setSprite(sprStandingOverall);
		} else {
			setSprite(sprStanding);
		}
	}
}