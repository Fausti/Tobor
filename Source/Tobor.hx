package;

import gfx.Framebuffer;
import lime.math.Rectangle;
import lime.system.Locale;
import screens.EpisodesScreen;
import ui.Font;
import ui.Frame;
import ui.Screen;
import ui.Dialog;
import lime.graphics.Image;
import lime.graphics.opengl.GLUniformLocation;

import lime.utils.Assets;

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
	
	// Lightmap
	public var drawLight:Bool = false;
	
	public var lightBuffer:Framebuffer;
	
	public var lightShader:Shader;
	private var lightShader_u_Mode:GLUniformLocation;
	private var lightShader_u_Scale:GLUniformLocation;
	private var lightShader_u_Center:GLUniformLocation;
	private var lightShader_u_Radius:GLUniformLocation;
	private var lightShader_u_InputSize:GLUniformLocation;
	private var lightShader_u_OutputSize:GLUniformLocation;
	
	var SPR_LIGHT_OVERLAY:Sprite;
	public var lightColor:Color;
	var listLights:Array<Rectangle>;

	var SPR_NONE:Sprite;
	
	public function new() {
		super();
		
		// CompileTime.importPackage("world.entities.std");
		
		__framebuffer_w = SCREEN_WIDTH;
		__framebuffer_h = SCREEN_HEIGHT;

		// MacOS Fix:

		// Tobor.locale = cast(Locale.currentLocale, String).split("_")[0];
		Tobor.locale = Locale.currentLocale.language;
	}
	
	override public function init() {
		// FrameBuffer für Lightmap erstellen
		lightBuffer = new Framebuffer(Tobor.SCREEN_WIDTH, Tobor.SCREEN_HEIGHT, 2);
		
		lightShader = Shader.createShaderFrom(Assets.getText("assets/light.vert"), Assets.getText("assets/light.frag"));
		lightShader_u_Scale = lightShader.getUniformLocation("u_Scale");
		lightShader_u_Mode = lightShader.getUniformLocation("u_Mode");
		lightShader_u_Center = lightShader.getUniformLocation("u_Center");
		lightShader_u_Radius = lightShader.getUniformLocation("u_Radius");
		lightShader_u_InputSize = lightShader.getUniformLocation("u_InputSize");
		lightShader_u_OutputSize = lightShader.getUniformLocation("u_OutputSize");
		
		Config.init();
		
		GetText.init();
		
		GetText.loadJson(Files.loadFromFile("translation.json"));
		
		try {
			GetText.load(Assets.getText("assets/lang." + defaultLocale));
		}
		catch (err:Dynamic)	{
			trace(err);
		}
		
		GetText.load(Files.loadFromFile("lang." + defaultLocale));
		GetText.load(Files.loadFromFile("missing." + defaultLocale));
		
		Gfx.gl.enable(Gfx.gl.BLEND);
		Gfx.gl.disable(Gfx.gl.DEPTH_TEST);
		Gfx.gl.blendFunc(Gfx.gl.SRC_ALPHA, Gfx.gl.ONE_MINUS_SRC_ALPHA);
		
		Files.init();
		Sound.init();
		
		Gfx.setup(SCREEN_WIDTH, SCREEN_HEIGHT);
		
		/*
		var bytes = Files.loadFileAsBytes("tileset.png");
		
		if (bytes != null) {
			var image:Image = Image.fromBytes(bytes);
				
			if (image != null) {
				if (image.width == 256 && image.height == 512) {
					texture = Gfx.loadTextureFrom(image);
				}
			}
		}
		*/
		
		if (texture == null) texture = Gfx.loadTexture("assets/tileset.png", "assets/tileset-extra.png");
		
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
		
		SPR_LIGHT_OVERLAY = Gfx.getSprite(176, 456, 64, 48);
		lightColor = new Color(0, 0, 0, 1);

		SPR_NONE = Gfx.getSprite(0, 0);
	}
	
	public function loadTilesets(fileName1:String, fileName2:String):Texture {
		return null;
	}
	
	function collectGarbage() {
		// Gc.run(true);
		// Gc.compact();
	}
	
	override public function update(deltaTime:Float) {
		listLights = [];
		
		if (this.screen != null) {
			this.screen.update(deltaTime);
			
			blinkTime = blinkTime - deltaTime;
			if (blinkTime < 0) {
				blinkTime = blinkTime + 1;
				blink = !blink;
			}
			
			if (Input.isKeyDown([KeyCode.PRINT_SCREEN, KeyCode.F12])) {
				takeScreenShot();
				Input.clearKeys();
			}
		}
	}
	
	public function addLight(x:Float, y:Float, radius:Float) {
		listLights.push(
			new Rectangle(
				(x - radius) * Tobor.TILE_WIDTH, 
				(y - radius) * Tobor.TILE_HEIGHT, 
				radius * 2 * Tobor.TILE_WIDTH, 
				radius * 2 * Tobor.TILE_HEIGHT
			)
		);
	}
	
	override public function render() {
		Gfx.setShader(shader);
		Gfx.setTexture(Gfx._texture); // texture
		
		Gfx.setViewport(0, 0, Tobor.SCREEN_WIDTH, Tobor.SCREEN_HEIGHT);
		Gfx.clear(Color.BLACK);

		// Spielfeld zeichnen
		Gfx.begin(batch);
			// Weißen Hintergrund zeichnen
			Gfx.drawTexture(0, 0, Tobor.SCREEN_WIDTH, Tobor.SCREEN_HEIGHT, SPR_NONE.uv, Color.WHITE);

		if (this.screen != null) {
			this.screen.render();
		}
		Gfx.end();
		
		if (drawLight) {
			// in lightBuffer zeichnen
			Gfx.setShader(lightShader);
			lightBuffer.bind();
			
			Gfx.gl.uniform1i(lightShader_u_Mode, Config.light);
			
			Gfx.gl.uniform2f(lightShader_u_Scale, 1, 1);
			Gfx.gl.uniform2f(lightShader_u_OutputSize, Tobor.SCREEN_WIDTH, Tobor.SCREEN_HEIGHT);
			Gfx.gl.uniform2f(lightShader_u_InputSize, Tobor.SCREEN_WIDTH, Tobor.SCREEN_HEIGHT);
			Gfx.gl.uniform1i(Shader.current.u_Texture0, 0);
			
			Gfx.setViewport(0, 0, Tobor.SCREEN_WIDTH, Tobor.SCREEN_HEIGHT);
			
			Gfx.gl.blendFunc(Gfx.gl.ONE, Gfx.gl.ONE); // ONE_ONE
		
			Gfx.clear(lightColor);  // 0, 0, 0, 1
			
			// Gfx.begin(batch);
			
			// Gfx.drawSprite(0, 0, SPR_LIGHT_OVERLAY);
			// Gfx.drawSprite(24, 24, SPR_LIGHT_OVERLAY);
			// Gfx.drawTexture(64, 64, 8 * 16, 8 * 12, SPR_LIGHT_OVERLAY.uv);
			
			if (listLights != null) {
				for (rect in listLights) {
					Gfx.gl.uniform2f(lightShader_u_Center, rect.x + rect.width / 2, Tobor.SCREEN_HEIGHT - (rect.y + rect.height / 2) - 12);
					Gfx.gl.uniform2f(lightShader_u_Radius, rect.width / 2, rect.height / 2);
					
					Gfx.begin(batch);
					Gfx.drawTexture(rect.x, rect.y, rect.width, rect.height, SPR_LIGHT_OVERLAY.uv);
					Gfx.end();
				}
			}
			
			// Gfx.end();
			
			lightBuffer.unbind();
		
			// lightBuffer zeichnen
			Gfx.setShader(shader);
			getFrameBuffer().bind();
			Gfx.gl.uniform1i(Shader.current.u_Texture0, 0);
			
			Gfx.gl.blendFunc(Gfx.gl.DST_COLOR, Gfx.gl.ZERO);
			lightBuffer.draw(Tobor.SCREEN_WIDTH, Tobor.SCREEN_HEIGHT);
		
			Gfx.gl.uniform1i(Shader.current.u_Texture0, 0);
			// Gfx.setShader(shader);
			Gfx.setViewport(0, 0, Tobor.SCREEN_WIDTH, Tobor.SCREEN_HEIGHT);
			Gfx.setTexture(Gfx._texture);
		}
		
		Gfx.gl.blendFunc(Gfx.gl.SRC_ALPHA, Gfx.gl.ONE_MINUS_SRC_ALPHA);
		
		// UI zeichnen
		Gfx.begin(batch);
		if (this.screen != null) {
			this.screen.renderUI();
		}
		Gfx.end();
	}
	
	public function setTitle(?title:String = null) {
		if (title == null) {
			title = "The Game of Tobor - Version B" + __application.meta.get('version');
		}
		
		title = title.replaceAll("ä", "ae");
		title = title.replaceAll("ö", "oe");
		title = title.replaceAll("ü", "ue");
		title = title.replaceAll("ß", "ss");
		title = title.replaceAll("Ä", "Ae");
		title = title.replaceAll("Ö", "Oe");
		title = title.replaceAll("Ü", "Ue");
		
		var caption:StringBuf = new StringBuf();
		caption.addSub(title, 0, title.length);
		
		__application.window.title = caption.toString();
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
		Files.saveToFile("lang." + Tobor.defaultLocale, GetText.save());
		Files.saveToFile("missing." + Tobor.defaultLocale, GetText.saveMissing());
	}
	
	public function showDialog(dialog:Dialog) {
		if (screen != null) screen.showDialog(dialog);
	}
	
	public function getScreen():Screen {
		return screen;
	}
	
	override public function onDropFile(fileName:String) {
		if (screen != null) screen.onDropFile(fileName);
	}
	
	// Tasten...
	
	public static var KEY_LEFT = [KeyCode.A, KeyCode.LEFT];
	public static var KEY_RIGHT = [KeyCode.D, KeyCode.RIGHT];
	public static var KEY_UP = [KeyCode.W, KeyCode.UP];
	public static var KEY_DOWN = [KeyCode.S, KeyCode.DOWN];
	
	public static var KEY_ESC = [KeyCode.ESCAPE];
	public static var KEY_ENTER = [KeyCode.RETURN, KeyCode.RETURN2];
	
	public static var KEY_SPACE = [KeyCode.SPACE];
}