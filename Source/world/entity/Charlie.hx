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
	var anim:Animation;
	
	public function new() {
		super();
		
		anim = new Animation();
		anim.addFrame(Tobor.Tileset.tile(1, 0));
		anim.addFrame(Tobor.Tileset.tile(2, 0));
		anim.addFrame(Tobor.Tileset.tile(3, 0));
		
		anim.setSpeed(speed);
		
		gfx = anim;
	}
	
	override public function update(deltaTime:Float) {
		super.update(deltaTime);
		
		anim.update(deltaTime);
	}
	
	override
	function onStartMoving() {
		anim.start();
	}
	
	override
	function onStopMoving() {
		anim.stop();
	}
	
	/*
	override
	public function draw() {
		// Gfx.drawTexture(x, y, 16, 12, anim.getUV());
	}
	*/
}