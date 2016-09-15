package world.entities;

/**
 * ...
 * @author Matthias Faust
 */
class InventoryItem {
	var itemCat:String;
	var itemType:Int;
	var itemCount:Int = 0;

	public function new(?object:ObjectPickup = null) {
		if (object != null) {
			var id:Int = EntityFactory.findIDFromObject(object);
			var def:EntityTemplate = EntityFactory.table[id];
		
			if (def != null) {
				itemCat = def.name;
				itemType = object.type;
				itemCount = 1;
			}
		}
	}
	
	// SAVEGAME
	
	public function save():Array<Dynamic> {
		return [];
	}
	
	public function load(data:Array<Dynamic>) {
		
	}
	
	public function toString():String {
		return "" + itemCount + "x " + itemCat + "#" + itemType;
	}
}