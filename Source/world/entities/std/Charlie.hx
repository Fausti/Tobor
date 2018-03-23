package world.entities.std;

import gfx.Animation;
import gfx.Sprite;
import world.entities.EntityMoveable;

/**
 * ...
 * @author Matthias Faust
 */
class Charlie extends EntityMoveable {
	var sprStanding:Sprite;
	var sprWalking:Animation;
	
	public var walkInTunnel:Bool = false;
	var lastTunnelStep:Int = 0;
	
	public function new() {
		super();
		
		sprStanding = Gfx.getSprite(16, 0);
		
		sprWalking = new Animation([
			Gfx.getSprite(32, 0),
			Gfx.getSprite(48, 0)
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
	
	override function onStartMoving() {
		sprites[0] = sprWalking;
		sprWalking.start(false);
		
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
		sprites[0] = sprStanding;
		sprWalking.stop(false);
		
		if (walkInTunnel) {
			Sound.play(Sound.SND_TUNNEL_STEP);
			walkInTunnel = false;
		} else {
			Sound.play(Sound.SND_CHARLIE_STEP);
		}
	}
}