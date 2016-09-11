package screens;

import gfx.Gfx;
import gfx.Color;

/**
 * ...
 * @author Matthias Faust
 */
class ScreenIntro extends Screen {

	public function new(game:Tobor) {
		super(game);
	}
	
	override public function update(deltaTime:Float) {
		super.update(deltaTime);
		
		if (Input.keyDown(Input.ENTER)) {
			Input.wait(2);
				
			game.switchScreen(new ScreenMainMenu(game));
		}
		
		if (Input.keyDown(Input.ESC)) {
			Input.wait(2);
				
			game.exit(Tobor.EXIT_OK);
		}
	}
	
	override
	public function render() {
		Gfx.clear(Color.BLUE);
	}
}