package world.entities.core;

import world.Room;
import world.entities.Inventory.InventoryItem;
import world.entities.ObjectItem;

/**
 * ...
 * @author Matthias Faust
 */
class LifeElixir extends ObjectItem {

	public function new(?type:Int=0) {
		super(type);
		
		gfx = new Sprite(Tobor.Tileset.find("SPR_LEBEN"));
	}
	
	override public function onUse(item:InventoryItem, inRoom:Room) {
		if (player.lives < 3) {
			player.lives++;
			super.onUse(item, inRoom);
		}
	}
}