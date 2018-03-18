package world;
import world.entities.Entity;
import world.entities.EntityItem;

/**
 * ...
 * @author Matthias Faust
 */
class Inventory {
	public static inline var ACTION_COUNT 	= 0;
	public static inline var ACTION_USE 	= 1;
	public static inline var ACTION_DROP	= 2;
	public static inline var ACTION_LOOK	= 3;
	public static inline var ACTION_CHOOSE 	= 4;
	
	public var list:Map<String, InventoryItem>;
	
	public function new() {
		clear();
	}
	
	public function clear() {
		list = new Map<String, InventoryItem>();
	}
	
	public function add(id:String, spr:Sprite, ?count:Int = 1) {
		var item:InventoryItem = list.get(id);
		
		if (item == null) {
			item = new InventoryItem(id, spr);
			list.set(id, item);
		}
		
		item.add(1);
	}
	
	public function remove(id:String, ?count:Int = 1) {
		var item:InventoryItem = list.get(id);
		
		if (item != null) {
			item.count = item.count - 1;
			if (item.count <= 0) {
				list.remove(id);
			}
		}
	}
	
	public function hasItem(id:String):Bool {
		var item:InventoryItem = list.get(id);
		
		return item != null;
	}
	
	public var size(get, null):Int;
	function get_size():Int {
		return Lambda.count(list);
	}
	
	public function doItemAction(world:World, action:Int, item:InventoryItem) {
		if (item == null) {
			trace("Inventory item is NULL!");
			return;
		}
		
		var e:Entity = world.factory.create(item.id);
		e.setRoom(world.room);
		
		if (!Std.is(e, EntityItem)) {
			trace("Item is not an item!");
			return;
		}
		
		var obj:EntityItem = cast e; 
		
		switch(action) {
			case Inventory.ACTION_DROP:
				obj.onDrop(world.player.x, world.player.y);
			case Inventory.ACTION_LOOK:
				obj.onLook();
			case Inventory.ACTION_USE:
				obj.onUse(world.player.x, world.player.y);
			default:
				trace("Unknown Item Action!");
		}
	}
}