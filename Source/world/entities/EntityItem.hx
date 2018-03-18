package world.entities;

/**
 * ...
 * @author Matthias Faust
 */
class EntityItem extends EntityCollectable {

	public function new() {
		super();
	}
	
	override public function onPickup() {
		var template = getTemplate();
			
		if (template != null) {
			room.world.inventory.add(template.name, template.spr);
		}
	}
	
	public function onDrop(x:Float, y:Float) {
		room.spawnEntity(x, y, this);

		room.world.inventory.remove(getID());
	}
	
	public function onLook() {

	}
	
	public function onUse(x:Float, y:Float) {
		onDrop(x, y);
	}
	
}