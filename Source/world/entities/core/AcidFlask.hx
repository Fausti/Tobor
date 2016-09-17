package world.entities.core;

import world.entities.Message;
import world.entities.ObjectItem;

/**
 * ...
 * @author Matthias Faust
 */
class AcidFlask extends ObjectItem {

	public function new(?type:Int=0) {
		super(type);
		
		gfx = new Sprite(Tobor.Tileset.find("SPR_SAEURE_FLASCHE"));
	}
	
	override public function onUse(item:InventoryItem, inRoom:Room) {
		var msg:Message = new Message(this, "ACID_USE");
		
		room.sendMessage(msg);
		
		if (msg.answers > 0) {
			super.onUse(item, inRoom);
		}
	}
}