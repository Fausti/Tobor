package screens;

import ui.Screen;

/**
 * ...
 * @author Matthias Faust
 */
class EpisodesScreen extends Screen {
	var bgSprite:Sprite;
	
	var SPR_NONE:Sprite;
	var SPR_WALL_BLACK:Sprite;
	
	var SPR_T:Sprite;
	var SPR_O:Sprite;
	var SPR_B:Sprite;
	var SPR_R:Sprite;
	
	var SPR_SCROLLBAR_UP:Sprite;
	var SPR_SCROLLBAR_DOWN:Sprite;
	var SPR_SCROLLBAR_0:Sprite;
	var SPR_SCROLLBAR_1:Sprite;
	
	var episoden:Array<FileEpisode> = [];
	var index:Int = 0;
	
	var scrollingText:String;
	var scrollingPosition:Int;
	var scrollingTime:Float;
	var scrollingSpeed:Float = 0.25;
	
	public function new(game:Tobor) {
		super(game);
		
		bgSprite = Gfx.getSprite(160, 0, Tobor.TILE_WIDTH, Tobor.TILE_HEIGHT);
		
		SPR_NONE = Gfx.getSprite(0, 0, Tobor.TILE_WIDTH, Tobor.TILE_HEIGHT);
		SPR_WALL_BLACK = Gfx.getSprite(48, 132, Tobor.TILE_WIDTH, Tobor.TILE_HEIGHT);
		
		SPR_T = Gfx.getSprite(0, 216, Tobor.TILE_WIDTH * 2, Tobor.TILE_HEIGHT * 2);
		SPR_O = Gfx.getSprite(32, 216, Tobor.TILE_WIDTH * 2, Tobor.TILE_HEIGHT * 2);
		SPR_B = Gfx.getSprite(64, 216, Tobor.TILE_WIDTH * 2, Tobor.TILE_HEIGHT * 2);
		SPR_R = Gfx.getSprite(96, 216, Tobor.TILE_WIDTH * 2, Tobor.TILE_HEIGHT * 2);
		
		SPR_SCROLLBAR_UP = Gfx.getSprite(112, 24);
		SPR_SCROLLBAR_DOWN = Gfx.getSprite(144, 24);
		SPR_SCROLLBAR_0 = Gfx.getSprite(240, 0);
		SPR_SCROLLBAR_1 = Gfx.getSprite(64, 12);
		
		scrollingText = "Danke an TOM Productions für ihre tollen ROBOT Spiele! ";
		scrollingText = scrollingText.rpad(38 * 2, " ");
		scrollingText = scrollingText + scrollingText;
		scrollingTime = scrollingSpeed;
		
		var files = Files.getDirsAndFiles(Files.DIR_EPISODES);
		for (path in files) {
			episoden.push(new FileEpisode(path));
		}
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
		} else if (Input.isKeyDown(Tobor.KEY_UP)) {
			index--;
			Input.wait(0.25);
		} else if (Input.isKeyDown(Tobor.KEY_DOWN)) {
			index++;
			Input.wait(0.25);
		}
		
		if (index < 0) index = 0;
		if (index >= episoden.length) index = episoden.length - 1;
		
		if (scrollingTime > 0) {
			scrollingTime = scrollingTime - deltaTime;
		} else {
			scrollingPosition++;
			if (scrollingPosition >= (scrollingText.length8() / 2)) {
				scrollingPosition = 0;
			}
			
			scrollingTime = scrollingSpeed;
		}
	}
	
	override public function render() {
		for (x in 0 ... 40) {
			for (y in 0 ... 29) {
				Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, bgSprite);
			}
		}
		
		var boxX:Int = 13;
		var boxY:Int = 1;
		var boxW:Int = 14;
		var boxH:Int = 6;
		
		Gfx.drawTexture(boxX * Tobor.TILE_WIDTH, boxY * Tobor.TILE_HEIGHT, boxW * Tobor.TILE_WIDTH, boxH * Tobor.TILE_HEIGHT, SPR_NONE.uv);
		
		Tobor.fontBig.drawString(8 + (boxX + 1) * Tobor.TILE_WIDTH, 4 + (boxY + 1) * Tobor.TILE_HEIGHT, "The game of", Color.BLACK);
		
		Gfx.drawSprite(16 + (boxX + 1) * Tobor.TILE_WIDTH, 6 + (boxY + 2) * Tobor.TILE_HEIGHT, SPR_T);
		Gfx.drawSprite(16 + (boxX + 3) * Tobor.TILE_WIDTH, 6 + (boxY + 2) * Tobor.TILE_HEIGHT, SPR_O);
		Gfx.drawSprite(16 + (boxX + 5) * Tobor.TILE_WIDTH, 6 + (boxY + 2) * Tobor.TILE_HEIGHT, SPR_B);
		Gfx.drawSprite(16 + (boxX + 7) * Tobor.TILE_WIDTH, 6 + (boxY + 2) * Tobor.TILE_HEIGHT, SPR_O);
		Gfx.drawSprite(16 + (boxX + 9) * Tobor.TILE_WIDTH, 6 + (boxY + 2) * Tobor.TILE_HEIGHT, SPR_R);
		
		for (x in boxX ... boxX + boxW) {
			Gfx.drawSprite(x * Tobor.TILE_WIDTH, boxY * Tobor.TILE_HEIGHT, SPR_WALL_BLACK);
			Gfx.drawSprite(x * Tobor.TILE_WIDTH, (boxY + boxH - 1) * Tobor.TILE_HEIGHT, SPR_WALL_BLACK);
		}
		
		for (y in boxY + 1 ... boxY + boxH - 1) {
			Gfx.drawSprite(boxX * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_WALL_BLACK);
			Gfx.drawSprite((boxX + boxW - 1) * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, SPR_WALL_BLACK);
		}
	}
	
	override public function renderUI() {
		super.renderUI();
		
		var x:Int = 2 * Tobor.TILE_WIDTH;
		var y:Int = 9 * Tobor.TILE_HEIGHT;

		Tobor.frameBig.drawBox(x, y, 36, 16);
		
		var lines:Int = 7;
		
		var begin:Int = 0;
		
		if (index >= lines) {
			begin = index - lines + 1;
		}
		
		for (i in 0 ... lines) {
			var ep:FileEpisode = episoden[i + begin];
			
			if (ep != null) {
				if ((i + begin) == index) {
					Gfx.drawTexture(x + 16, y + 12, 33 * 16, 12 * 2, SPR_NONE.uv, Color.ORANGE);
					Tobor.fontBig.drawShadowString(x + 16, y + 12, ep.getName(33), Color.ORANGE);
					Tobor.fontSmall.drawString(x + 16, y + 12 + 12, ep.getDesc(66), Color.BLACK, Color.ORANGE);
				} else {
					Tobor.fontBig.drawShadowString(x + 16, y + 12, ep.getName(33));
					Tobor.fontSmall.drawString(x + 16, y + 12 + 12, ep.getDesc(66), Color.BLACK);
				}
			}
			
			y = y + Tobor.frameBig.sizeY * 2;
		}
		
		var ps:Float = episoden.length / 12;
		var end:Int = Std.int(Math.min(episoden.length, begin + lines));
		
		for (i in 0 ... 14) {
			if (i == 0) {
				Gfx.drawSprite(4 + 36 * Tobor.TILE_WIDTH, 10 * Tobor.TILE_HEIGHT, SPR_SCROLLBAR_UP);
			} else if (i == 13) {
				Gfx.drawSprite(4 + 36 * Tobor.TILE_WIDTH, 23 * Tobor.TILE_HEIGHT, SPR_SCROLLBAR_DOWN);
			} else {
				var pos:Int = Std.int(i * ps);
				if (pos >= begin && pos <= end) {
					Gfx.drawSprite(4 + 36 * Tobor.TILE_WIDTH, (10 + i) * Tobor.TILE_HEIGHT, SPR_SCROLLBAR_0);
				} else {
					// Gfx.drawSprite(4 + 36 * Tobor.TILE_WIDTH, (10 + i) * Tobor.TILE_HEIGHT, SPR_SCROLLBAR_0);
				}
			}
		}
		
		var text:String = scrollingText.substr8(scrollingPosition, 38 * 2).rpad(38 * 2, " ");
		Tobor.fontSmall.drawString(16, 27 * Tobor.TILE_HEIGHT, text, Color.DARK_RED, Color.ORANGE);
	}
}
