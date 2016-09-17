package world.entities;

/**
 * ...
 * @author Matthias Faust
 */
class Inventory {
	public static inline var MAX_SIZE:Int = 32;
	
	var list:Array<InventoryItem> = [];
	public var length(get, null):Int;
	public var selected:Int = 0;
	
	public function new() {
			clear();
	}
	
	public function getAll():Array<InventoryItem> {
		return list;
	}
	
	public function clear() {
		while (list.length > 0) {
			list.pop();
		}
	}
	
	public function add(obj:ObjectItem, ?combine:Bool = true):Bool {
		if (obj == null) return false;
		
		if (combine) {
			var item:InventoryItem = find(obj.get_ID(), obj.type);
			if (item == null) {
				list.push(new InventoryItem(this, obj.get_ID(), obj.type));
				return true;
			} else {
				item.count++;
				return true;
			}
		} else {
			list.push(new InventoryItem(this, obj.get_ID(), obj.type));
			return true;
		}
		
		return true;
	}
	
	public function hasItem(id, ?type = 0):Bool {
		var item = find(id, type);
		
		if (item == null) {
			return false;
		} else {
			return true;
		}
	}
	
	public function find(id, type):InventoryItem {
		for (item in list) {
			if (item.category == id && item.type == type) {
				return item;
			}
		}
		
		return null;
	}
	
	public function remove(item:InventoryItem) {
		list.remove(item);
	}
	
	public function spawnObject(item:InventoryItem):ObjectItem {
		if (item == null) return null;
		
		var obj = EntityFactory.createFromID(item.category, item.type);
		
		return cast obj;
	}
	
	function get_length():Int {
		return list.length;
	}
	
	// Savegame
	
	public function save():Array<Dynamic> {
		var data:Array<Dynamic> = [];
		
		for (item in list) {
			// data.push(item.save);
		}
		
		return data;
	}
	
	public function load(data:Array<Dynamic>) {
		
	}
	
	public function toString():String {
		var str:String = "";
		
		for (item in list) {
			str += item + " ";
		}
		
		return str;
	}
}

class InventoryItem {
	public var category:String;
	public var type:Int;
	public var count:Int;
	
	private var inventory:Inventory;
	
	public function new(inv:Inventory, category:String, type:Int) {
		this.inventory = inv;
		
		this.category = category;
		this.type = type;
		this.count = 1;
	}
	
	public function add(?v:Int = 1) {
		count += v;
	}
	
	public function sub(?v:Int = 1) {
		count -= v;
		
		if (count <= 0) {
			inventory.remove(this);
		}
	}
	
	public function toString():String {
		var str:String = "[";
		
		str += count + "x " + category + "#" + type;
		
		return str + "]";
	}
}