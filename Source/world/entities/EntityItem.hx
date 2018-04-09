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
		var canDrop:Bool = true;
		
		for (entity in room.getAllEntitiesAt(getPlayer().x, getPlayer().y, getPlayer())) {
			if (!entity.canEnter(this, Direction.NONE, 0)) canDrop = false;
		}
						
		if (canDrop) { 			
			room.spawnEntity(x, y, this);
		
			this.content = item.content;

			removeFromInventory();
		}
	}
	
	public function onLook(item:InventoryItem) {

	}
	
	public function onUse(item:InventoryItem, x:Float, y:Float) {
		onDrop(item, x, y);
	}
	
	public function removeFromInventory() {
		getInventory().remove(getID());
	}
	
	public function addToInventory(?num:Int = 1):Bool {
		var firstTime:Bool = false;
		var template = getTemplate();
			
		if (template != null) {
			if (!getInventory().hasSeen(template.name)) {
				firstTime = true;
				getWorld().showPickupMessage(template.name.split("#")[0] + "_PICKUP", false, function() {
					var points:Int = template.points;
					if (points > 0) getWorld().addPoints(points);
					getWorld().hideDialog();
				}, template.points);
			}
			
			getInventory().add(template.name, template.spr, num, content);
		}
		
		return firstTime; 
	}
	
}