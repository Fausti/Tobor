package gfx;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLFramebuffer;
import lime.graphics.opengl.GLTexture;
import gfx.Gfx.gl;
import lime.math.Matrix4;
import lime.utils.Float32Array;

/**
 * ...
 * @author Matthias Faust
 */
class Framebuffer {
	public var width:Int;
	public var height:Int;
	
	public var scaleW:Float;
	public var scaleH:Float;
	
	public var matrix:Matrix4;
	
	public var texture:GLTexture;
	public var handle:GLFramebuffer;
	public var buffer:GLBuffer;
	
	public var ready:Bool = false;
	
	public function new(width:Int, height:Int) {
		// gewünschte Größe merken
		
		this.width = width;
		this.height = height;
		
		// Größe anpassen für WebGL (powerOfTwo)
		
		var size:Int = 2;
		while (size < width) {
			size = size * 2;
		}
		
		width = size;
		
		size = 2;
		while (size < height) {
			size = size * 2;
		}
		
		height = size;
		
		scaleW = width / this.width;
		scaleH = height / this.height;
		
		texture = gl.createTexture();
		handle = gl.createFramebuffer();
		
		// color texture
		gl.activeTexture(gl.TEXTURE1);
		gl.bindTexture(gl.TEXTURE_2D, texture);
		
		gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
		gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
		gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
		gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);	
		
		gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, width, height, 0, gl.RGBA, gl.UNSIGNED_BYTE, null);
		
		// construct framebuffer
		gl.bindFramebuffer(gl.FRAMEBUFFER, handle);
		gl.framebufferTexture2D(gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, gl.TEXTURE_2D, texture, 0);
	
		// unbind
		gl.bindFramebuffer(gl.FRAMEBUFFER, null);
		// gl.bindTexture(gl.TEXTURE_2D, null);
		
		// check
		var result:Int = gl.checkFramebufferStatus(gl.FRAMEBUFFER);
		if (result != gl.FRAMEBUFFER_COMPLETE) {

			gl.deleteFramebuffer(handle);

			if (result == gl.FRAMEBUFFER_INCOMPLETE_ATTACHMENT)
				throw "frame buffer couldn't be constructed: incomplete attachment";
			if (result == gl.FRAMEBUFFER_INCOMPLETE_DIMENSIONS)
				throw "frame buffer couldn't be constructed: incomplete dimensions";
			if (result == gl.FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT)
				throw "frame buffer couldn't be constructed: missing attachment";
			if (result == gl.FRAMEBUFFER_UNSUPPORTED)
				throw "frame buffer couldn't be constructed: unsupported combination of formats";
			throw "frame buffer couldn't be constructed: unknown error " + result;
		}
		
		ready = true;
		
		buffer = gl.createBuffer();
		
		var x0 = 0;
		var x1 = scaleW;
		var y0 = 0;
		var y1 = scaleH;
		
		var vertices:Array<Float> = [
			x0, y0, 			
			0, 0, 	
			1, 1, 1, 1,
		
			x0, y1, 		
			0, 1, 	
			1, 1, 1, 1,
		
			x1, y1, 	
			1, 1,
			1, 1, 1, 1,
			
			x1, y1, 	
			1, 1,
			1, 1, 1, 1,
		
			x1, y0, 		
			1, 0, 	
			1, 1, 1, 1,
			
			x0, y0, 			
			0, 0, 	
			1, 1, 1, 1,
		];
		
		gl.bindBuffer(gl.ARRAY_BUFFER, buffer);
		gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW);
		gl.bindBuffer(gl.ARRAY_BUFFER, null);
		
		matrix = Matrix4.createOrtho(0, 1, 0, 1, -1000, 1000);
		// matrix = Matrix4.createOrtho(0, this.width, 0, this.height, -1000, 1000);
	}
	
	public function bind() {
		if (!ready) return;
		
		gl.bindFramebuffer(gl.FRAMEBUFFER, handle);
	}
	
	public function unbind() {
		if (!ready) return;
		
		gl.bindFramebuffer(gl.FRAMEBUFFER, null);
	}
	
	public function draw(w:Int, h:Int) {
		gl.activeTexture(gl.TEXTURE1);
		// gl.bindTexture(gl.TEXTURE_2D, texture);
		
		gl.uniform1i(Gfx.shader.u_Texture0, 1);
		gl.uniformMatrix4fv(Gfx.shader.u_camMatrix, false, matrix);
		
		gl.bindBuffer(gl.ARRAY_BUFFER, buffer);
		
		Gfx.shader.setAttribute(Gfx.shader.a_Position, 2, gl.FLOAT, 8 * Float32Array.BYTES_PER_ELEMENT, 0);
		Gfx.shader.setAttribute(Gfx.shader.a_TexCoord0, 2, gl.FLOAT, 8 * Float32Array.BYTES_PER_ELEMENT, 2 * Float32Array.BYTES_PER_ELEMENT);
		Gfx.shader.setAttribute(Gfx.shader.a_Color, 4, gl.FLOAT, 8 * Float32Array.BYTES_PER_ELEMENT, 4 * Float32Array.BYTES_PER_ELEMENT);
		
		gl.drawArrays(gl.TRIANGLES, 0, 6);
		
		gl.bindBuffer(gl.ARRAY_BUFFER, null);
		// gl.bindTexture(gl.TEXTURE_2D, null);
	}
}