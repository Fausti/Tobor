package world.entities.std;

import world.InventoryItem;
import world.entities.EntityItem;

/**
 * ...
 * @author Matthias Faust
 */
class ExclamationMark extends EntityItem {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(192, 12));
	}
	
	override public function onUse(item:InventoryItem, x:Float, y:Float):Void {
		getWorld().showItemHelp();
	}
}