package world.entities.core;

import world.Room;
import world.entities.Inventory.InventoryItem;
import world.entities.Message;
import world.entities.Object;
import world.entities.ObjectItem;

/**
 * ...
 * @author Matthias Faust
 */
class Magnet extends ObjectItem {
	var SPRITES:Array<Sprite>;
	
	public function new(?type:Int=0) {
		super(type);
		
		SPRITES = [
			new Sprite(Tobor.Tileset.find("SPR_MAGNET_0")),
			new Sprite(Tobor.Tileset.find("SPR_MAGNET_1"))
		];
		
		updateSprite();
	}
	
	function updateSprite() {
		gfx = SPRITES[type];
	}
	
	override public function onPickup(e:Object) {
		room.sendMessage(new Message(this, "MAGNET_PICKUP"));
		
		super.onPickup(e);
	}
	override public function onUse(item:InventoryItem, inRoom:Room) {
		super.onDrop(item, inRoom);
		
		room.sendMessage(new Message(this, "MAGNET_DROP"));
	}
}