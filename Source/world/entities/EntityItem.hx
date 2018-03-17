package world.entities;
import lime.math.Vector2;
import world.Room;
import world.entities.Entity;
import world.entities.std.Charlie;

/**
 * ...
 * @author Matthias Faust
 */
class EntityItem extends EntityCollectable {
	// var group:String = null;
	
	public function new() {
		super();
	}
	
	override public function onPickup() {
		trace("onPickup -> " + this);
		
		var template = getTemplate();
			
		if (template != null) {
			room.world.inventory.add(template.name, template.spr);
		}
	}
	
	public function onDrop(room:Room, x:Float, y:Float) {
		trace("onDrop -> " + this);
		
		room.spawnEntity(x, y, this);
		
		var template = getTemplate();
		room.world.inventory.remove(template.name);
	}
	
	public function onLook() {
		trace("onLook -> " + this);
	}
	
	public function onUse(room:Room, x:Float, y:Float) {
		trace("onUse -> " + this);
		
		onDrop(room, x, y);
	}
	
}