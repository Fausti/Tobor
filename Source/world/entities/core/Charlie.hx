package world.entities.core;

import gfx.Animation;
import gfx.Gfx;
import lime.math.Rectangle;
import lime.math.Vector2;
/**
 * ...
 * @author Matthias Faust
 */
class Charlie extends EntityMoveable {
	
	public var lives:Int = 3;
	public var points:Int = 0;
	public var gold:Int = 0;
	
	// Animation
	var animWalking:Animation;
	var animDeath:Animation;
	
	public function new() {
		super();
		
		speed = 1 / 4;
		
		// Stand- / Gehanimation
		
		animWalking = new Animation();
		animWalking.addFrame(Tobor.Tileset.find("SPR_CHARLIE_0"));
		animWalking.addFrame(Tobor.Tileset.find("SPR_CHARLIE_1"));
		animWalking.addFrame(Tobor.Tileset.find("SPR_CHARLIE_2"));
		
		animWalking.setSpeed(speed);
		
		// "Explositions"animation
		
		animDeath = new Animation();
		animDeath.addFrame(Tobor.Tileset.find("SPR_EXPLOSION_0"));
		animDeath.addFrame(Tobor.Tileset.find("SPR_EXPLOSION_1"));
		animDeath.addFrame(Tobor.Tileset.find("SPR_EXPLOSION_2"));
		animDeath.addFrame(Tobor.Tileset.find("SPR_EXPLOSION_3"));
		animDeath.addFrame(Tobor.Tileset.find("SPR_EXPLOSION_4"));
		
		animDeath.setSpeed(5);
		
		// aktuelle Animation setzen
		
		gfx = animWalking;
	}
	
	override public function update(deltaTime:Float) {
		super.update(deltaTime);
		
		if (!isAlive) {
			if (!animDeath.active) {
				isAlive = true;
				
				gfx = animWalking;
			}
		}
	}
	
	public function die() {
		lives--;
		
		if (!isMoving) {
			isAlive = false;
			
			gfx = animDeath;
			animDeath.start();
		}
	}
	
	override
	function onStartMoving() {
		animWalking.start();
	}
	
	override
	function onStopMoving() {
		animWalking.stop();
	}
	
	/*
	override
	public function draw() {
		// Gfx.drawTexture(x, y, 16, 12, anim.getUV());
	}
	*/
	
	override public function save():Map<String, Dynamic> {
		var out = super.save();
		
		out.set("lives", lives);
		out.set("gold", gold);
		out.set("points", points);
		
		return out;
	}
}