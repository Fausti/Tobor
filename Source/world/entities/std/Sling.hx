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
				
				if (getWorld().checkFirstUse("USED_SLING")) {
					
				} else {
					getWorld().markFirstUse("USED_SLING");
					getWorld().showPickupMessage("OBJ_SLING_USE", false, function () {
						getWorld().addPoints(3000);
						getWorld().hideDialog();
					}, 3000);
				}
			} else {
				super.onEnter(e, direction);
			}
		}
	}
}