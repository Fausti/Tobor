package screens;

import ui.Screen;
import gfx.Batch;

import world.Direction;
/**
 * ...
 * @author Matthias Faust
 */
class PlayScreen extends Screen {
	public function new(game:Tobor) {
		super(game);
	}
	
	override public function update(deltaTime:Float) {
		var speed:Float = 8;
		
		if (Input.down([Input.key.A, Input.key.LEFT])) {
			game.world.player.move(Direction.W, speed);
		} else if (Input.down([Input.key.D, Input.key.RIGHT])) {
			game.world.player.move(Direction.E, speed);
		} else if (Input.down([Input.key.W, Input.key.UP])) {
			game.world.player.move(Direction.N, speed);
		} else if (Input.down([Input.key.S, Input.key.DOWN])) {
			game.world.player.move(Direction.S, speed);
		} else if (Input.down([Input.key.ESCAPE])) {
			game.setScreen(new IntroScreen(game));
		} else if (Input.down([Input.key.RETURN])) {
			
		}
		
		game.world.update(deltaTime);
	}
	
	override public function render() {
		Gfx.setOffset(0, Tobor.TILE_HEIGHT);
		game.world.render();
			
		Gfx.setOffset(0, 0);
		renderUI();
	}
	
	public function renderUI() {
		
	}
}