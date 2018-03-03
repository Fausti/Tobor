package;

import cpp.vm.Gc;
import lime.system.System;

import core.LimeGame;
import gfx.Batch;
import gfx.Shader;
import gfx.Sprite;
import lime.math.Rectangle;

import lime.Assets;

import gfx.Gfx;
import gfx.Color;
import gfx.Texture;

import world.World;
import world.Direction;

/**
 * ...
 * @author Matthias Faust
 */
class Tobor extends LimeGame {
	public static inline var ZOOM:Int = 2;
	
	public static inline var SCREEN_WIDTH:Int = 640 * ZOOM;
	public static inline var SCREEN_HEIGHT:Int = 348 * ZOOM;
	public static inline var TILE_WIDTH:Int = 16 * ZOOM;
	public static inline var TILE_HEIGHT:Int = 12 * ZOOM;
	
	var texture:Texture;
	var shader:Shader;
	var batch:Batch;
	
	var world:World;
	
	public function new() {
		super();
		
		__framebuffer_w = SCREEN_WIDTH;
		__framebuffer_h = SCREEN_HEIGHT;
	}
	
	override public function init() {
		Gfx.setup(SCREEN_WIDTH, SCREEN_HEIGHT);
		
		texture = Gfx.loadTexture("assets/tileset.png");
		
		shader = Shader.createDefaultShader();
		
		batch = new Batch();
		
		world = new World();

		// run the garbage collector
		Gc.run(true);
		Gc.compact();
		// Gc.run(false);
	}
	
	override public function update(deltaTime:Float) {
		var speed:Float = 4;
		
		if (Input.down([Input.key.A, Input.key.LEFT])) {
			world.player.move(Direction.LEFT, speed);
		} else if (Input.down([Input.key.D, Input.key.RIGHT])) {
			world.player.move(Direction.RIGHT, speed);
		} else if (Input.down([Input.key.W, Input.key.UP])) {
			world.player.move(Direction.UP, speed);
		} else if (Input.down([Input.key.S, Input.key.DOWN])) {
			world.player.move(Direction.DOWN, speed);
		}
		
		world.update_begin(deltaTime);
		
		if (Input.down([Input.key.A, Input.key.LEFT])) {
			world.player.move(Direction.LEFT, speed);
		} else if (Input.down([Input.key.D, Input.key.RIGHT])) {
			world.player.move(Direction.RIGHT, speed);
		} else if (Input.down([Input.key.W, Input.key.UP])) {
			world.player.move(Direction.UP, speed);
		} else if (Input.down([Input.key.S, Input.key.DOWN])) {
			world.player.move(Direction.DOWN, speed);
		}
		
		world.update_end(deltaTime);
	}
	
	override public function render() {
		Gfx.setShader(shader);
		Gfx.setTexture(texture);
		
		Gfx.setOffset(0, 0);
		Gfx.setViewport(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
		Gfx.clear(Color.WHITE);
		
		Gfx.begin(batch);
			Gfx.setOffset(0, Tobor.TILE_HEIGHT);
			renderWorld();
			
			Gfx.setOffset(0, 0);
			renderUI();
		Gfx.end();
	}
	
	function renderUI() {
		
	}
	
	function renderWorld() {
		world.render();
	}
}