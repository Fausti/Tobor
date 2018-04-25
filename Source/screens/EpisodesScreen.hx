package screens;

import ui.DialogMessage;
import ui.DialogInput;
import ui.Screen;
import world.World;
import lime.math.Rectangle;

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
	var oldPos:Int = -1;
	var mouseOver:Int = -1;
	
	var scrollingText:String;
	var scrollingPosition:Int;
	var scrollingTime:Float;
	var scrollingSpeed:Float = 0.25;
	
	var maxLines:Int = 7;
	var begin:Int = 0;
	
	var rectUp:Rectangle;
	var rectDown:Rectangle;
	
	public function new(game:Tobor) {
		super(game);
		
		Gfx.resetTexture();
		
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
		
		rectUp = new Rectangle(4 + 36 * 16, 10 * 12, 16 ,12);
		rectDown = new Rectangle(4 + 36 * 16, 23 * 12, 16, 12);
		
		updateFileList();
	}
	
	function updateFileList() {
		episoden = [];
		
		var files = Files.getDirsAndFiles(Files.DIR_EPISODES);
		for (path in files) {
			if (FileEpisode.isZipFile(path) || FileEpisode.isDirectory(path)) {
				var fe:FileEpisode = new FileEpisode(path);
				if (fe.isOK) episoden.push(fe);
			}
		}
		
		// Editor - Episode xD
		var fe:FileEpisode = new FileEpisode(null);
		episoden.push(fe);
	}
	
	override public function show() {
		Sound.play(Sound.MUS_CHOOSER, true);
	}
	
	override public function hide() {
		Sound.stop(Sound.MUS_CHOOSER);
	}
	
	function showError(str:String) {
		var d:DialogMessage = new DialogMessage(this, 0, 0, str);
		
		showDialog(d);
	}
	
	function showEpisodeInstalled(fileName:String) {
		var msg:String = Text.get("TXT_NEW_EPISODE_INSTALLED") + "\n\n" + fileName;
		
		var d:DialogMessage = new DialogMessage(this, 0, 0, msg, true);
		
		showDialog(d);
	}
	
	override public function onDropFile(fileName:String) {
		if (FileEpisode.isEpisodeFile(fileName)) {
			FileEpisode.install(fileName);
			updateFileList();
			showEpisodeInstalled(fileName);
		}
	}
	
	function createEpisode() {
		var d:DialogInput = new DialogInput(this, 0, 0, Text.get("TXT_ASK_FOR_EPISODE_NAME"));
		
		d.onOk = function () {
			var fileName:String = d.getInput(true);
			
			if (fileName == "") {
				hideDialog();
				return;
			}
			
			var ret:String = episoden[index].create(fileName);
			
			if (ret != null) {
				showError(ret);
				return;
			}
			
			if (episoden[index].isOK) {
				game.world = new World(game, episoden[index]);
				game.setScreen(new IntroScreen(game));
			}
		};
		
		showDialog(d);
	}
	
	override public function update(deltaTime:Float) {
		if (dialog != null) {
			dialog.update(deltaTime);
		} else {
			if (Input.mouseX >= 48 && Input.mouseX < 48 + 528 && Input.mouseY >= 120 && Input.mouseY < 120 + 7 * 24) {
				var pos:Int = Std.int((Input.mouseY - 120) / 24);

				if (pos >= 0 && pos < maxLines) {
					mouseOver = pos;

				}
			} else {
				mouseOver = -1;
			}
		
			if (Input.isKeyDown([Input.key.ESCAPE])) {
				game.exit();
			} else if (Input.isKeyDown([Input.key.RETURN])) {
				chooseEpisode();
				return;
			} else if (Input.isKeyDown(Tobor.KEY_UP) || Input.wheelUp()) {
				index--;
				Input.wait(0.25);
			} else if (Input.isKeyDown(Tobor.KEY_DOWN) || Input.wheelDown()) {
				index++;
				Input.wait(0.25);
			}
		}
		
		fixIndex();
		
		if (Input.mouseBtnLeft) {
			if (Input.mouseX >= 48 && Input.mouseX < 48 + 528 && Input.mouseY >= 120 && Input.mouseY < 120 + 7 * 24) {
				var pos:Int = Std.int((Input.mouseY - 120) / 24);
				if (pos >= 0 && pos < maxLines) {
					if (oldPos != pos) {
						oldPos = pos;
						index = pos + begin;
						chooseEpisode();
					}
				}
				return;
			} else if (rectUp.contains(Input.mouseX, Input.mouseY)) {
				if (begin > 0) {
					begin--;
					index--;
				
					fixIndex();
				}
				
				Input.clearKeys();
			} else if (rectDown.contains(Input.mouseX, Input.mouseY)) {
				if (begin + 6 < episoden.length - 1) {
					begin++;
					index++;
				
					fixIndex();
				}
				
				Input.clearKeys();
			}
		}
				
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
	
	function fixIndex() {
		if (begin < 0) begin = 0;
		if (index < 0) index = 0;
		
		if (index >= episoden.length) index = episoden.length - 1;
		
		if (index >= maxLines) {
			begin = index - maxLines + 1;
		}
		
		while ((begin > index) || (begin < 0)) {
			begin--;
		}
	}
	
	function chooseEpisode() {
		if (episoden[index].isEditor) {
			createEpisode();
			return;
		} else {
			game.world = new World(game, episoden[index]);
			game.setScreen(new IntroScreen(game));
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
		var x:Int = 2 * Tobor.TILE_WIDTH;
		var y:Int = 9 * Tobor.TILE_HEIGHT;

		Tobor.frameBig.drawBox(x, y, 36, 16);
		
		/*
		if (index >= maxLines) {
			begin = index - maxLines + 1;
		}
		*/
		
		for (i in 0 ... maxLines) {
			var ep:FileEpisode = episoden[i + begin];
			
			if (ep != null) {
				if ((i + begin) == index) {
					if (i == mouseOver) {
						Gfx.drawTexture(x + 16, y + 12, 33 * 16, 12 * 2, SPR_NONE.uv, Color.NEON_GREEN);
						Tobor.fontBig.drawShadowString(x + 16, y + 12, ep.getName(33), Color.NEON_GREEN);
						Tobor.fontSmall.drawString(x + 16, y + 12 + 12, ep.getDesc(66), Color.BLACK, Color.NEON_GREEN);
					} else {
						Gfx.drawTexture(x + 16, y + 12, 33 * 16, 12 * 2, SPR_NONE.uv, Color.ORANGE);
						Tobor.fontBig.drawShadowString(x + 16, y + 12, ep.getName(33), Color.ORANGE);
						Tobor.fontSmall.drawString(x + 16, y + 12 + 12, ep.getDesc(66), Color.BLACK, Color.ORANGE);
					}

				} else {
					if (i == mouseOver) {
						Gfx.drawTexture(x + 16, y + 12, 33 * 16, 12 * 2, SPR_NONE.uv, Color.NEON_GREEN);
					}
					
					Tobor.fontBig.drawShadowString(x + 16, y + 12, ep.getName(33));
					Tobor.fontSmall.drawString(x + 16, y + 12 + 12, ep.getDesc(66), Color.BLACK);
				}
			}
			
			y = y + Tobor.frameBig.sizeY * 2;
		}
		
		var ps:Float = episoden.length / 12;
		var end:Int = Std.int(Math.min(episoden.length, begin + maxLines));
		
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
		
		super.renderUI();
	}
}
