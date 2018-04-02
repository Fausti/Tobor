package;

import lime.Assets;
import lime.graphics.opengl.GL;
import cpp.vm.Gc;
import lime.system.Locale;
import screens.EpisodesScreen;
import ui.Font;
import ui.Frame;
import ui.Screen;
import ui.Dialog;

import core.LimeGame;
import gfx.Shader;

import gfx.Gfx;
import gfx.Texture;
import gfx.Batch;

import world.World;

/**
 * ...
 * @author Matthias Faust
 */
class Tobor extends LimeGame {
	public static inline var SCREEN_WIDTH:Int = 640;
	public static inline var SCREEN_HEIGHT:Int = 348;
	public static inline var TILE_WIDTH:Int = 16;
	public static inline var TILE_HEIGHT:Int = 12;
	
	public static var fontSmall:Font;
	public static var fontBig:Font;
	
	public static var frameSmall:Frame;
	public static var frameBig:Frame;
	public static var frameSmallNew:Frame;
	
	var screen:Screen;
	
	var texture:Texture;
	var shader:Shader;
	
	public var batch:Batch;

	public var world:World;
	
	public static var locale:String;
	public static var defaultLocale:String = "de";
	
	// Krams fürs Blinken im Editor... gehört sicherlich nicht hier her xD
	var blinkTime:Float = 1;
	public var blink(default, null):Bool = true;
	
	public function new() {
		super();
		
		CompileTime.importPackage("world.entities.std");
		
		__framebuffer_w = SCREEN_WIDTH;
		__framebuffer_h = SCREEN_HEIGHT;
		
		Tobor.locale = Locale.currentLocale.split8("_")[0];
	}
	
	override public function init() {
		Text.init();
		
		Text.load(Files.loadFromFile("translation.json"));
						
		try 
		{
			Text.load(Assets.getText("assets/translation.json"));
		}
		catch (err:Dynamic)
		{
			
		}
		
		Text.load(Files.loadFromFile("translation_missing.json"));
		
		GL.enable(GL.BLEND);
		GL.disable(GL.DEPTH_TEST);
		GL.blendFunc(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA);
		
		Files.init();
		Sound.init();
		
		Gfx.setup(SCREEN_WIDTH, SCREEN_HEIGHT);
		
		texture = Gfx.loadTexture("assets/tileset.png");
		shader = Shader.createDefaultShader();
		
		Tobor.fontSmall = new Font(8, 10, 430);
		Tobor.fontBig = new Font(16, 10, 360);
		
		Tobor.frameBig = new Frame(128, 432, 16, 12);
		Tobor.frameSmall = new Frame(128, 468, 8, 10); // original
		Tobor.frameSmallNew = new Frame(152, 468, 8, 10);
		
		batch = new Batch();
		
		// run the garbage collector
		collectGarbage();
		
		setScreen(new EpisodesScreen(this));
		// setScreen(new EditorScreen(this));
	}
	
	function collectGarbage() {
		Gc.run(true);
		Gc.compact();
	}
	
	override public function update(deltaTime:Float) {
		if (this.screen != null) {
			this.screen.update(deltaTime);
			
			blinkTime = blinkTime - deltaTime;
			if (blinkTime < 0) {
				blinkTime = blinkTime + 1;
				blink = !blink;
			}
		}
	}
	
	override public function render() {
		Gfx.setShader(shader);
		Gfx.setTexture(texture);
		
		Gfx.clear(Color.WHITE);
		Gfx.setViewport(0, 0, Tobor.SCREEN_WIDTH, Tobor.SCREEN_HEIGHT);
		
		Gfx.begin(batch);
		if (this.screen != null) {
			this.screen.render();
			this.screen.renderUI();
		}
		Gfx.end();
	}
	
	public function setScreen(newScreen:Screen) {
		if (this.screen != null) {
			this.screen.hide();
		}
		
		Input.clearKeys();
		
		this.screen = newScreen;
		this.screen.show();
	}
	
	override public function onTextInput(text:String) {
		if (this.screen != null) {
			this.screen.onTextInput(text);
		}
	}
	
	override function onExit() {
		Files.saveToFile("translation.json", Text.save());
		Files.saveToFile("translation_missing.json", Text.saveMissing());
	}
	
	public function showDialog(dialog:Dialog) {
		if (screen != null) screen.showDialog(dialog);
	}
	
	public function getScreen():Screen {
		return screen;
	}
	
	// Tasten...
	
	public static var KEY_LEFT = [Input.key.A, Input.key.LEFT];
	public static var KEY_RIGHT = [Input.key.D, Input.key.RIGHT];
	public static var KEY_UP = [Input.key.W, Input.key.UP];
	public static var KEY_DOWN = [Input.key.S, Input.key.DOWN];
	
	public static var KEY_ESC = [Input.key.ESCAPE];
	public static var KEY_ENTER = [Input.key.RETURN, Input.key.RETURN2];
}