package world.entities.std;

import world.entities.EntityDynamic;

/**
 * ...
 * @author Matthias Faust
 */
class AndroidEgg extends EntityDynamic {
	static var EGG_TIME:Int = 45; // 45
	
	var SPR_EGG:Array<Sprite>;
	var SPR_EGG_FINAL:Array<Sprite>;
	
	var timeLeft:Float = 1;
	
	public function new() {
		super();
		
		SPR_EGG = [];
		
		for (i in 0 ... 2) {
			for (j in 0 ... 2) {
				SPR_EGG.push(Gfx.getSprite(208 + i * Tobor.TILE_WIDTH, 216 + j * Tobor.TILE_HEIGHT));
			}
		}
		
		setSprite(SPR_EGG[0]);
		
		SPR_EGG_FINAL = [Gfx.getSprite(240, 276), Gfx.getSprite(240, 312)];
	}
	
	override public function update(deltaTime:Float) {
		timeLeft = timeLeft - deltaTime;
		if (timeLeft < 0) {
			timeLeft = 1;
			
			if (type > (EGG_TIME + Std.random(10)) && type < 100) {
				type = 100;
				setSprite(SPR_EGG_FINAL[0]);
			} else if (type == 100) {
				type = 101;
				setSprite(SPR_EGG_FINAL[1]);
			} else if (type == 101) {
				var android:Android = new Android();
				room.spawnEntity(x, y, android);
				
				die();
			} else {
				type++;
				setSprite(SPR_EGG[Std.random(4)]);
			}
		}
	}
}