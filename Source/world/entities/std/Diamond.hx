package world.entities.std;

import world.entities.EntityCollectable;

/**
 * ...
 * @author Matthias Faust
 */
class Diamond extends EntityCollectable {
	var SPR_DIAMOND_0:Sprite;
	var SPR_DIAMOND_1:Sprite;
	
	public function new() {
		super();
	
		SPR_DIAMOND_0 = Gfx.getSprite(160, 24);
		SPR_DIAMOND_1 = Gfx.getSprite(176, 24);
	}
	
	override public function render() {
		switch(type) {
			case 0:
				Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_DIAMOND_0);
			case 1:
				Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_DIAMOND_1);
		}
	}
	
	override public function onPickup() {
		super.onPickup();
		
		getWorld().addPoints(5000);
		
		if (!getWorld().checkFirstUse("COLLECT_DIAMOND")) {
			getWorld().markFirstUse("COLLECT_DIAMOND");
			getWorld().showPickupMessage("OBJ_DIAMOND_PICKUP", false, function () {
				getWorld().addPoints(1000);
				getWorld().hideDialog();
			}, 1000);
		}
	}
}