package screens;

import ui.Screen;

/**
 * ...
 * @author Matthias Faust
 */
class EpisodesScreen extends Screen {
	var bgSprite:Sprite;
	
	public function new(game:Tobor) {
		super(game);
		
		bgSprite = Gfx.getSprite(160, 0, Tobor.TILE_WIDTH, Tobor.TILE_HEIGHT);
	}
	
	override public function show() {
		Sound.play(Sound.MUS_CHOOSER, true);
	}
	
	override public function hide() {
		Sound.stop(Sound.MUS_CHOOSER);
	}
	
	override public function update(deltaTime:Float) {
		if (Input.isKeyDown([Input.key.ESCAPE])) {
			game.exit();
		} else if (Input.isKeyDown([Input.key.RETURN])) {
			game.setScreen(new IntroScreen(game));
		}
	}
	
	override public function render() {
		for (x in 0 ... 40) {
			for (y in 0 ... 29) {
				Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, bgSprite);
			}
		}
	}
}