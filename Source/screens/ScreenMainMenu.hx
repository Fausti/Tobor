package screens;

import dialog.DialogMenu;
import gfx.Gfx;
import gfx.Color;
import lime.math.Rectangle;
import world.entities.Entity;

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
				
				// game.switchScreen(new ScreenEditor(game));
				showMainMenu();
			}	
		
			if (Input.keyDown(Input.ESC)) {
				Input.wait(2);
				
				game.exit(Tobor.EXIT_OK);
				// game.switchScreen(new ScreenIntro(game));
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
					Gfx.drawRect(x * Entity.WIDTH, y * Entity.HEIGHT, SPR_WALL, Color.WHITE);
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
			["Hilfe", "F1"],		// 0
			["Story", "F2"],		// 1
			["Spielstart", "F4"],	// 2
			["Laden", "F7"],		// 3
			["Editor", "F8"],		// 4
			["Ende", "F9"],			// 5
			// ["Musik", "@M"],
			// ["Vollbild", "@Ret"]
		]);
		
		menu.select(2);
		
		dialog = menu;
		
		dialog.onEXIT = function () {
			dialog = null;
		};
			
		dialog.onOK = function () {
			switch(menu.getSelected()) {
				case 2:
					game.switchScreen(new ScreenPlay(game));
				case 4:
					game.switchScreen(new ScreenEditor(game));
				default:
			}

			dialog = null;
		};
	}
}