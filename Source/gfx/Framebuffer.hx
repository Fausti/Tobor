package gfx;

import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLFramebuffer;
import lime.graphics.opengl.GLTexture;

import lime.math.Matrix4;
import lime.utils.Float32Array;
import lime.utils.UInt8Array;

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
		
		texture = GL.createTexture();
		handle = GL.createFramebuffer();
		
		// color texture
		GL.activeTexture(GL.TEXTURE1);
		GL.bindTexture(GL.TEXTURE_2D, texture);
		
		GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
		GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
		GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
		GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST);	
		
		GL.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, width, height, 0, GL.RGBA, GL.UNSIGNED_BYTE, new UInt8Array(4 * width * height));
		
		// construct framebuffer
		GL.bindFramebuffer(GL.FRAMEBUFFER, handle);
		GL.framebufferTexture2D(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.TEXTURE_2D, texture, 0);
	
		// unbind
		GL.bindFramebuffer(GL.FRAMEBUFFER, null);
		// GL.bindTexture(GL.TEXTURE_2D, null);
		
		// check
		var result:Int = GL.checkFramebufferStatus(GL.FRAMEBUFFER);
		if (result != GL.FRAMEBUFFER_COMPLETE) {

			GL.deleteFramebuffer(handle);

			if (result == GL.FRAMEBUFFER_INCOMPLETE_ATTACHMENT)
				throw "frame buffer couldn't be constructed: incomplete attachment";
			if (result == GL.FRAMEBUFFER_INCOMPLETE_DIMENSIONS)
				throw "frame buffer couldn't be constructed: incomplete dimensions";
			if (result == GL.FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT)
				throw "frame buffer couldn't be constructed: missing attachment";
			if (result == GL.FRAMEBUFFER_UNSUPPORTED)
				throw "frame buffer couldn't be constructed: unsupported combination of formats";
			throw "frame buffer couldn't be constructed: unknown error " + result;
		}
		
		ready = true;
		
		buffer = GL.createBuffer();
		
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
		
		GL.bindBuffer(GL.ARRAY_BUFFER, buffer);
		GL.bufferData(GL.ARRAY_BUFFER, vertices.length * Float32Array.BYTES_PER_ELEMENT, new Float32Array(vertices), GL.STATIC_DRAW);
		GL.bindBuffer(GL.ARRAY_BUFFER, null);
		
		matrix = Matrix4.createOrtho(0, 1, 0, 1, -1000, 1000);
		// matrix = Matrix4.createOrtho(0, this.width, 0, this.height, -1000, 1000);
	}
	
	public function bind() {
		if (!ready) return;
		
		GL.bindFramebuffer(GL.FRAMEBUFFER, handle);
	}
	
	public function unbind() {
		if (!ready) return;
		
		GL.bindFramebuffer(GL.FRAMEBUFFER, null);
	}
	
	public function draw(w:Int, h:Int) {
		GL.activeTexture(GL.TEXTURE1);
		// GL.bindTexture(GL.TEXTURE_2D, texture);
		
		GL.uniform1i(Shader.current.u_Texture0, 1);
		GL.uniformMatrix4fv(Shader.current.u_camMatrix, 1, false, matrix);
		
		GL.bindBuffer(GL.ARRAY_BUFFER, buffer);
		
		Shader.current.setAttribute(Shader.current.a_Position, 2, GL.FLOAT, 8 * Float32Array.BYTES_PER_ELEMENT, 0);
		Shader.current.setAttribute(Shader.current.a_TexCoord0, 2, GL.FLOAT, 8 * Float32Array.BYTES_PER_ELEMENT, 2 * Float32Array.BYTES_PER_ELEMENT);
		Shader.current.setAttribute(Shader.current.a_Color, 4, GL.FLOAT, 8 * Float32Array.BYTES_PER_ELEMENT, 4 * Float32Array.BYTES_PER_ELEMENT);
		
		GL.drawArrays(GL.TRIANGLES, 0, 6);
		
		GL.bindBuffer(GL.ARRAY_BUFFER, null);
		// GL.bindTexture(GL.TEXTURE_2D, null);
	}
}