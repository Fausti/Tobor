package world.entities.std;

import world.entities.interfaces.IElectric;

/**
 * ...
 * @author Matthias Faust
 */
class Shooter extends EntityDynamic implements IElectric {
	var SPR_SHOOTER:Array<Sprite>;
	var SPR_RELOAD:Array<Sprite>;
	var reloadTime:Float = 0.0;
	
	public function new() {
		super();
		
		SPR_SHOOTER = [];
		SPR_RELOAD = [];
		for (i in 0 ... 4) {
			SPR_SHOOTER.push(Gfx.getSprite(80 + i * 16, 336));
			SPR_RELOAD.push(Gfx.getSprite(144 + i * 16, 336));
		}
		
		z = Room.LAYER_OVERLAY;
	}
	
	override public function update(deltaTime:Float) {
		if (reloadTime > 0) {
			reloadTime = reloadTime - deltaTime;
			
			if (reloadTime < 0) reloadTime = 0.0;
		}
	}
	
	override public function render() {
		if (reloadTime == 0.0) {
			Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_SHOOTER[type]);
		} else {
			Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_RELOAD[type]);
		}
	}
	
	override public function switchStatus() {
		if (reloadTime != 0.0) return;
		
		var bullet:Bullet = new Bullet();
		room.spawnEntity(x, y, bullet);
		
		switch(type) {
			case 0:
				bullet.move(Direction.S, (Bullet.BULLET_SPEED));
			case 1:
				bullet.move(Direction.W, (Bullet.BULLET_SPEED));
			case 2:
				bullet.move(Direction.N, (Bullet.BULLET_SPEED));
			case 3:
				bullet.move(Direction.E, (Bullet.BULLET_SPEED));
		}
				
		Sound.play(Sound.SND_SHOOT_BULLET);
		
		reloadTime = (Charlie.PLAYER_SPEED) / 15.0;
	}
}