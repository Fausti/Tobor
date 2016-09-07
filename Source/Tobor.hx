package;
import gfx.Batch;
import gfx.Color;
import gfx.Gfx;
import gfx.Screen;
import gfx.Shader;
import gfx.Texture;
import lime.graphics.GLRenderContext;
import lime.ui.Window;
import lime.utils.Float32Array;
import lime.math.Matrix4;
import lime.Assets;

import gfx.Gfx.gl;
/**
 * ...
 * @author Matthias Faust
 */
class Tobor {
	var screen:Screen;
	var batchUI:Batch;
	
	// Intern
	
	var texture:Texture;
	var shader:Shader;
	var camMatrix:Matrix4;
	var running:Bool = false;
	
	public function new(window:Window) {
		Tobor.window = window;
		
		// window.resize(Config.gfx.width, Config.gfx.height);
	}
	
	public function init() {
		// Texture
		
		texture = new Texture();
		texture.updateFromImage(Assets.getImage("assets/tileset.png"));
		
		Gfx.generateRects(texture.width, texture.height);
		
		// Shader
		
		shader = new Shader(Gfx.VERT_SPRITE_RAW, Gfx.FRAG_SPRITE_RAW);
		
		// Kameramatrix
		
		camMatrix = Matrix4.createOrtho(0, 640, 348, 0, -1000, 1000);
		
		// Mauszeiger verstecken
		
		lime.ui.Mouse.hide();
		
		screen = new Screen(Config.gfx);
	
		batchUI = new Batch(true);
		
		running = true;
	}
	
	public function update(deltaTime:Float) {
		if (!running) return;
		
		screen.update(deltaTime);
	}
	
	public function render() {
		if (!running) return;
		
		// Bildschirm vorbereiten und löschen
		Gfx.setViewport(0, 0, window.width, window.height);
		Gfx.setColor(Color.WHITE);
		
		// Textur wählen
		texture.bind();
		gl.activeTexture (gl.TEXTURE0);
		
		// Shader aktivieren und mit Daten füttern
		shader.use();
		gl.uniform1i(shader.u_Texture0, 0);
		gl.uniformMatrix4fv(shader.u_camMatrix, false, camMatrix);
		
		screen.render();
		
		renderUI();
	}
	
	function renderUI() {
		Gfx.setOffset(0, 0);
		Gfx.setBatch(batchUI);
		
		batchUI.clear();

		// Mauszeiger
		
		if (Input.mouseInside) Gfx.drawTexture(Input.mouseX, Input.mouseY, 16, 12, Gfx.tile(14, 20));
		
		batchUI.bind();
		batchUI.draw();
	}
	
	public static var Config = {
		gfx: {
			width: 640,
			height: 348,
		}
	}
	
	public static var window:Window;
}