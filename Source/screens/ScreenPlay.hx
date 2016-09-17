package screens;

import dialog.DialogInventory;
import dialog.DialogMenu;
import gfx.Gfx;
import gfx.Color;
import world.Room;
import world.entities.Object;
import world.entities.ObjectItem;

/**
 * ...
 * @author Matthias Faust
 */
class ScreenPlay extends Screen {
	var dialogMenu:DialogMenu;
	var dialogInventory:DialogInventory;
	
	public function new(game:Tobor) {
		super(game);
		
		// ESC - Menü
		
		dialogMenu = new DialogMenu(this, 320, 166, [
			["Ende", "", function() {
				game.exit(Tobor.EXIT_OK);
				// game.switchScreen(new ScreenMainMenu(game));
			}],
		]);
		
		dialogMenu.onEXIT = function () {
			hideDialog();
		};
			
		dialogMenu.onOK = function () {
			hideDialog();
		};
		
		// Inventar
		
		dialogInventory = new DialogInventory(this, 0, 0, game.world.player.inventory);
		
		dialogInventory.onEXIT = function () {
			hideDialog();
			
			if (dialogInventory.item != null && dialogInventory.action != null) {
				var inv = game.world.player.inventory;
				var obj:ObjectItem = inv.spawnObject(inv.find(dialogInventory.item.category, dialogInventory.item.type));
				
				if (obj != null) {
					switch (dialogInventory.action) {
						case DialogInventory.ACTION_DROP:
							obj.room = game.world.room;
							obj.gridX = game.world.player.gridX;
							obj.gridY = game.world.player.gridY;
		
							obj.onDrop(dialogInventory.item, game.world.room);
						case DialogInventory.ACTION_USE:
							obj.room = game.world.room;
							obj.gridX = game.world.player.gridX;
							obj.gridY = game.world.player.gridY;
							
							obj.onUse(dialogInventory.item, game.world.room);
						default:
					}
				}
			}
		};
			
		dialogInventory.onOK = function () {
			hideDialog();
		};
	}
	
	override public function show() {
		Tobor.GAME_MODE = GameMode.Play;
	}
	
	override
	public function update(deltaTime:Float) {
		if (dialog != null) {
			super.update(deltaTime);
		} else {
			if (Input.keyDown(Input.NUM_1)) {
				Input.wait(2);
				
				
			}
			
			if (Input.keyDown(Input.ENTER)) {
				if (game.world.player.inventory.length > 0) {
					Input.wait(2);
					showDialog(dialogInventory);
				
					return;
				}
			}
			
			if (Input.keyDown(Input.ESC)) {
				Input.wait(2);
				showDialog(dialogMenu);
				
				return;
			}
			
			checkForMovement();
		
			game.world.room.update(deltaTime);
		}
	}
	
	function checkForMovement() {
		var mx:Int = 0;
		var my:Int = 0;
		
		if (Input.keyDown(Input.RIGHT)) mx = 1;		
		else if (Input.keyDown(Input.LEFT)) mx = -1;
		else if (Input.keyDown(Input.UP)) my = -1;
		else if (Input.keyDown(Input.DOWN)) my = 1;
		
		game.world.player.move(mx, my);
	}
	
	override
	public function render() {
		Gfx.clear(backgroundColor);
		
		// offsetY um ein "Feld" nach unten verschieben
		
		Gfx.setOffset(0, 12);
		
		// statische Sprites zeichnen
		
		renderStatic();
		
		// bewegliche Sprites zeichnen
		
		renderSprites();
	}
	
	override
	public function renderUI() {
		renderStatusLine();
		
		super.renderUI();
	}
	
	function renderStatusLine() {
		for (x in 0 ... 8) {
			Gfx.drawRect(x * Tobor.OBJECT_WIDTH, 0, Tobor.Tileset.tile(15, 0));
			Gfx.drawRect((39 - x) * Tobor.OBJECT_WIDTH, 0, Tobor.Tileset.tile(15, 0));
		}
		
		// TODO: Blaumann! Oder Charlieobjekt fragen?
		Gfx.drawRect(8 * Tobor.OBJECT_WIDTH + Tobor.OBJECT_WIDTH / 2, 0, Tobor.Tileset.tile(2, 0));
		
		var punkte = game.world.player.points;
		var leben = game.world.player.lives;
		
		var strStatus:String = "Punkte " + StringTools.lpad(Std.string(punkte), "0", 8) + " Leben " + Std.string(leben);
		Tobor.Font8.drawString(224, 0, strStatus, Color.BLACK);
		
		var gold = game.world.player.gold;
		if (gold > 0) {
			Gfx.drawRect(416, 0, Tobor.Tileset.tile(6, 1));
			Tobor.Font8.drawString(416 + 24, 0, StringTools.lpad(Std.string(gold), " ", 3), Color.BLACK);
		}
		
		var weight = game.world.player.inventory.length;
		var strWeight:String = StringTools.lpad(Std.string(weight), " ", 2);
		Gfx.drawRect(471, 0, Tobor.Tileset.tile(7, 1));
		Tobor.Font8.drawString(488, 0, strWeight, Color.BLACK);
	}
	
	function renderStatic() {
		Gfx.setBatch(batchStatic);
		
		if (game.world.room.redraw) {
			batchStatic.clear();
			
			game.world.room.draw(Room.LAYER_BACKGROUND);
		}
		
		batchStatic.bind();
		batchStatic.draw();
	}
	
	function renderSprites() {
		Gfx.setBatch(batchSprites);
		
		batchSprites.clear();
		
		game.world.room.draw(Room.LAYER_SPRITE);
				
		batchSprites.bind();
		batchSprites.draw();
	}

}