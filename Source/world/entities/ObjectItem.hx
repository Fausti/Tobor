package world.entities;

import world.Room;
import world.entities.Inventory.InventoryItem;
import world.entities.Object;
import world.entities.core.Charlie;

/**
 * ...
 * @author Matthias Faust
 */
class ObjectItem extends ObjectDynamic {
	public function new(?type:Int = 0) {
		super(type);
	}
	
	override public function onEnter(e:Object) {
		if (isPlayer(e)) {
			if (room.world.player.inventory.add(this)) {
				onPickup(e);
				destroy();
			} else {
				trace("Inventar ist voll!");
			}
		}
		
		super.onEnter(e);
	}
	
	public function onPickup(e:Object) {
		
	}
	
	public function getCategory():String {
		return null;
	}
	
	public function getType():Int {
		return -1;
	}
	
	public function onDrop(item:InventoryItem, inRoom:Room) {
		this.room.add(this);
		
		item.sub();
	}
	
	public function onUse(item:InventoryItem, inRoom:Room) {
		item.sub();
	}
}