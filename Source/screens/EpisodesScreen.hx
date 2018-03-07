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
	
	override public function renderUI() {
		super.renderUI();
		
		var x:Int = 32;
		var y:Int = 72;
		
		Tobor.frameSmallNew.drawBox(x, y, 32, 4, Color.YELLOW);
		
		Tobor.fontBig.drawShadowString(x + 37, y + 7, "TOBOR", Color.YELLOW);
		Tobor.fontSmall.drawString(x + 37, y + 23, "Hase gesucht!", Color.BLACK);
	}
}