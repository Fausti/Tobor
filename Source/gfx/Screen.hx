package gfx;

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

import gfx.Gfx.gl;

/**
 * ...
 * @author Matthias Faust
 */
class Screen {
	
	
	public var width:Int;
	public var height:Int;
	
	public var batchStatic:Batch;
	public var batchSprites:Batch;
	
	var backgroundColor = Color.WHITE;
	var color:Color = Color.WHITE;
	
	var player:Charlie;
	var room:Room;
	
	public function new(cfg) {
		this.width = cfg.width;
		this.height = cfg.height;
	
		batchStatic = new Batch(true);
		batchSprites = new Batch(true);
		
		player = new Charlie();
		player.gridX = 0;
		player.gridY = 0;
		
		room = new Room();
		room.add(player);
				
		for (i in 0 ... 200) {
			var wall = new Wall();
			wall.gridX = Std.random(Room.SIZE_X);
			wall.gridY = Std.random(Room.SIZE_Y);
			
			room.add(wall, true);
		}
		
		for (i in 0 ... 500) {
			var wall = new EntityPushable();
			wall.gridX = Std.random(Room.SIZE_X);
			wall.gridY = Std.random(Room.SIZE_Y);
			
			room.add(wall, true);
		}
	}
	
	public function update(deltaTime:Float) {
		var mx:Int = 0;
		var my:Int = 0;
		
		if (Input.keyDown(Input.RIGHT)) mx = 1;		
		if (Input.keyDown(Input.LEFT)) mx = -1;
		if (Input.keyDown(Input.UP)) my = -1;
		if (Input.keyDown(Input.DOWN)) my = 1;
		
		player.move(mx, my);
		
		room.update(deltaTime);
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
		
		if (room.redraw) {
			batchStatic.clear();
			
			room.draw(Room.LAYER_BACKGROUND);
		}
		
		batchStatic.bind();
		batchStatic.draw();
	}
	
	function renderSprites() {
		Gfx.setBatch(batchSprites);
		
		batchSprites.clear();
		
		room.draw(Room.LAYER_SPRITE);
				
		batchSprites.bind();
		batchSprites.draw();
	}
	
	
}