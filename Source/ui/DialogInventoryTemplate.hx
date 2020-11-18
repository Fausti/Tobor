package ui;

import world.Inventory;
import world.InventoryItem;
import world.ObjectFactory.ObjectTemplate;

/**
 * ...
 * @author Matthias Faust
 */
class DialogInventoryTemplate extends Dialog {
	var SPR_NONE:Sprite;
	
	var inventory:Inventory;
	
	var rootGroup:Entry;
	var currentGroup:Entry;
	
	var index:Int = 0;
	var rootIndex:Int = 0;

	private var actions:Array<Int> = [];
	private var actionsString:Array<String> = [];
	
	private var actionsSize:Int = 0;
	private var actionIndex:Int = 0;
	
	public var STRINGS:Array<String> = [];
	
	public var selectedItem:Array<InventoryItem>;
	public var selectedAction:Int;
	
	public function new(screen:Screen, x:Int, y:Int, inv:Inventory) {
		super(screen, x, y);
		
		SPR_NONE = Gfx.getSprite(0, 0);
		
		inventory = inv;
		
		STRINGS[Inventory.ACTION_COUNT] = " " + GetText.get("TXT_INVENTORY_COUNT");
		STRINGS[Inventory.ACTION_USE] = GetText.get("TXT_INVENTORY_USE");
		STRINGS[Inventory.ACTION_DROP] = GetText.get("TXT_INVENTORY_DROP");
		STRINGS[Inventory.ACTION_LOOK] = GetText.get("TXT_INVENTORY_LOOK");
		STRINGS[Inventory.ACTION_CHOOSE] = GetText.get("TXT_INVENTORY_CHOOSE");
		STRINGS[Inventory.ACTION_DROP_ALL] = GetText.get("TXT_INVENTORY_DROP_ALL");
		STRINGS[Inventory.ACTION_CLONE] = GetText.get("TXT_INVENTORY_CLONE");
		STRINGS[Inventory.ACTION_MOD] = "+, -, Del, 0...9";
	}
	
	override public function show() {
		super.show();
		
		currentGroup = null;
		
		rootGroup = new Entry();
		rootGroup.group = null;
		
		for (i in inventory.list) {
			var group:Entry;
			group = getGroup(i.group);
			
			// noch keine Itemgruppe vorhanden? Anlegen!
			if (group == null) {
				group = new Entry();
				group.group = i.group;
				group.item = null;
				
				rootGroup.content.push(group);
			}
			
			var item:Entry = new Entry();
			item.group = i.group;
			item.item = i;
			
			group.content.push(item);
		}
		
		currentGroup = rootGroup;
		
		index = rootIndex;
		if (index >= currentGroup.size) index = currentGroup.size - 1;
		
		actions = [];
		actionsString = [];
	
		actionsSize = 0;
		actionIndex = 0;
		
		selectedItem = null;
		selectedAction = 0;
	
		// Sortieren!
		rootGroup.content.sort(function(a, b) {
			if (a.group > b.group) return 1;
			else if (a.group < b.group) return -1;
			
			return 0;
		});
		
		updateActions();
	}
	
	function getGroup(grp:String):Entry {
		for (i in rootGroup.content) {
			if (i.group == grp) return i;
		}
		
		return null;
	}
	
	override public function update(deltaTime:Float) {
		if (Input.isKeyDown(Tobor.KEY_ENTER)) {
			if (currentGroup == rootGroup) {
				rootIndex = index;
				
				if (!rootGroup.content[index].isSingle()) {
					if (rootGroup.content[index].group == "OBJ_MUNITION" && actions[actionIndex] == Inventory.ACTION_DROP_ALL) {
						selectedAction = Inventory.ACTION_DROP; // actions[actionIndex];
						selectedItem = [];
					
						for (itm in rootGroup.content[index].content) {
							var itm2 = itm.getItem();
							
							for (i in 0 ... itm2.count) {
								selectedItem.push(itm.getItem());
							}
						}
						
						ok();
					} else {
						currentGroup = rootGroup.content[index];
						index = 0;
					
						updateActions();
					}
					
					Input.wait(0.25);
					return;
				} else {
					selectedAction = actions[actionIndex];
					
					if (selectedAction == Inventory.ACTION_DROP_ALL) {
						selectedAction = Inventory.ACTION_DROP;
						
						selectedItem = [];
						
						var itm:InventoryItem = currentGroup.content[index].getItem();
						for (i in 0 ... itm.count) {
							selectedItem.push(itm);
						}
					} else {
						selectedItem = [currentGroup.content[index].getItem()];
					}
					
					ok();
					Input.wait(0.25);
					return;
				}
			} else {
				selectedAction = actions[actionIndex];
				selectedItem = [currentGroup.content[index].item];
					
				ok();
				Input.wait(0.25);
				return;
			}
		} else if (Input.isKeyDown(Tobor.KEY_ESC)) {
			if (currentGroup == rootGroup) {
				rootIndex = index;
				exit();
			} else {
				currentGroup = rootGroup;
				index = 0;
					
				updateActions();
				Input.wait(0.25);
			}
		} else if (Input.isKeyDown(Tobor.KEY_LEFT)) {
			index--;
			if (index < 0) index = 0;
			
			updateActions();
			
			Input.wait(0.25);
		} else if (Input.isKeyDown(Tobor.KEY_RIGHT)) {
			index++;
			if (index >= currentGroup.size) index = currentGroup.size - 1;
			
			updateActions();
			
			Input.wait(0.25);
		} else if (Input.isKeyDown(Tobor.KEY_UP)) {
			Input.wait(0.25);
			
			add(1);
		} else if (Input.isKeyDown(Tobor.KEY_DOWN)) {
			Input.wait(0.25);
			
			add( -1);
		} else if (Input.isKeyDown([KeyCode.DELETE, KeyCode.NUMBER_0, KeyCode.NUMPAD_0])) {
			Input.wait(0.25);
			
			set(0);
			updateActions();
		} else if (Input.isKeyDown([KeyCode.NUMBER_1 ,  KeyCode.NUMPAD_1])) {
			Input.wait(0.25);
			
			set(1);
			updateActions();
		} else if (Input.isKeyDown([KeyCode.NUMBER_2 ,  KeyCode.NUMPAD_2])) {
			Input.wait(0.25);
			
			set(2);
			updateActions();
		} else if (Input.isKeyDown([KeyCode.NUMBER_3 ,  KeyCode.NUMPAD_3])) {
			Input.wait(0.25);
			
			set(3);
			updateActions();
		} else if (Input.isKeyDown([KeyCode.NUMBER_4 ,  KeyCode.NUMPAD_4])) {
			Input.wait(0.25);
			
			set(4);
			updateActions();
		} else if (Input.isKeyDown([KeyCode.NUMBER_5 ,  KeyCode.NUMPAD_5])) {
			Input.wait(0.25);
			
			set(5);
			updateActions();
		} else if (Input.isKeyDown([KeyCode.NUMBER_6 ,  KeyCode.NUMPAD_6])) {
			Input.wait(0.25);
			
			set(6);
			updateActions();
		} else if (Input.isKeyDown([KeyCode.NUMBER_7 ,  KeyCode.NUMPAD_7])) {
			Input.wait(0.25);
			
			set(7);
			updateActions();
		} else if (Input.isKeyDown([KeyCode.NUMBER_8 ,  KeyCode.NUMPAD_8])) {
			Input.wait(0.25);
			
			set(8);
			updateActions();
		} else if (Input.isKeyDown([KeyCode.NUMBER_9 ,  KeyCode.NUMPAD_9])) {
			Input.wait(0.25);
			
			set(9);
			updateActions();
		}
	}
	
	function add(v:Int) {
		if (v < 0 && currentGroup.content[index].getItem().count < 1) return;
		
		if (currentGroup == rootGroup) {
			if (!currentGroup.content[index].isSingle()) return;
		}
		
		currentGroup.content[index].getItem().count += v;
		updateActions();
	}
	
	function set(v:Int) {
		if (currentGroup == rootGroup) {
			if (!currentGroup.content[index].isSingle()) {
				currentGroup.content[index].getItem().count = v;
				
				for (itm in currentGroup.content[index].content) {
					itm.getItem().count = v;
				}
			} else {
				currentGroup.content[index].getItem().count = v;
			}
		} else {
			currentGroup.content[index].getItem().count = v;
		}
		
		updateActions();
	}
	
	override public function render() {
		super.render();
		
		// Dialog.drawBackground(0, 0, 40 * 16, 12, Color.GREEN);
		Gfx.drawTexture(x, y, 40 * Tobor.TILE_WIDTH, Tobor.TILE_HEIGHT, SPR_NONE.uv, Color.GREEN);
		
		var offsetX:Int = 320;
		var iconX:Int;
		
		if (currentGroup != null) {
			var pos:Int = 0;
			
			offsetX = offsetX - currentGroup.size * 8;
			iconX = offsetX;	
			
			for (i in currentGroup.content) {
				var renderCount:Int = i.getItem().count;
				
				if (!i.isSingle() && rootGroup == currentGroup) {
					renderCount = 0;
					
					for (ii in i.content) {
						renderCount = renderCount + ii.count();
					}
				}
				
				if (pos == index) {
					Gfx.drawSprite(iconX, 0, SPR_NONE, Color.BLACK);
				} else {
					if (renderCount <= 0) {
						Gfx.drawSprite(iconX, 0, SPR_NONE, Color.RED);
					} else {
						Gfx.drawSprite(iconX, 0, SPR_NONE, Color.WHITE);
					}
				}
				
				Gfx.drawSprite(iconX, 0, i.getSprite());
			
				if (renderCount > 0) {
					if (currentGroup == rootGroup && !i.isSingle()) {
						Tobor.fontSmall.drawString(iconX, 1, "*", Color.DARK_BLUE);
						Tobor.fontSmall.drawString(iconX + 1, 2, "*", Color.GREEN);
					} else {
						Tobor.fontSmall.drawString(iconX, 1, Std.string(renderCount), Color.DARK_BLUE);
						Tobor.fontSmall.drawString(iconX + 1, 2, Std.string(renderCount), Color.GREEN);
					}
				}
				
				iconX = iconX + 16;
				pos++;
			}
		}
		
		offsetX = offsetX + 16 * index;
		drawPopupMenu(offsetX, 12 + Tobor.frameSmall.sizeY);
	}
	
	function drawPopupMenu(offsetX:Int, offsetY:Int) {
		Tobor.frameSmall.drawBox(offsetX, 12, actionsSize + 2, actions.length + 2);
		
		var index:Int = 0;
		for (action in actionsString) {
			// trace(action);
			if (action != null) {
				if (actionIndex == index) {
					Tobor.fontSmall.drawString(offsetX + Tobor.frameSmall.sizeX, offsetY, action, Color.YELLOW, Color.BLACK);
				} else {
					Tobor.fontSmall.drawString(offsetX + Tobor.frameSmall.sizeX, offsetY, action, Color.BLACK);
				}
			}
			
			offsetY += 10;
			index++;
		}
	}
	
	inline function isRoot():Bool {
		return currentGroup == rootGroup;
	}
	
	function updateActions() {
		actions = [];
		actionsString = [];
		
		var itm = currentGroup.content[index];
		
		if (isRoot()) {
			if (itm.isSingle()) {
				actions.push(Inventory.ACTION_COUNT);
				// actions.push(Inventory.ACTION_MOD);
			} else {
				actions.push(Inventory.ACTION_CHOOSE);
			}
		} else {
			actions.push(Inventory.ACTION_COUNT);
			//actions.push(Inventory.ACTION_MOD);
		}
		
		actionsSize = 0;
		
		for (line in actions) {
			switch(line) {
				case Inventory.ACTION_COUNT:
					var strCount:String = "" + (currentGroup.content[index].count()) + STRINGS[Inventory.ACTION_COUNT];
					actionsSize = Std.int(Math.max(actionsSize, strCount.length));
					actionsString.push(strCount);
				default:
					actionsString.push(STRINGS[line]);
					actionsSize = Std.int(Math.max(actionsSize, STRINGS[line].length));
			}
		}
		
		for (i in 0 ... actionsString.length) {
			actionsString[i] = actionsString[i].rpad(" ", actionsSize);
		}
		
		actionIndex = 0;
		if (actions[actionIndex] == Inventory.ACTION_COUNT) actionIndex++;
		
		// trace(actionsString);
	}
}

private class Entry {
	public var group:String = null;
	public var content:Array<Entry> = [];
	public var item:InventoryItem = null;
	
	public function new() {

	}
	
	public function getItem():InventoryItem {
		if (item != null) return item;
		if (content[0] != null) return content[0].getItem();
		return null;
	}
	
	public function getSprite():Sprite {
		if (item != null) return item.spr;
		
		return content[0].getSprite();
	}
	
	public function isSingle():Bool {
		if (content.length == 1) return true;
		return false;
	}
	
	public var size(get, null):Int;
	function get_size():Int {
		return content.length;
	}
	
	public function count():Int {
		if (item != null) return item.count;
		if (content[0] != null) return content[0].count();
		return 0;
	}
}