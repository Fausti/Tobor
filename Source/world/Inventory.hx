package world;

import world.entities.Entity;
import world.entities.EntityItem;
import world.ObjectFactory.ObjectTemplate;

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
	public var seen:Map<String, Bool>;
	
	public var containsOverall:Bool = false;
	
	public function new() {
		for (i in 0 ... 6) {
			SPR_MUNITION.push(Gfx.getSprite(i * 16 + 144, 60));
		}
		
		clear();
	}
	
	public function clear() {
		list = new Map<String, InventoryItem>();
		seen = new Map<String, Bool>();
		
		containsOverall = false;
	}
	
	public function load(factory:ObjectFactory, data) {
		clear();
		
		for (key in Reflect.fields(data)) {
			var template:ObjectTemplate = factory.findFromID(key);
			
			if (template != null) {
				add(key, template.spr, Reflect.field(data, "count"), Reflect.field(data, "content"));
			} else {
				trace("Couldn't find inventory item: " + key);
			}
		}
	}
	
	public function save():Map<String, Dynamic> {
		var data:Map<String, Dynamic> = new Map<String, Dynamic>();
		
		for (key in list.keys()) {
			var item = list.get(key);
			
			var idata:Map<String, Dynamic> = new Map<String, Dynamic>();
			
			idata.set("content", item.content);
			idata.set("count", item.count);
			
			data.set(key, idata);
		}
		
		return data;
	}
	
	public function hasSeen(id:String):Bool {
		if (seen.get(id.split("#")[0]) == true) return true;
		return false;
	}
	
	public function add(id:String, spr:Sprite, ?count:Int = 1, ?content:String = null):Int {
		seen.set(id.split("#")[0], true);
		
		var item:InventoryItem = list.get(id);
		
		if (item == null) {
			item = new InventoryItem(id, spr, content);
			list.set(id, item);
		}
		
		item.add(count);
		
		if (id == "OBJ_OVERALL") containsOverall = true;
		
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
		
		if (id == "OBJ_OVERALL") {
			containsOverall = hasItem(id);
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
		e.content = item.content;
		e.setRoom(world.room);
		
		if (!Std.is(e, EntityItem)) {
			trace("Item is not an item!");
			return;
		}
		
		var obj:EntityItem = cast e; 
		
		switch(action) {
			case Inventory.ACTION_DROP:
				obj.onDrop(item, world.player.x, world.player.y);
			case Inventory.ACTION_LOOK:
				obj.onLook(item);
			case Inventory.ACTION_USE:
				obj.onUse(item, world.player.x, world.player.y);
			default:
				trace("Unknown Item Action!");
		}
	}
}