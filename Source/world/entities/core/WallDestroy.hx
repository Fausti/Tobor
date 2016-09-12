package world.entities.core;

import world.entities.Entity;

/**
 * ...
 * @author Matthias Faust
 */
class WallDestroy extends Entity {
	var speed:Float = 20.0;
	var timeLeft:Float;
	
	// Animation
	var anim:Animation;
	
	public function new() {
		super();
		
		anim = new Animation();
		anim.addFrame(Tobor.Tileset.find("SPR_MAUER_AUFLOESEN_0"));
		anim.addFrame(Tobor.Tileset.find("SPR_MAUER_AUFLOESEN_1"));
		anim.addFrame(Tobor.Tileset.find("SPR_MAUER_AUFLOESEN_2"));
		anim.addFrame(Tobor.Tileset.find("SPR_MAUER_AUFLOESEN_3"));
		anim.addFrame(Tobor.Tileset.find("SPR_MAUER_AUFLOESEN_4"));
		
		anim.setSpeed(speed);
		anim.start();
		
		// aktuelle Animation setzen
		
		gfx = anim;
		
		timeLeft = speed;
		
		isStatic = false;
	}
	
	override public function update(deltaTime:Float) {
		super.update(deltaTime);
		
		timeLeft -= deltaTime;
		if (timeLeft <= 0.0) {
			destroy();
		}
	}
	
	override
	public function canEnter(e:Entity):Bool {
		return false;
	}
}