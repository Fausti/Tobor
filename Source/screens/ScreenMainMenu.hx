package screens;

import gfx.Gfx;
import gfx.Color;

/**
 * ...
 * @author Matthias Faust
 */
class ScreenMainMenu extends Screen {

	public function new(game:Tobor) {
		super(game);
	}
	
	override public function update(deltaTime:Float) {
		super.update(deltaTime);
		
		if (Input.keyDown(Input.ENTER)) {
			Input.wait(2);
				
			game.switchScreen(new ScreenEditor(game));
		}
		
		if (Input.keyDown(Input.ESC)) {
			Input.wait(2);
				
			game.switchScreen(new ScreenIntro(game));
		}
	}
	
	override
	public function render() {
		Gfx.clear(Color.RED);
	}
}