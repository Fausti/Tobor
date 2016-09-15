package world.entities;

/**
 * ...
 * @author Matthias Faust
 */
class Inventory {
	public static inline var MAX_SIZE:Int = 32;
	
	var list:Array<InventoryItem> = [];
	public var length(get, null):Int;
	
	public function new() {
			clear();
	}
	
	public function clear() {
		for (item in list) {
			list.pop();
		}
	}
	
	public function add(o:ObjectPickup):Bool {
		if (length <= MAX_SIZE - 1) {
			list.push(new InventoryItem(o));
			return true;
		}
		
		return false;
	}
	
	public function get(index:Int):InventoryItem {
		if (index >= length) return null;
		
		return list[index];
	}
	
	function get_length():Int {
		return list.length;
	}
	
	// Savegame
	
	public function save():Array<Dynamic> {
		var data:Array<Dynamic> = [];
		
		for (item in list) {
			data.push(item.save);
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