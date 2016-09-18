package dialog;

import gfx.Color;
import gfx.Gfx;
import haxe.Utf8;
import lime.math.Rectangle;
import screens.Screen;
import world.EntityFactory;
import world.entities.Inventory;

/**
 * ...
 * @author Matthias Faust
 */
class DialogInventory extends Dialog {
	private var inventory:Inventory;
	
	private var hasSign:Bool = false;
	
	private var menus:Map<String, Array<InventoryItem>>;
	private var cats:Array<String>;
	private var mainIndex:Int = 0;
	
	private var subMenu:Array<InventoryItem> = null;
	private var subIndex:Int = 0;
	
	private var actions:Array<String> = [];
	private var actionsString:Array<String> = [];
	
	private var actionsSize:Int = 0;
	private var actionIndex:Int = 0;
	
	public var item:InventoryItem;
	public var action:String;
	
	var UI_NONE:Rectangle;
	
	public function new(screen:Screen, x:Int, y:Int, inventory:Inventory) {
		super(screen, x, y);
		
		this.inventory = inventory;
		
		UI_NONE = Tobor.Tileset.find("SPR_NONE");
		
		menus = new Map();
		cats = [];
	}
	
	override public function show() {
		super.show();
		
		item = null;
		action = null;
		
		for (key in menus.keys()) {
			menus.remove(key);
		}
		
		hasSign = false;
		
		for (item in inventory.getAll()) {
			if (item.category == "OBJ_AUSRUFEZEICHEN") hasSign = true;
			
			if (menus.exists(item.category)) {
				menus.get(item.category).push(item);
			} else {
				menus.set(item.category, [item]);
			}
		}
		
		cats = [];
		for (key in menus.keys()) {
			cats.push(key);
		}
		
		if (mainIndex >= cats.length) mainIndex = 0;
		subMenu = null;
		
		updateActions();
	}
	
	public static inline var ACTION_COUNT:String = "COUNT";
	public static inline var ACTION_USE:String = "USE";
	public static inline var ACTION_DROP:String = "DROP";
	public static inline var ACTION_LOOK:String = "LOOK";
	public static inline var ACTION_CHOOSE:String = "CHOOSE";
	
	public static var STRINGS = [
		ACTION_COUNT => " Stück",
		ACTION_USE => "Benutzen",
		ACTION_DROP => "Ablegen",
		ACTION_LOOK => "Anschauen",
		ACTION_CHOOSE => "Auswählen"
	];
	
	function updateActions() {
		actions = [];
		actionsString = [];
		
		if (subMenu == null) {
			if (menus.get(cats[mainIndex]).length == 1) {
				if (menus.get(cats[mainIndex])[0].count > 1) actions.push(ACTION_COUNT);
			
				actions.push(ACTION_USE);
				actions.push(ACTION_DROP);
			
				if (hasSign) actions.push(ACTION_LOOK);
			} else {
				actions.push(ACTION_CHOOSE);
			}
		} else {
			var cat = menus.get(cats[mainIndex]);
			
			if (cat[subIndex].count > 1) actions.push(ACTION_COUNT);
			
			actions.push(ACTION_USE);
			actions.push(ACTION_DROP);
			
			if (hasSign) actions.push(ACTION_LOOK);
		}
		
		actionsSize = 0;
		
		for (line in actions) {
			switch(line) {
				case ACTION_COUNT:
					var strCount:String = Utf8.decode(menus.get(cats[mainIndex])[subIndex].count + STRINGS[ACTION_COUNT]);
					actionsSize = Std.int(Math.max(actionsSize, strCount.length));
					actionsString.push(strCount);
				default:
					actionsString.push(Utf8.decode(STRINGS[line]));
					actionsSize = Std.int(Math.max(actionsSize, Utf8.decode(STRINGS[line]).length));
			}
		}
		
		actionIndex = 0;
		if (actions[actionIndex] == ACTION_COUNT) actionIndex++;
		
		// trace(actionsString);
	}
	
	override public function update(deltaTime:Float) {
		if (inventory == null) exit();
		
		super.update(deltaTime);
		
		if (Input.keyDown(Input.LEFT)) {
			Input.wait(0.25);
			
			if (subMenu == null) {
				mainIndex--;
				if (mainIndex < 0) mainIndex = 0;
				updateActions();
			} else {
				subIndex--;
				if (subIndex < 0) subIndex = 0;
				updateActions();
			}
			
		} else if (Input.keyDown(Input.RIGHT)) {
			Input.wait(0.25);
			
			if (subMenu == null) {
				mainIndex++;
				if (mainIndex >= cats.length) mainIndex = cats.length - 1;
				updateActions();
			} else {
				subIndex++;
				if (subIndex >= subMenu.length) subIndex = subMenu.length - 1;
				updateActions();
			}
		} else if (Input.keyDown(Input.DOWN)) {
			Input.wait(0.25);
			
			actionIndex++;
			
			if (actionIndex >= actions.length) actionIndex = actions.length - 1;
			if (actions[actionIndex] == ACTION_COUNT) actionIndex++;
		} else if (Input.keyDown(Input.UP)) {
			Input.wait(0.25);
			
			actionIndex--;
			if (actionIndex < 0) actionIndex = 0;
			if (actions[actionIndex] == ACTION_COUNT) actionIndex++;
		} else if (Input.keyDown(Input.ENTER)) {
			Input.wait(0.25);
			
			if (subMenu == null) {
				if (menus.get(cats[mainIndex]).length == 1) {
					var item = menus.get(cats[mainIndex])[0];
					trace(actions[actionIndex], item);
					exitWith(item, actions[actionIndex]);
				} else {
					subMenu = menus.get(cats[mainIndex]);
					subIndex = 0;
					
					updateActions();
				}
			} else {
				var item = menus.get(cats[mainIndex])[subIndex];
				trace(actions[actionIndex], item);
				exitWith(item, actions[actionIndex]);
				exit();
			}
		} else if (Input.keyDown(Input.ESC)) {
			if (subMenu == null) {
				exit();
			} else {
				subMenu = null;
				updateActions();
			}
			
			Input.wait(0.25);
		}
	}
	
	override public function render() {
		super.render();
		
		Dialog.drawBackground(0, 0, 40 * 16, 12, Color.GREEN);
		
		var offsetX:Int = 320;
		
		if (subMenu == null) {
			offsetX = offsetX - cats.length * 8;
			
			Dialog.drawBackground(offsetX, 0, cats.length * 16, 12, Color.WHITE);
		
			var iconX:Int = offsetX;
			var icon:Rectangle;
			var index:Int = 0;
			
			for (cat in cats) {
				var e = EntityFactory.getfromKey(cat);
			
				if (index == mainIndex) Gfx.drawRect(iconX, 0, UI_NONE, Color.BLACK);
				Gfx.drawRect(iconX, 0, Tobor.Tileset.find(e.editorSprite));
				iconX += 16;
				index++;
			}
			
			offsetX = offsetX + 16 * mainIndex;
		} else {
			offsetX = offsetX - subMenu.length * 8;
			Dialog.drawBackground(offsetX, 0, subMenu.length * 16, 12, Color.WHITE);
		
			var iconX:Int = offsetX;
			var icon:Rectangle;
			var index:Int = 0;
			
			for (item in subMenu) {
				var e = EntityFactory.getfromKeyID(item.category, item.type);
			
				if (index == subIndex) Gfx.drawRect(iconX, 0, UI_NONE, Color.BLACK);
				Gfx.drawRect(iconX, 0, Tobor.Tileset.find(e.editorSprite));
				iconX += 16;
				index++;
			}
			
			offsetX = offsetX + 16 * subIndex;
		}
		
		drawPopupMenu(offsetX, 12 + Tobor.Frame8.sizeY);
	}
	
	function drawPopupMenu(offsetX:Int, offsetY:Int) {
		Tobor.Frame8.drawBox(offsetX, 12, actionsSize + 2, actions.length + 2);
		
		var index:Int = 0;
		for (action in actionsString) {
			// trace(action);
			if (action != null) {
				if (actionIndex == index) {
					Tobor.Font8.drawString(offsetX + Tobor.Frame8.sizeX, offsetY, action, Color.YELLOW, Color.BLACK);
				} else {
					Tobor.Font8.drawString(offsetX + Tobor.Frame8.sizeX, offsetY, action, Color.BLACK);
				}
			}
			
			offsetY += 10;
			index++;
		}
	}
	
	public function exitWith(item:InventoryItem, action:String) {
		this.item = item;
		this.action = action;
		
		super.exit();
	}
}
