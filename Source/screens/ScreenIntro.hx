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
	
	var UI_SCROLLBAR_UP:Rectangle;
	var UI_SCROLLBAR_DOWN:Rectangle;
	var UI_SCROLLBAR_0:Rectangle;
	var UI_SCROLLBAR_1:Rectangle;
	
	var selected:Int = 0;
	
	public function new(game:Tobor) {
		super(game);
		
		SPR_WALL = Tobor.Tileset.find("SPR_MAUER_BLACK");
		
		UI_SCROLLBAR_UP = Tobor.Tileset.find("SPR_PFEIL_0");
		UI_SCROLLBAR_DOWN = Tobor.Tileset.find("SPR_PFEIL_2");
		UI_SCROLLBAR_0 = Tobor.Tileset.find("SPR_ISOLATOR");
		UI_SCROLLBAR_1 = Tobor.Tileset.find("SPR_ELEKTROZAUN");
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
					episodes.push(episode.file);
				}
			} else {
				// Wird eh nie aufgerufen, oder?^^
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
		
		if (Input.keyDown(Input.UP)) {
			Input.wait(2);
			selected--;
		}
		
		if (Input.keyDown(Input.DOWN)) {
			Input.wait(2);
			selected++;
		}
		
		if (selected < 0) selected = 0;
		if (selected >= episodes.length) selected = episodes.length - 1;
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
		
		/*
		Tobor.FrameIntro.drawBox(offsetX, offsetY, 13, 6);
		Tobor.Font16.drawString(offsetX + 16, offsetY + 12, "The Game of", Color.BLACK);
		Gfx.drawTexture(offsetX + 16 + 8, offsetY + 24 + 10, 160, 24, Tobor.Tileset.rect(0, 408, 160, 24));
		*/
		
		renderTitle();
		
		offsetX = 4 * 16;
		offsetY = offsetY + 10 * 12;
		
		Tobor.FrameIntro.drawBox(offsetX, offsetY, 32, 10);
		
		offsetX += 16;
		offsetY += 12;
		
		var begin:Int = 0;
		var max:Int = 10;
		var pos:Int = 0;
		
		// Episodenliste
		
		for (episode in episodes) {
			if (pos < max) {
				if (selected == pos) {
					Tobor.Font8.drawString(offsetX, offsetY + pos * 10, episode, Color.YELLOW, Color.BLACK);
				} else {
					Tobor.Font8.drawString(offsetX, offsetY + pos * 10, episode, Color.BLACK);
				}
			}
			
			pos++;
		}
		
		offsetX += 29 * 16;
		
		// Scrollbar
		
		for (i in 0 ... max) {
			if (i == 0) {
				Gfx.drawRect(offsetX, offsetY + i * 10, UI_SCROLLBAR_UP);
			} else if (i == (max - 1)) {
				Gfx.drawRect(offsetX, offsetY + i * 10, UI_SCROLLBAR_DOWN);
			} else {
				Gfx.drawRect(offsetX, offsetY + i * 10, UI_SCROLLBAR_0);
			}
		}
		
		// Buttons
		
		renderButtonLeft("Spielen");
		renderButtonRight("Beenden");
		
		// Dialog
		
		if (dialog != null) {
			dialog.render();
		}
	}
	
	public function renderTitle() {
		var offsetX:Int = Std.int((20 - 6.5) * 16);
		var offsetY:Int = 36;
		
		Tobor.FrameIntro.drawBox(offsetX, offsetY, 13, 6);
		Tobor.Font16.drawString(offsetX + 16, offsetY + 12, "The Game of", Color.BLACK);
		Gfx.drawTexture(offsetX + 16 + 8, offsetY + 24 + 10, 160, 24, Tobor.Tileset.rect(0, 408, 160, 24));
	}
	
	public function renderButton(offsetX:Float, offsetY:Float, text:String):Rectangle {
		text = Utf8.decode(text);
		
		Tobor.Frame8_New.drawBoxColored(Std.int(offsetX), Std.int(offsetY), 2 + text.length, 3);
		Tobor.Font8.drawString(offsetX + 8, offsetY + 10, text, Color.BLACK);
		
		return new Rectangle(offsetX, offsetY, (2 + text.length) * Tobor.Frame8_New.sizeX, 3 * Tobor.Frame8_New.sizeY);
	}
	
	public function renderButtonLeft(text:String) {
		text = Utf8.decode(text);
		
		var offsetX = 16;
		var offsetY = (28 - 3) * 12;
		
		Tobor.Frame8_New.drawBoxColored(offsetX, offsetY, 2 + text.length, 3);
		Tobor.Font8.drawString(offsetX + 8, offsetY + 10, text, Color.BLACK);
	}
	
	public function renderButtonRight(text:String) {
		text = Utf8.decode(text);
		
		var offsetX = (40 - 2) * 16 - text.length * 8;
		var offsetY = (28 - 3) * 12;
		
		Tobor.Frame8_New.drawBoxColored(offsetX, offsetY, 2 + text.length, 3);
		Tobor.Font8.drawString(offsetX + 8, offsetY + 10, text, Color.BLACK);
	}
}