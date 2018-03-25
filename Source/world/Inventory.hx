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
	
	private var MAX_MUNITION:Int = 21;
	private var SPR_MUNITION:Array<Sprite> = [];
	
	public var list:Map<String, InventoryItem>;
	
	public function new() {
		for (i in 0 ... 6) {
			SPR_MUNITION.push(Gfx.getSprite(i * 16 + 144, 60));
		}
		
		clear();
	}
	
	public function clear() {
		list = new Map<String, InventoryItem>();
	}
	
	public function add(id:String, spr:Sprite, ?count:Int = 1):Int {
		var item:InventoryItem = list.get(id);
		
		if (item == null) {
			item = new InventoryItem(id, spr);
			list.set(id, item);
		}
		
		item.add(count);
		
		if (id.contains("OBJ_MUNITION")) {
			return sortMunition(countMunition());
		}
		
		return 0;
	}
	
	public function remove(id:String, ?count:Int = 1) {
		var item:InventoryItem = list.get(id);
		
		if (item != null) {
			item.count = item.count - count;
			if (item.count <= 0) {
				list.remove(id);
			}
		}
	}
	
	public function hasItem(id:String):Bool {
		var item:InventoryItem = list.get(id);
		
		return item != null;
	}
	
	// Munition...
	
	public function hasGroup(grp:String):Bool {
		if (getGroup(grp).length > 0) return true;
		
		return false;
	}
	
	public function getGroup(grp:String):Array<InventoryItem> {
		var retList:Array<InventoryItem> = [];
		
		for (i in list) {
			if (i.group == grp) retList.push(i);
		}
		
		return retList;
	}
	
	public function countMunition():Int {
		var count:Int = 0;
		
		var all:Array<InventoryItem> = getGroup("OBJ_MUNITION");
		
		for (m in all) {
			count = count + (m.count * (Std.parseInt(m.id.split('#')[1]) + 1));
		}
		
		return count;
	}
	
	public function removeMunition(count:Int) {
		var have:Int = countMunition();
		
		if (have < count) {
			sortMunition(0);
		} else {
			sortMunition(have - count);
		}
	}
	
	public function sortMunition(count:Int):Int {
		var all:Array<InventoryItem> = getGroup("OBJ_MUNITION");
		
		for (bullet in all) {
			remove(bullet.id, bullet.count);
		}
		
		var rest:Int = 0;
		if (count > MAX_MUNITION) {
			rest = count - MAX_MUNITION;
			count = MAX_MUNITION;
		}
		
		for (i in 0 ... 6) {
			var stackSize:Int = 6 - i;
			var stackCount:Int = Math.floor(count / stackSize);
			
			if (stackCount >= 1) {
				count = count - stackSize * stackCount;
			
				var itemID:String = "OBJ_MUNITION#" + (stackSize - 1);
				var itemSPR:Sprite = SPR_MUNITION[stackSize - 1];
				var item:InventoryItem = new InventoryItem(itemID, itemSPR);
				
				list.set(itemID, item);
				item.add(stackCount);
			}
		}
		
		return rest;
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