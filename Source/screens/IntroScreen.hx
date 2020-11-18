package screens;

import lime.graphics.Image;
import ui.DialogFiles;
import ui.Screen;
import ui.DialogMenu;

/**
 * ...
 * @author Matthias Faust
 */
class IntroScreen extends GameScreen {
	var bgSprite:Sprite;
	var SPR_NONE:Sprite;
	
	var frameTopLeft:Sprite;
	var frameBottomLeft:Sprite;
	var frameTopRight:Sprite;
	var frameBottomRight:Sprite;
	
	var frameTop:Sprite;
	var frameBottom:Sprite;
	
	var frameLeft:Sprite;
	var frameRight:Sprite;
	
	var episodeName:String;
	var episodeDesc:String;
	var centerX:Int;
	var centerXDesc:Int;
	
	var scrollingText:String;
	var scrollingPosition:Int;
	var scrollingTime:Float;
	var scrollingSpeed:Float = 0.25;
	
	public function new(game:Tobor) {
		super(game);

		game.setTitle("The Game of Tobor - " + game.world.getName());
		
		game.drawLight = false;
		
		Sound.stopMusicAll();
		
		if (game.world != null) {
			if (game.world.file.hasTexture()) {
				var bytes = game.world.file.loadFileAsBytes("tileset.png");
				var image:Image = Image.fromBytes(bytes);
				
				if (image != null) {
					if (image.width == 256 && image.height == 512) {
						Gfx.loadTextureFrom(image);
					}
				}
			}
		}
		
		bgSprite = Gfx.getSprite(160, 12, Tobor.TILE_WIDTH, Tobor.TILE_HEIGHT);
		
		SPR_NONE = Gfx.getSprite(0, 0);
		
		frameTopLeft = Gfx.getSprite(0, 240);
		frameBottomLeft = Gfx.getSprite(16, 240);
		frameBottomRight = Gfx.getSprite(32, 240);
		frameTopRight = Gfx.getSprite(48, 240);
		
		frameBottom = Gfx.getSprite(64, 240);
		frameTop = Gfx.getSprite(80, 240);
		
		frameLeft = Gfx.getSprite(96, 240, 18, 12);
		frameRight = Gfx.getSprite(126, 240, 18, 12);
		
		game.world.editing = false;
		
		episodeName = " " + game.world.getName() + " ";
		episodeDesc = " " + game.world.getDesc() + " ";
		
		centerX = Std.int(320 - (episodeName.length / 2) * 16);
		centerXDesc = Std.int(320 - (episodeDesc.length / 2) * 8);
		
		scrollingText = GetText.get("TXT_PRESS_ENTER");
		scrollingText = scrollingText.rpad(" ", 38 * 2);
		scrollingText = scrollingText + scrollingText;
		scrollingTime = scrollingSpeed;
	}
	
	function showLoadgameDialog() {
		var files = game.world.file.getSavegames();
		
		if (files.length > 0) {
			var d:DialogFiles = new DialogFiles(this, 0, 0, GetText.get("TXT_LOAD_WHICH_GAME"), files);
			
			d.onOk = function () {
				game.setScreen(new PlayScreen(game, d.getInput()));
			};
			
			showDialog(d);
		} else {
			hideDialog();
		}
	}
	
	override public function show() {
		Sound.play(Sound.MUS_INTRO_DOS, true);
	}
	
	override public function hide() {
		Sound.stop(Sound.MUS_INTRO_DOS);
	}
	
	override public function update(deltaTime:Float) {
		if (dialog != null) {
			dialog.update(deltaTime);
			return;
		}
		
		if (Input.isKeyDown([KeyCode.ESCAPE])) {
			showMainMenu();
		} else if (Input.isKeyDown([KeyCode.RETURN])) {
			showMainMenu();
		} else if (Input.mouseBtnLeft || Input.mouseBtnRight) {
			showMainMenu(Input.mouseX, Input.mouseY);
		}
		
		if (scrollingTime > 0) {
			scrollingTime = scrollingTime - deltaTime;
		} else {
			scrollingPosition++;
			if (scrollingPosition >= (scrollingText.length / 2)) {
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
	}
	
	override public function renderUI() {
		Tobor.fontBig.drawString(centerX, 36, episodeName, Color.BLACK, Color.WHITE);
		if (episodeDesc != "  ") Tobor.fontSmall.drawString(centerXDesc, 60, episodeDesc, Color.BLACK, Color.WHITE);
		
		Gfx.drawTexture(32, 60 + 24, 592 - 32, 264 - 60 - 24, SPR_NONE.uv, Color.WHITE);
		
		game.world.highScore.draw(64, 132);
		
		Gfx.drawSprite(32, 60 + 24, frameTopLeft);
		Gfx.drawSprite(32, 264, frameBottomLeft);
		
		Gfx.drawSprite(592, 60 + 24, frameTopRight);
		Gfx.drawSprite(592, 264, frameBottomRight);
		
		for (i in 1 ... 15) {
			Gfx.drawSprite(32, 60 + i * 12 + 24, frameLeft);
			
			Gfx.drawSprite(590, 60 + i * 12 + 24, frameRight);
		}
		
		for (i in 1 ... 35) {
			Gfx.drawSprite(32 + i * 16, 60 + 24, frameTop);
			
			Gfx.drawSprite(32 + i * 16, 264, frameBottom);
		}
		
		var text:String = scrollingText.substr(scrollingPosition, 38 * 2).rpad(" ", 38 * 2);
		Tobor.fontSmall.drawString(16, 27 * Tobor.TILE_HEIGHT, text, Color.DARK_RED, Color.ORANGE);
		
		super.renderUI();
	}
	
	function showMainMenu(atX:Int = 320, atY:Int = 166) {
		var menu;
		
		if (game.world.file.isZIP) {
			menu = new DialogMenu(this, atX, atY, [
				[GetText.get("TXT_MENU_STORY"), ""],
				[GetText.get("TXT_MENU_PLAY"), "", function() {
					game.setScreen(new PlayScreen(game));
				}],
				[GetText.get("TXT_MENU_LOAD"), "", function () {
					showLoadgameDialog();
				}],
				["", "", function () {
				
				}],
				[GetText.get("TXT_MENU_OPTIONS"), ">>", function () {
				showOptionMenu(atX, atY);
				}],
				["", "", function () {
				
				}],
				[GetText.get("TXT_MENU_EXIT"), "", function() {
					game.setScreen(new EpisodesScreen(game));
				}],	
			]);
			
			menu.select(1);
		} else {
			menu = new DialogMenu(this, atX, atY, [
				[GetText.get("TXT_MENU_STORY"), ""],
				[GetText.get("TXT_MENU_PLAY"), "", function() {
					game.setScreen(new PlayScreen(game));
				}],
				[GetText.get("TXT_MENU_EDIT"), "", function() {
					game.setScreen(new EditorScreen(game));
				}],
				[GetText.get("TXT_MENU_LOAD"), "", function () {
					showLoadgameDialog();
				}],
				["", "", function () {
				
				}],
				[GetText.get("TXT_MENU_OPTIONS"), ">>", function () {
				showOptionMenu(atX, atY);
				}],
				["", "", function () {
				
				}],
				[GetText.get("TXT_MENU_EXIT"), "", function() {
					game.setScreen(new EpisodesScreen(game));
				}],	
			]);
			
			menu.select(2);
		}
		
		menu.onCancel = function () {
			hideDialog();
		};
			
		menu.onOk = function () {
			hideDialog();
		};
		
		showDialog(menu);
	}
}