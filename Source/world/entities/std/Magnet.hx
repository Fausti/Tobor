package world.entities.std;

import world.entities.EntityItem;

/**
 * ...
 * @author Matthias Faust
 */
class Magnet extends EntityItem {
	var SPR_MAGNET_0:Sprite;
	var SPR_MAGNET_1:Sprite;
	
	public function new() {
		super();
		
		SPR_MAGNET_0 = Gfx.getSprite(224, 12);
		SPR_MAGNET_1 = Gfx.getSprite(240, 12);
	}
	
	override public function render() {
		if (type == 0) {
			setSprite(SPR_MAGNET_0);
		} else {
			setSprite(SPR_MAGNET_1);
		}
		
		super.render();
	}
	
	override public function onDrop(x:Float, y:Float) {
		if (room.findEntityAt(x, y, Magnet).length == 0) {
			var rotated:Int = 0;
			
			for (e in room.findEntityAround(x, y, Arrow)) {
				var arrow:Arrow = cast e;
			
				if (arrow.x == x || arrow.y == y) {
					
					rotated++;
					
					switch(type) {
						case 0:
							if (arrow.y < y) arrow.type = 1;
							else if (arrow.y > y) arrow.type = 3;
							else if (arrow.x < x) arrow.type = 2;
							else if (arrow.x > x) arrow.type = 0;
						case 1:
							if (arrow.y < y) arrow.type = 3;
							else if (arrow.y > y) arrow.type = 1;
							else if (arrow.x < x) arrow.type = 0;
							else if (arrow.x > x) arrow.type = 2;
					}
				}
			}
		
			super.onDrop(x, y);
			if (rotated > 0) Sound.play(Sound.SND_ROTATE_ARROW);
		}
	}
	
	override public function onPickup() {
		addToInventory();
		
		Sound.play(Sound.SND_PICKUP_KEY);
		
		for (e in room.findEntityAround(x, y, Arrow)) {
			var arrow:Arrow = cast e;
			
			if (arrow.x == x || arrow.y == y) {
				switch(type) {
					case 0:
						arrow.rotate(1);
					case 1:
						arrow.rotate(-1);
				}
			}
		}
	}
}