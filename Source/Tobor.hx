package;
import gfx.Batch;
import gfx.Color;
import gfx.Font;
import gfx.Frame;
import gfx.Framebuffer;
import gfx.Gfx;
import lime.math.Rectangle;
import screens.EditorScreen;
import screens.Screen;
import gfx.Shader;
import gfx.Texture;
import gfx.Tilesheet;
import lime.graphics.GLRenderContext;
import lime.ui.Window;
import lime.utils.Float32Array;
import lime.math.Matrix4;
import lime.Assets;
import world.WorldData;
import world.entity.Entity;

import gfx.Gfx.gl;
/**
 * ...
 * @author Matthias Faust
 */
class Tobor {
	public var world:world.World;
	
	public static var Font8:Font;
	public static var Font16:Font;
	public static var Frame8:Frame;
	public static var Frame16:Frame;
	public static var Tileset:Tilesheet;
	
	var screen:Screen;
	var batchUI:Batch;
	
	// Intern
	
	var texture:Texture;
	var shader:Shader;
	var camMatrix:Matrix4;
	var running:Bool = false;
	
	var frameBuffer:Framebuffer;
	
	// Frame
	
	public function new(window:Window) {
		Tobor.window = window;
		
		// window.resize(Config.gfx.width * 2, Config.gfx.height * 2);
	}
	
	public function init() {
		frameBuffer = new Framebuffer(640, 348);
		Gfx.scaleX = frameBuffer.width / window.width;
		Gfx.scaleY = frameBuffer.height / window.height;
		
		// Texture
		
		texture = new Texture();
		texture.createFromImage(Assets.getImage("assets/tileset.png"));

		// Tileset und Fonts vorbereiten
		
		Tobor.Tileset = new Tilesheet(texture);

		WorldData.initTilesheet(Tobor.Tileset);
		
		Tobor.Font16 = new Font(16, 10, 252);
		Tobor.Font8 = new Font(8, 10, 322);
		
		Tobor.Frame16 = new Frame(128, 324, 16, 12);
		Tobor.Frame8 = new Frame(128, 360, 8, 10);
		
		// Shader
		
		shader = new Shader(Gfx.VERT_SPRITE_RAW, Gfx.FRAG_SPRITE_RAW);
		
		// Kameramatrix
		
		camMatrix = Matrix4.createOrtho(0, 640, 348, 0, -1000, 1000);
		
		if (Config.gfx.customMousePointer) {
			// Mauszeiger verstecken
			lime.ui.Mouse.hide();
		}
		
		screen = new EditorScreen(this);
	
		batchUI = new Batch(true);
	
		world = new world.World();
		
		running = true;
	}
	
	public function update(deltaTime:Float) {
		if (!running) return;
		
		screen.update(deltaTime);
	}
	
	public static inline var USE_FRAMEBUFFER:Bool = true;
	
	public function render() {
		if (!running) return;
		
		if (USE_FRAMEBUFFER) frameBuffer.bind();
		
		// Bildschirm vorbereiten und löschen
		Gfx.setOffset(0, 0);
		Gfx.setViewport(0, 0, frameBuffer.width, frameBuffer.height);
		Gfx.setColor(Color.WHITE);
		
		// Textur wählen
		gl.activeTexture (gl.TEXTURE0);
		// texture.bind();
		
		// Shader aktivieren und mit Daten füttern
		shader.use();
		gl.uniform1i(shader.u_Texture0, 0);
		gl.uniformMatrix4fv(shader.u_camMatrix, false, camMatrix);
		
		screen.render();
		
		renderUI();
		
		if (USE_FRAMEBUFFER) frameBuffer.unbind();
		
		if (USE_FRAMEBUFFER) {
			// Framebuffer darstellen
		
			Gfx.setOffset(0, 0);
			Gfx.setViewport(0, 0, window.width, window.height);
			Gfx.clear(Color.BLACK);
		
			frameBuffer.draw(window.width, window.height);
		}
	}
	
	public function resize(w:Int, h:Int) {
		Gfx.scaleX = frameBuffer.width / window.width;
		Gfx.scaleY = frameBuffer.height / window.height;
	}
	
	function renderUI() {
		Gfx.setOffset(0, 0);
		Gfx.setBatch(batchUI);
		
		batchUI.clear();
		
		screen.renderUI();
		
		// Mauszeiger
		
		if (Config.gfx.customMousePointer) {
			if (Input.mouseInside) {
				Gfx.drawTexture(
					Input.mouseX * (frameBuffer.width / window.width), 
					Input.mouseY * (frameBuffer.height / window.height), 
					16, 12, 
					Tileset.tile(14, 20)
				);
			}
		}
		
		// Frametest
		
		Frame8.drawBox(16, 12, 4, 4);
		
		batchUI.bind();
		batchUI.draw();
	}
	
	public static var Config = {
		gfx: {
			width: 640,
			height: 348,
			scale: 1,
			customMousePointer:false,
		}
	}
	
	public static var window:Window;
}