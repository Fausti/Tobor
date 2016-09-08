package world.entity;

import gfx.Animation;
import gfx.Gfx;
import lime.math.Rectangle;
import lime.math.Vector2;
/**
 * ...
 * @author Matthias Faust
 */
class Charlie extends EntityMoveable {
	
	// Animation
	var animWalking:Animation;
	var animDeath:Animation;
	
	public function new() {
		super();
		
		speed = 1 / 4;
		
		// Stand- / Gehanimation
		
		animWalking = new Animation();
		animWalking.addFrame(Tobor.Tileset.find("Charlie_0"));
		animWalking.addFrame(Tobor.Tileset.find("Charlie_1"));
		animWalking.addFrame(Tobor.Tileset.find("Charlie_2"));
		
		animWalking.setSpeed(speed);
		
		// "Explositions"animation
		
		animDeath = new Animation();
		animDeath.addFrame(Tobor.Tileset.find("Explosion_0"));
		animDeath.addFrame(Tobor.Tileset.find("Explosion_1"));
		animDeath.addFrame(Tobor.Tileset.find("Explosion_2"));
		animDeath.addFrame(Tobor.Tileset.find("Explosion_3"));
		animDeath.addFrame(Tobor.Tileset.find("Explosion_4"));
		
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
}