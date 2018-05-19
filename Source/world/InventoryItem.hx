package world;

/**
 * ...
 * @author Matthias Faust
 */
class InventoryItem {
	private var inventory:Inventory;
	
	public var count:Int = 0;

	public var group:String;
	public var id:String;
	
	public var spr:Sprite;
	
	public var content:String;
		
	public function new(id:String, spr:Sprite, content:String = null) {
		this.id = id;
		this.spr = spr;
		this.content = content;
		
		var split = id.split("#");
		
		if (split.length > 1) {
			this.group = split[0];
		} else {
			this.group = id;
		}
	}
	
	public function add(v:Int) {
		count = count + v;
	}
	
	public function toString():String {
		return group + " -> " + id + ": " + count + "x ";
	}
}