package screens;

import ui.Screen;
import ui.DialogMenu;

/**
 * ...
 * @author Matthias Faust
 */
class IntroScreen extends Screen {
	var bgSprite:Sprite;
	
	public function new(game:Tobor) {
		super(game);
		
		bgSprite = Gfx.getSprite(48, 132, Tobor.TILE_WIDTH, Tobor.TILE_HEIGHT);
	}
	
	override public function show() {
		Sound.play(Sound.MUS_INTRO_DOS, true);
	}
	
	override public function hide() {
		Sound.stop(Sound.MUS_INTRO_DOS);
	}
	
	override public function update(deltaTime:Float) {
		if (dialog != null) {
			dialog.update(deltaTime);
			return;
		}
		
		if (Input.isKeyDown([Input.key.ESCAPE])) {
			// game.setScreen(new EpisodesScreen(game));
		} else if (Input.isKeyDown([Input.key.RETURN])) {
			// game.setScreen(new PlayScreen(game));
			showMainMenu();
		}
	}
	
	override public function render() {
		for (x in 0 ... 40) {
			for (y in 0 ... 29) {
				Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, bgSprite);
			}
		}
	}
	
	function showMainMenu() {
		var menu = new DialogMenu(this, 320, 166, [
			["Hilfe", "F1"],
			["Story", "F2"],
			["Spielstart", "F4", function() {
				game.setScreen(new PlayScreen(game));
			}],
			["Laden", "F7"],
			["Ende", "F9", function() {
				game.exit();
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