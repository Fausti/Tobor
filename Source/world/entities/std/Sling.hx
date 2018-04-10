package world.entities.std;

import lime.math.Vector2;
import world.entities.Entity;
import world.entities.EntityItem;

/**
 * ...
 * @author Matthias Faust
 */
class Sling extends EntityItem {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(240, 60));
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		if (Std.is(e, Charlie)) {
			if (room.world.inventory.hasGroup("OBJ_MUNITION")) {
				room.world.inventory.removeMunition(1);
				
				var bullet:Bullet = new Bullet();
				room.spawnEntity(x, y, bullet);
				bullet.move(direction, (Bullet.BULLET_SPEED));
				
				Sound.play(Sound.SND_SHOOT_BULLET);
			} else {
				super.onEnter(e, direction);
			}
		}
	}
}