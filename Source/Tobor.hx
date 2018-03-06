package;

import cpp.vm.Gc;
import screens.IntroScreen;
import screens.PlayScreen;
import screens.EpisodesScreen;
import ui.Font;
import ui.Frame;
import ui.Screen;

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
	public static inline var ZOOM:Int = 2;
	
	public static inline var SCREEN_WIDTH:Int = 640 * ZOOM;
	public static inline var SCREEN_HEIGHT:Int = 348 * ZOOM;
	public static inline var TILE_WIDTH:Int = 16 * ZOOM;
	public static inline var TILE_HEIGHT:Int = 12 * ZOOM;
	
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
	
	public function new() {
		super();
		
		__framebuffer_w = SCREEN_WIDTH;
		__framebuffer_h = SCREEN_HEIGHT;
	}
	
	override public function init() {
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
		
		world = new World();
		
		// run the garbage collector
		collectGarbage();
		
		setScreen(new EpisodesScreen(this));
	}
	
	function collectGarbage() {
		Gc.run(true);
		Gc.compact();
	}
	
	override public function update(deltaTime:Float) {
		if (this.screen != null) {
			this.screen.update(deltaTime);
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
}