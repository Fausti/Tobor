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
		
		batchStatic.bind();
		batchStatic.draw();
	}
	
	override
	public function renderUI() {
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