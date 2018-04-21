package world.entities.std;

import world.entities.EntityDynamic;

/**
 * ...
 * @author Matthias Faust
 */
class Torch extends EntityDynamic {
	var SPR_OFF:Sprite;
	var SPR_ANIM:Array<Sprite>;
	
	var torchTime:Float = 10;
	var timeLeft:Float = 10;
	
	public function new() {
		super();
		
		SPR_OFF = Gfx.getSprite(80, 348);
		
		SPR_ANIM = [
			Gfx.getSprite(80 + 16, 348),
			Gfx.getSprite(80 + 32, 348)
		];
	}
	
	override public function render() {
		if (type == 0) {
			Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_OFF);
		} else {
			Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_ANIM[(timeLeft < (torchTime / 2))?0:1]);
			getWorld().game.addLight(x + 0.5, y + 0.5, 6 - (type / 4));
		}
	}
	
	override public function update(deltaTime:Float) {
		if (timeLeft > 0.0) {
			timeLeft = timeLeft - deltaTime;
			if (timeLeft < 0.0) {
				timeLeft = torchTime;
				if (type < 10 && type > 0) type++;
			}
		}
		if (type > 0 && timeLeft == 0.0) {
			timeLeft = torchTime;
		}
		
		super.update(deltaTime);
	}
}