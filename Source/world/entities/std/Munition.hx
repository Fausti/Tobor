package world.entities.std;

import lime.math.Vector2;
import world.entities.EntityItem;

/**
 * ...
 * @author Matthias Faust
 */
class Munition extends EntityItem {
	var SPR_BULLET:Array<Sprite>;
	
	public function new() {
		super();
		
		SPR_BULLET = [];
		
		for (i in 0 ... 6) {
			SPR_BULLET.push(Gfx.getSprite(i * 16 + 144, 60));
		}
		
		setSprite(SPR_BULLET[type]);
	}
	
	override public function render() {
		setSprite(SPR_BULLET[type]);
		
		super.render();
	}
	
	override public function hasWeight():Bool {
		return false;
		// return (type == 5);
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		if (Std.is(e, Charlie)) {
			onPickup();
		} else if (Std.is(e, EntityAI)) {
			// if (!Direction.isDiagonal(direction)) {
				var bullet:Bullet = new Bullet();
				room.spawnEntity(x, y, bullet);
				bullet.move(direction, (Robot.SPEED) * 2);
			
				Sound.play(Sound.SND_SHOOT_BULLET);
				
				type = type - 1;
				if (type < 0) die();
			// }
		}
	}
	
	override public function onPickup() {
		var template = getTemplate();
			
		if (template != null) {
			// firstPickup Meldung
			if (!getInventory().hasSeen(getGroupID())) {
				getWorld().showPickupMessage(getGroupID() + "_PICKUP", false, function() {
					var points:Int = template.points;
					if (points > 0) getWorld().addPoints(points);
					getWorld().hideDialog();
				}, template.points);
			}
			
			var rest:Int = room.world.inventory.add(template.name, template.spr);
			
			if (rest != 0) {
				if (type != (rest - 1)) {
					type = rest - 1;
					Sound.play(Sound.SND_PICKUP_MISC);
					
					if (!getWorld().checkFirstUse("TOO_MUCH_MUNITION")) {
						getWorld().markFirstUse("TOO_MUCH_MUNITION");
						getWorld().showMessage("TXT_TOO_MUCH_MUNITION", false);
					}
				}
			} else {
				die();
				Sound.play(Sound.SND_PICKUP_MISC);
			}
		}
	}
}