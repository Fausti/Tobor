package world.entities.std;

import world.InventoryItem;
import world.entities.EntityItem;
import world.ObjectFactory.ObjectTemplate;

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
	
	override public function onUse(item:InventoryItem, x:Float, y:Float) {
		if (type == 1) {
			var list = room.findEntityAround(x, y, ThermoPlate);
			var count:Int = 0;

			for (e in list) {
				if (e.type == 0) {
					e.type = 2;
					count++;
				} else if (e.type == 1) {
					var tp:ThermoPlate = cast e;
					tp.spawnIce();
					count++;
				}
			}
		
			if (count > 0) {
				removeFromInventory();
			
				var tmpl:ObjectTemplate = getFactory().findFromID("OBJ_BUCKET#0");
				if (tmpl != null) getInventory().add("OBJ_BUCKET#0", tmpl.spr, 1);
			}
		}
	}
}