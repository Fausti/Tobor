package world.entities.std;

import world.entities.EntityItem;

/**
 * ...
 * @author Matthias Faust
 */
class Bucket extends EntityItem {
	var SPR_BUCKET_0:Sprite;
	var SPR_BUCKET_1:Sprite;
	
	public function new() {
		super();
		
		SPR_BUCKET_0 = Gfx.getSprite(144, 156);
		SPR_BUCKET_1 = Gfx.getSprite(160, 156);
	}
	
	override public function render() {
		if (type == 0) {
			setSprite(SPR_BUCKET_0);
		} else {
			setSprite(SPR_BUCKET_1);
		}
		
		super.render();
	}
	
	override public function hasWeight():Bool {
		return (type == 1);
	}
}