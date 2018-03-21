package screens;

import lime.math.Vector2;
import world.entities.Entity;

import ui.DialogInventory;
import ui.Screen;
import ui.DialogMenu;

import world.Direction;
import world.Room;

/**
 * ...
 * @author Matthias Faust
 */
class PlayScreen extends Screen {
	var SPR_ISOLATOR:Sprite;
	var SPR_CHARLIE:Sprite;
	var SPR_GOLD:Sprite;
	var SPR_BAG:Sprite;
	var SPR_GARLIC:Sprite;
	
	public function new(game:Tobor) {
		super(game);
		
		SPR_ISOLATOR = Gfx.getSprite(240, 0);
		SPR_CHARLIE = Gfx.getSprite(32, 0);
		SPR_GOLD = Gfx.getSprite(96, 12);
		SPR_BAG = Gfx.getSprite(112, 12);
		SPR_GARLIC = Gfx.getSprite(192, 24);
	}
	
	override public function update(deltaTime:Float) {
		if (dialog != null) {
			dialog.update(deltaTime);
			return;
		} else {
			if (Input.isKeyDown([Input.key.ESCAPE])) {
				showMainMenu();
				
				return;
			} else if (Input.isKeyDown([Input.key.RETURN])) {
				showInventory();
			}
		
			checkPlayerMovement();
		}
		
		game.world.update(deltaTime);
	}
	
	function checkPlayerMovement() {
		var speed:Float = 8;
		
		if (Input.isKeyDown(Tobor.KEY_LEFT)) {
			movePlayer(Direction.W, speed);
		} else if (Input.isKeyDown(Tobor.KEY_RIGHT)) {
			movePlayer(Direction.E, speed);
		} else if (Input.isKeyDown(Tobor.KEY_UP)) {
			movePlayer(Direction.N, speed);
		} else if (Input.isKeyDown(Tobor.KEY_DOWN)) {
			movePlayer(Direction.S, speed);
		}
	}
	
	function movePlayer(direction:Vector2, speed:Float) {
		var player = game.world.player;
		
		if (!Room.isOutsideMap(player.x + direction.x, player.y + direction.y)) {
			game.world.player.move(direction, speed);
		} else {
			if (!game.world.player.isMoving()) {
				var nextRoom = game.world.findRoom(
					Std.int(game.world.room.x + direction.x), 
					Std.int(game.world.room.y + direction.y), 
					game.world.room.z
				);
				
				if (nextRoom != null) {
					game.world.room.saveState();
					game.world.switchRoom(
						Std.int(game.world.room.x + direction.x), 
						Std.int(game.world.room.y + direction.y), 
						game.world.room.z
					);
					game.world.room.restoreState();
					
					if (player.x == 0) player.x = Room.WIDTH - 1;
					else if (player.x == Room.WIDTH - 1) player.x = 0;
					else if (player.y == 0) player.y = Room.HEIGHT - 1;
					else if (player.y == Room.HEIGHT - 1) player.y = 0;
					
					var atTarget:Array<Entity> = game.world.room.getEntitiesAt(player.x, player.y, player);
					for (e in atTarget) {
						e.onEnter(player, direction);
					}
					
					Input.wait(0.25);
				}
			}
		}
	}
	
	override public function render() {
		Gfx.setOffset(0, Tobor.TILE_HEIGHT);
		game.world.render();
	}
	
	override public function renderUI() {
		Gfx.setOffset(0, 0);
		
		renderStatusLine();
		
		if (dialog != null) {
			dialog.render();
		}
	}
	
	function renderStatusLine() {
		for (x in 0 ... 8) {
			Gfx.drawSprite(x * Tobor.TILE_WIDTH, 0, SPR_ISOLATOR);
			Gfx.drawSprite((39 - x) * Tobor.TILE_WIDTH, 0, SPR_ISOLATOR);
		}
		
		// TODO: Blaumann! Oder Charlieobjekt fragen?
		Gfx.drawSprite(8 * Tobor.TILE_WIDTH + Tobor.TILE_WIDTH / 2, 0, SPR_CHARLIE);
		
		var punkte = game.world.points; // game.world.player.points;
		var leben = game.world.lives; // game.world.player.lives;
		var garlic = Math.ceil(game.world.garlic);
		
		if (garlic > 0) {
			if (garlic < 100) {
				var strGarlic:String = StringTools.lpad(Std.string(garlic), "0", 2);
				Tobor.fontSmall.drawString(200, 0, strGarlic, Color.BLACK);
			} else {
				Gfx.drawSprite(200, 0, SPR_GARLIC);
			}
			
			Gfx.drawSprite(200 - 16, 0, SPR_GARLIC);
		}
		
		var strStatus:String = "Punkte " + StringTools.lpad(Std.string(punkte), "0", 8) + " Leben " + Std.string(leben);
		Tobor.fontSmall.drawString(224, 0, strStatus, Color.BLACK);
		
		var gold = game.world.gold; // game.world.player.gold;
		if (gold > 0) {
			Gfx.drawSprite(416, 0, SPR_GOLD);
			Tobor.fontSmall.drawString(416 + 24, 0, StringTools.lpad(Std.string(gold), " ", 3), Color.BLACK);
		}
		
		var weight = game.world.inventory.size; // game.world.player.inventory.length;
		var strWeight:String = StringTools.lpad(Std.string(weight), " ", 2);
		Gfx.drawSprite(471, 0, SPR_BAG);
		Tobor.fontSmall.drawString(488, 0, strWeight, Color.BLACK);
	}
	
	function showMainMenu() {
		var menu = new DialogMenu(this, 320, 166, [
			["Einstellungen", ""],
			["Szenen-Text", "?"],
			["Rucksack", "<-", function() {
				
			}],
			["Hilfe", "F1"],
			["Story", "F2"],
			["Szenenanfang", "F3"],
			["Sichern", "F5"],
			["Laden", "F7"],
			["Abbruch", "F9", function() {
				game.setScreen(new IntroScreen(game));
			}],	
		]);
		
		menu.select(2);
		
		menu.onCancel = function () {
			hideDialog();
		};
			
		menu.onOk = function () {
			hideDialog();
		};
		
		showDialog(menu);
	}
	
	function showInventory() {
		if (game.world.inventory.size == 0) return;
		
		var menu = new DialogInventory(this, 0, 0);
		
		menu.onOk = function () {
			hideDialog();
			
			game.world.inventory.doItemAction(game.world, menu.selectedAction, menu.selectedItem);
		}
		
		menu.onCancel = function () {
			hideDialog();
		}
		
		showDialog(menu);
	}
}