package screens;

import ui.Screen;
import ui.DialogMenu;

import world.Direction;

/**
 * ...
 * @author Matthias Faust
 */
class PlayScreen extends Screen {
	var SPR_ISOLATOR:Sprite;
	var SPR_CHARLIE:Sprite;
	var SPR_GOLD:Sprite;
	var SPR_BAG:Sprite;
	
	public function new(game:Tobor) {
		super(game);
		
		SPR_ISOLATOR = Gfx.getSprite(240, 0);
		SPR_CHARLIE = Gfx.getSprite(32, 0);
		SPR_GOLD = Gfx.getSprite(96, 12);
		SPR_BAG = Gfx.getSprite(112, 12);
	}
	
	override public function update(deltaTime:Float) {
		if (dialog != null) {
			dialog.update(deltaTime);
			return;
		} else {
			checkPlayerMovement();
		}
		
		game.world.update(deltaTime);
	}
	
	function checkPlayerMovement() {
		var speed:Float = 8;
		
		if (Input.isKeyDown([Input.key.A, Input.key.LEFT])) {
			game.world.player.move(Direction.W, speed);
		} else if (Input.isKeyDown([Input.key.D, Input.key.RIGHT])) {
			game.world.player.move(Direction.E, speed);
		} else if (Input.isKeyDown([Input.key.W, Input.key.UP])) {
			game.world.player.move(Direction.N, speed);
		} else if (Input.isKeyDown([Input.key.S, Input.key.DOWN])) {
			game.world.player.move(Direction.S, speed);
		} else if (Input.isKeyDown([Input.key.ESCAPE])) {
			showMainMenu();
		} else if (Input.isKeyDown([Input.key.RETURN])) {
			
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
		
		var punkte = 0; // game.world.player.points;
		var leben = 0; // game.world.player.lives;
		
		var strStatus:String = "Punkte " + StringTools.lpad(Std.string(punkte), "0", 8) + " Leben " + Std.string(leben);
		Tobor.fontSmall.drawString(224, 0, strStatus, Color.BLACK);
		
		var gold = 0; // game.world.player.gold;
		if (gold > 0) {
			Gfx.drawSprite(416 * Tobor.ZOOM, 0, SPR_GOLD);
			Tobor.fontSmall.drawString(416 + 24, 0, StringTools.lpad(Std.string(gold), " ", 3), Color.BLACK);
		}
		
		var weight = 0; // game.world.player.inventory.length;
		var strWeight:String = StringTools.lpad(Std.string(weight), " ", 2);
		Gfx.drawSprite(471 * Tobor.ZOOM, 0, SPR_BAG);
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
}