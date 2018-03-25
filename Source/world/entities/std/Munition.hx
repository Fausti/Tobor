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
	
	override public function onEnter(e:Entity, direction:Vector2) {
		if (Std.is(e, Charlie)) {
			onPickup();
		} else if (Std.is(e, EntityAI)) {
			if (direction == Direction.N || direction == Direction.S || direction == Direction.W || direction == Direction.E) {
				var bullet:Bullet = new Bullet();
				room.spawnEntity(x, y, bullet);
				bullet.move(direction, Robot.SPEED * 2);
			
				Sound.play(Sound.SND_SHOOT_BULLET);
				
				type = type - 1;
				if (type < 0) die();
			}
		}
	}
	
	override public function onPickup() {
		var template = getTemplate();
			
		if (template != null) {
			var rest:Int = room.world.inventory.add(template.name, template.spr);
			
			if (rest != 0) {
				if (type != (rest - 1)) {
					type = rest - 1;
					Sound.play(Sound.SND_PICKUP_MISC);
				}
			} else {
				die();
				Sound.play(Sound.SND_PICKUP_MISC);
			}
		}
	}
}