package screens;

import lime.math.Vector2;
import ui.DialogInput;
import ui.DialogMessage;
import world.Inventory;
import world.World;
import world.entities.Entity;
import world.entities.std.Charlie;

import ui.DialogInventory;
import ui.Screen;
import ui.DialogMenu;
import ui.DialogFiles;

import world.Direction;
import world.Room;

/**
 * ...
 * @author Matthias Faust
 */
class PlayScreen extends Screen {
	var SPR_ISOLATOR:Sprite;
	var SPR_CHARLIE:Sprite;
	var SPR_CHARLIE_OVERALL:Sprite;
	var SPR_GOLD:Sprite;
	var SPR_BAG:Sprite;
	var SPR_GARLIC:Sprite;
	var SPR_TUNNEL:Sprite;
	
	var TXT_STATUS_POINTS:String;
	var TXT_STATUS_LIVES:String;
	
	var dialogInventory:DialogInventory;
	
	public function new(game:Tobor, ?loadFileName:String = null) {
		super(game);
		
		TXT_STATUS_POINTS = Text.get("TXT_STATUS_POINTS");
		TXT_STATUS_LIVES = Text.get("TXT_STATUS_LIVES");
		
		SPR_ISOLATOR = Gfx.getSprite(240, 0);
		SPR_CHARLIE = Gfx.getSprite(32, 0);
		SPR_CHARLIE_OVERALL = Gfx.getSprite(16, 156);
		SPR_GOLD = Gfx.getSprite(96, 12);
		SPR_BAG = Gfx.getSprite(112, 12);
		SPR_GARLIC = Gfx.getSprite(192, 24);
		
		SPR_TUNNEL = Gfx.getSprite(240, 120);
		
		init(loadFileName);
	}
	
	function init(?loadFileName:String = null) {
		getWorld().init(loadFileName);
		getWorld().start();

		askForName();
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
		
		getWorld().update(deltaTime);
		
		if (!Std.is(this, EditorScreen)) {
			if (getWorld().lives <= 0) {
				var d:DialogMessage = new DialogMessage(this, 0, 0, Text.get("TXT_EPISODE_LOST"), true);
				
				d.onCancel = function () {
					getWorld().checkHighScore();
				}
				
				d.onOk = function () {
					getWorld().checkHighScore();
				}
				
				showDialog(d);
			} else if (getWorld().episodeWon) {
				var d:DialogMessage = new DialogMessage(this, 0, 0, Text.getFromWorld("TXT_EPISODE_WON"), true);
				
				d.onCancel = function () {
					getWorld().checkHighScore();
				}
				
				d.onOk = function () {
					getWorld().checkHighScore();
				}
				
				showDialog(d);
			}
		}
	}
	
	inline function getRoom():Room {
		return game.world.room;
	}
	
	inline function getWorld():World {
		return game.world;
	}
	
	inline function getPlayer():Charlie {
		return game.world.player;
	}
	
	inline function getInventory():Inventory {
		return game.world.inventory;
	}
	
	function checkPlayerMovement() {
		if (Input.isKeyDown(Tobor.KEY_LEFT)) {
			movePlayer(Direction.W, Charlie.PLAYER_SPEED);
		} else if (Input.isKeyDown(Tobor.KEY_RIGHT)) {
			movePlayer(Direction.E, Charlie.PLAYER_SPEED);
		} else if (Input.isKeyDown(Tobor.KEY_UP)) {
			movePlayer(Direction.N, Charlie.PLAYER_SPEED);
		} else if (Input.isKeyDown(Tobor.KEY_DOWN)) {
			movePlayer(Direction.S, Charlie.PLAYER_SPEED);
		}
	}
	
	function movePlayer(direction:Vector2, speed:Float) {
		if (!getPlayer().isMoving() && getPlayer().visible) {
			getPlayer().move(direction, speed);
		}
	}
	
	override public function render() {
		Gfx.setOffset(0, Tobor.TILE_HEIGHT);
		getWorld().render();
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
		if (getPlayer().walkInTunnel) {
			Gfx.drawSprite(8 * Tobor.TILE_WIDTH + Tobor.TILE_WIDTH / 2, 0, SPR_TUNNEL);
		} else {
			if (getInventory().containsOverall) {
				Gfx.drawSprite(8 * Tobor.TILE_WIDTH + Tobor.TILE_WIDTH / 2, 0, SPR_CHARLIE_OVERALL);
			} else {
				Gfx.drawSprite(8 * Tobor.TILE_WIDTH + Tobor.TILE_WIDTH / 2, 0, SPR_CHARLIE);
			}
		}
		
		var punkte = getWorld().points;
		var leben = getWorld().lives;
		var garlic = Math.ceil(getWorld().garlic);
		
		if (garlic > 0) {
			if (garlic < 100) {
				var strGarlic:String = StringTools.lpad(Std.string(garlic), "0", 2);
				Tobor.fontSmall.drawString(200, 0, strGarlic, Color.BLACK);
			} else {
				Gfx.drawSprite(200, 0, SPR_GARLIC);
			}
			
			Gfx.drawSprite(200 - 16, 0, SPR_GARLIC);
		}
		
		var strStatus:String = TXT_STATUS_POINTS + " " + StringTools.lpad(Std.string(punkte), "0", 8) + " " + TXT_STATUS_LIVES + " " + Std.string(leben);
		Tobor.fontSmall.drawString(224, 0, strStatus, Color.BLACK);
		
		var gold = getWorld().gold; // game.world.player.gold;
		if (gold > 0) {
			Gfx.drawSprite(416, 0, SPR_GOLD);
			Tobor.fontSmall.drawString(416 + 24, 0, StringTools.lpad(Std.string(gold), " ", 3), Color.BLACK);
		}
		
		var weight = getInventory().size; // game.world.player.inventory.length;
		var strWeight:String = StringTools.lpad(Std.string(weight), " ", 2);
		Gfx.drawSprite(471, 0, SPR_BAG);
		Tobor.fontSmall.drawString(488, 0, strWeight, Color.BLACK);
	}
	
	function showMainMenu() {
		var menu = new DialogMenu(this, 320, 166, [
			[Text.get("TXT_MENU_OPTIONS"), "", function () {
				hideDialog();
			}],
			[Text.get("TXT_MENU_SCENE_TEXT"), "", function() {
				showRoomName(true);
			}],
			[Text.get("TXT_MENU_BACKPACK"), "<-", function() {
				hideDialog();
				showInventory();
			}],
			[Text.get("TXT_MENU_HELP"), "", function () {
				hideDialog();
			}],
			[Text.get("TXT_MENU_STORY"), "", function () {
				hideDialog();
			}],
			[Text.get("TXT_MENU_RESTART"), "", function () {
				hideDialog();
			}],
			[Text.get("TXT_MENU_LOAD"), "", function () {
				showLoadgameDialog();
			}],
			[Text.get("TXT_MENU_CANCEL"), "", function() {
				getWorld().checkHighScore();
			}],	
		]);
		
		menu.select(2);
		
		menu.onCancel = function () {
			hideDialog();
		};
			
		menu.onOk = function () {
			
		};
		
		showDialog(menu);
	}
	
	function showInventory() {
		// keine Inventarnutztung wenn sich der Spieler bewegt, unsichtbar/tot ist
		if (getPlayer().isMoving() || !getPlayer().visible) return;
		
		// oder wenn das inventar leer ist
		if (getInventory().size == 0) return;
		
		if (dialogInventory == null) {
			dialogInventory = new DialogInventory(this, 0, 0);
		
			dialogInventory.onOk = function () {
				hideDialog();
			
				getInventory().doItemAction(getWorld(), dialogInventory.selectedAction, dialogInventory.selectedItem);
			}
		
			dialogInventory.onCancel = function () {
				hideDialog();
			}
		}
		
		showDialog(dialogInventory);
	}
	
	function askForName() {
		if (Std.is(this, EditorScreen)) return;
		if (getWorld().playerName != null) {
			showRoomName();
			return;
		}
		
		var d:DialogInput = new DialogInput(this, 0, 0, Text.get("TXT_ASK_FOR_NAME"));
		
		d.onCancel = function () {
			showRoomName();
		}
		
		d.onOk = function () {
			getWorld().playerName = d.getInput();
			showRoomName();
		}
		
		showDialog(d);
	}
	
	public function showLoadgameDialog() {
		var files = getWorld().file.getSavegames();
		
		if (files.length > 0) {
			var d:DialogFiles = new DialogFiles(this, 0, 0, Text.get("TXT_LOAD_WHICH_GAME"), files);
			
			d.onOk = function () {
				game.setScreen(new PlayScreen(game, d.getInput()));
			};
			
			showDialog(d);
		} else {
			hideDialog();
		}
	}
	
	public function showRoomName(?force:Bool = false) {
		if (Std.is(this, EditorScreen)) return;
		
		if (!getWorld().roomVisited() || force) {
			var roomName:String = getRoom().getName();
						
			var d:DialogMessage = new DialogMessage(this, 0, 0, "*** " + roomName + " ***", false);
						
			showDialog(d);
						
			getWorld().markRoomVisited();
		}
	}
}