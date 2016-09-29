package screens;

import dialog.DialogMenu;
import gfx.Gfx;
import gfx.Color;
import lime.math.Rectangle;
import world.entities.Object;

/**
 * ...
 * @author Matthias Faust
 */
class ScreenMainMenu extends Screen {
	var SPR_WALL:Rectangle;
	
	public function new(game:Tobor) {
		super(game);
		
		SPR_WALL = Tobor.Tileset.find("SPR_MAUER");
	}
	
	override public function update(deltaTime:Float) {
		super.update(deltaTime);
		
		if (dialog == null) {
			if (Input.keyDown(Input.ENTER)) {
				Input.wait(2);
				showMainMenu();
			}	
		
			if (Input.keyDown(Input.ESC)) {
				Input.wait(2);
				
				game.switchScreen(game.screenIntro);
			}
		} else {
			dialog.update(deltaTime);
		}
	}
	
	override
	public function render() {
		Gfx.clear(Color.RED);
		
		Gfx.setBatch(batchStatic);
		
		if (batchStatic.length == 0) {
			for (x in 0 ... 40) {
				for (y in 0 ... 29) {
					Gfx.drawRect(x * Tobor.OBJECT_WIDTH, y * Tobor.OBJECT_HEIGHT, SPR_WALL, Color.WHITE);
				}
			}
		}
		
		game.screenIntro.renderTitle();
		
		batchStatic.bind();
		batchStatic.draw();
	}
	
	override
	public function renderUI() {
		var offsetX = 16;
		var offsetY = (28 - 3) * 12;
		
		var button_0:Rectangle = game.screenIntro.renderButton(offsetX, offsetY, "Spielen");
		var button_1:Rectangle = game.screenIntro.renderButton(button_0.right + 16, offsetY, "Laden");
		var button_2:Rectangle = game.screenIntro.renderButton(button_1.right + 16, offsetY, "Editor");
		
		game.screenIntro.renderButtonRight("Zurück");
		
		if (dialog != null) {
			dialog.render();
		}
	}
	
	function showMainMenu() {
		var menu = new DialogMenu(this, 320, 166, [
			["Hilfe", "F1"],
			["Story", "F2"],
			["Spielstart", "F4", function() {
				game.switchScreen(game.screenPlay);
			}],
			["Editor", "F8", function() {
				game.switchScreen(game.screenEditor);
			}],
			["Laden", "F7"],
			["Ende", "F9"],	
		]);
		
		menu.select(2);
		
		dialog = menu;
		
		dialog.onEXIT = function () {
			dialog = null;
		};
			
		dialog.onOK = function () {
			dialog = null;
		};
	}
}