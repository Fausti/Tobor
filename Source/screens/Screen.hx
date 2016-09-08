package screens;

import world.Room;
import world.entity.Charlie;
import world.entity.Entity;
import world.entity.EntityPushable;
import world.entity.Wall;
import lime.Assets;
import lime.graphics.GLRenderContext;
import lime.graphics.Image;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLTexture;
import lime.math.Matrix4;
import lime.math.Rectangle;
import lime.math.Vector4;
import lime.utils.Float32Array;
import gfx.Batch;
import gfx.Color;
import gfx.Gfx;

import gfx.Gfx.gl;

/**
 * ...
 * @author Matthias Faust
 */
class Screen {
	var game:Tobor;
	
	public var batchStatic:Batch;
	public var batchSprites:Batch;
	
	var backgroundColor = Color.WHITE;
	var color:Color = Color.WHITE;
	
	public function new(game:Tobor) {
		this.game = game;
		
		batchStatic = new Batch(true);
		batchSprites = new Batch(true);
	}
	
	public function update(deltaTime:Float) {
		var mx:Int = 0;
		var my:Int = 0;
		
		if (Input.keyDown(Input.RIGHT)) mx = 1;		
		if (Input.keyDown(Input.LEFT)) mx = -1;
		if (Input.keyDown(Input.UP)) my = -1;
		if (Input.keyDown(Input.DOWN)) my = 1;
		
		game.world.player.move(mx, my);
		
		if (Input.keyDown(Input.ESC)) {
			game.world.player.die();
		}
		
		game.world.room.update(deltaTime);
	}
	
	public function render() {
		Gfx.clear(backgroundColor);
		
		// offsetY um ein "Feld" nach unten verschieben
		
		Gfx.setOffset(0, 12);
		
		// statische Sprites zeichnen
		
		renderStatic();
		
		// bewegliche Sprites zeichnen
		
		renderSprites();
	}
	
	function renderStatic() {
		Gfx.setBatch(batchStatic);
		
		if (game.world.room.redraw) {
			batchStatic.clear();
			
			game.world.room.draw(Room.LAYER_BACKGROUND);
		}
		
		batchStatic.bind();
		batchStatic.draw();
	}
	
	function renderSprites() {
		Gfx.setBatch(batchSprites);
		
		batchSprites.clear();
		
		game.world.room.draw(Room.LAYER_SPRITE);
				
		batchSprites.bind();
		batchSprites.draw();
	}
	
	
}