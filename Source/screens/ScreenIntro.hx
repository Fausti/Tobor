package screens;

import gfx.Gfx;
import gfx.Color;
import haxe.Utf8;
import haxe.io.Path;
import sys.FileSystem;
import tjson.TJSON;

import lime.math.Rectangle;

/**
 * ...
 * @author Matthias Faust
 */
class ScreenIntro extends Screen {
	var episodes:Array<String>;
	
	var SPR_WALL:Rectangle;
	
	public function new(game:Tobor) {
		super(game);
		
		SPR_WALL = Tobor.Tileset.find("SPR_MAUER_BLACK");
	}
	
	override public function show() {
		super.show();
		
		episodes = [];
		
		for (episode in SaveGame.getFiles(SaveGame.DIR_EPISODES, "episode", [])) {
			var header = SaveGame.loadHeader(episode.toString());
			
			if (header != null) {
				var data = TJSON.parse(header);
				
				if (Reflect.hasField(data, "name")) {
					episodes.push(Reflect.field(data, "name"));
				} else {
					episodes.push(episode.toString());
				}
			} else {
				episodes.push(episode.toString());
			}
		}
		
		trace(episodes);
	}
	
	override public function update(deltaTime:Float) {
		super.update(deltaTime);
		
		if (Input.keyDown(Input.ENTER)) {
			Input.wait(2);
				
			game.switchScreen(game.screenMenu);
		}
		
		if (Input.keyDown(Input.ESC)) {
			Input.wait(2);
				
			game.exit(Tobor.EXIT_OK);
		}
	}
	
	override
	public function render() {
		Gfx.clear(Color.RED);
		
		Gfx.setBatch(batchStatic);
		
		if (batchStatic.length == 0) {
			for (x in 0 ... 40) {
				for (y in 0 ... 29) {
					Gfx.drawRect(x * Tobor.OBJECT_WIDTH, y * Tobor.OBJECT_HEIGHT, SPR_WALL, Color.WHITE);
				}
			}
		}
		
		batchStatic.bind();
		batchStatic.draw();
	}
	
	override
	public function renderUI() {
		var offsetX:Int = Std.int((20 - 6.5) * 16);
		var offsetY:Int = 36;
		
		Tobor.FrameIntro.drawBox(offsetX, offsetY, 13, 6);
		Tobor.Font16.drawString(offsetX + 16, offsetY + 12, "The Game of", Color.BLACK);
		Gfx.drawTexture(offsetX + 16 + 8, offsetY + 24 + 10, 160, 24, Tobor.Tileset.rect(0, 408, 160, 24));
		
		offsetX = 4 * 16;
		offsetY = offsetY + 10 * 12;
		
		Tobor.FrameIntro.drawBox(offsetX, offsetY, 32, 10);
		
		offsetX += 16;
		offsetY += 12;
		
		for (episode in episodes) {
			Tobor.Font8.drawString(offsetX, offsetY, episode, Color.BLACK);
			offsetY += 10;
		}
		
		renderButtonLeft("Ende");
		renderButtonRight("Weiter");
		
		if (dialog != null) {
			dialog.render();
		}
	}
	
	public function renderButtonLeft(text:String) {
		text = Utf8.decode(text);
		
		var offsetX = 16;
		var offsetY = (28 - 3) * 12;
		
		Tobor.FrameIntro.drawBox(offsetX, offsetY, 2 + Std.int(Math.ceil(text.length / 2)), 3);
		Tobor.Font8.drawString(offsetX + 16, offsetY + 12 + 1, text, Color.BLACK);
	}
	
	public function renderButtonRight(text:String) {
		text = Utf8.decode(text);
		
		var offsetX = (40 - 3) * 16 - Std.int(Math.ceil(text.length / 2)) * 16;
		var offsetY = (28 - 3) * 12;
		
		Tobor.FrameIntro2.drawBox(offsetX, offsetY, 2 + Std.int(Math.ceil(text.length / 2)), 3);
		Tobor.Font8.drawString(offsetX + 16, offsetY + 12 + 1, text, Color.BLACK);
	}
}