package world.entities;
import world.InventoryItem;

/**
 * ...
 * @author Matthias Faust
 */
class EntityItem extends EntityCollectable {

	public function new() {
		super();
	}
	
	override public function onPickup() {
		addToInventory();
		
		Sound.play(Sound.SND_PICKUP_MISC);
	}
	
	public function onDrop(item:InventoryItem, x:Float, y:Float) {
		room.spawnEntity(x, y, this);
		
		this.content = item.content;

		removeFromInventory();
	}
	
	public function onLook(item:InventoryItem) {

	}
	
	public function onUse(item:InventoryItem, x:Float, y:Float) {
		onDrop(item, x, y);
	}
	
	public function removeFromInventory() {
		getInventory().remove(getID());
	}
	
	public function addToInventory(?num:Int = 1) {
		var template = getTemplate();
			
		if (template != null) {
			if (!getInventory().hasSeen(template.name)) {
				getWorld().showMessage(template.name.split("#")[0] + "_DESC");
			}
			
			getInventory().add(template.name, template.spr, num, content);
		}
	}
	
}