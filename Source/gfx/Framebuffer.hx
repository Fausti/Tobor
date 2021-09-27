package gfx;

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
	public var textureUnit:Int;
	
	public var width:Int;
	public var height:Int;
	
	public var scaleW:Float;
	public var scaleH:Float;
	
	public var texture:GLTexture;
	public var handle:GLFramebuffer;
	public var buffer:GLBuffer;
	
	public var ready:Bool = false;
	
	public var data:UInt8Array = null;
	
	var vertices:Array<Float>;
	
	public function new(width:Int, height:Int, ?textureUnit:Int = 1) {
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
		
		texture = Gfx.gl.createTexture();
		handle = Gfx.gl.createFramebuffer();
		
		// color texture
		Gfx.gl.bindTexture(Gfx.gl.TEXTURE_2D, texture);
		
		Gfx.gl.texParameteri (Gfx.gl.TEXTURE_2D, Gfx.gl.TEXTURE_WRAP_S, Gfx.gl.CLAMP_TO_EDGE);
		Gfx.gl.texParameteri (Gfx.gl.TEXTURE_2D, Gfx.gl.TEXTURE_WRAP_T, Gfx.gl.CLAMP_TO_EDGE);
		Gfx.gl.texParameteri (Gfx.gl.TEXTURE_2D, Gfx.gl.TEXTURE_MAG_FILTER, Gfx.gl.NEAREST);
		Gfx.gl.texParameteri (Gfx.gl.TEXTURE_2D, Gfx.gl.TEXTURE_MIN_FILTER, Gfx.gl.NEAREST);	
		
		Gfx.gl.texImage2D(Gfx.gl.TEXTURE_2D, 0, Gfx.gl.RGBA, width, height, 0, Gfx.gl.RGBA, Gfx.gl.UNSIGNED_BYTE, new UInt8Array(4 * width * height));
		
		// construct framebuffer
		Gfx.gl.bindFramebuffer(Gfx.gl.FRAMEBUFFER, handle);
		Gfx.gl.framebufferTexture2D(Gfx.gl.FRAMEBUFFER, Gfx.gl.COLOR_ATTACHMENT0, Gfx.gl.TEXTURE_2D, texture, 0);
	
		// unbind
		Gfx.gl.bindFramebuffer(Gfx.gl.FRAMEBUFFER, null);
		// GL.bindTexture(GL.TEXTURE_2D, null);
		
		// check
		var result:Int = Gfx.gl.checkFramebufferStatus(Gfx.gl.FRAMEBUFFER);
		if (result != Gfx.gl.FRAMEBUFFER_COMPLETE) {

			Gfx.gl.deleteFramebuffer(handle);

			if (result == Gfx.gl.FRAMEBUFFER_INCOMPLETE_ATTACHMENT)
				throw "frame buffer couldn't be constructed: incomplete attachment";
			if (result == Gfx.gl.FRAMEBUFFER_INCOMPLETE_DIMENSIONS)
				throw "frame buffer couldn't be constructed: incomplete dimensions";
			if (result == Gfx.gl.FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT)
				throw "frame buffer couldn't be constructed: missing attachment";
			if (result == Gfx.gl.FRAMEBUFFER_UNSUPPORTED)
				throw "frame buffer couldn't be constructed: unsupported combination of formats";
			throw "frame buffer couldn't be constructed: unknown error " + result;
		}
		
		ready = true;
		
		buffer = Gfx.gl.createBuffer();
		
		var x0 = 0;
		var x1 = scaleW;
		var y0 = 0;
		var y1 = scaleH;
		
		vertices = [
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
		
		Gfx.gl.bindBuffer(Gfx.gl.ARRAY_BUFFER, buffer);
		// Gfx.gl.bufferData(Gfx.gl.ARRAY_BUFFER, vertices.length * Float32Array.BYTES_PER_ELEMENT, new Float32Array(vertices), Gfx.gl.STATIC_DRAW);
		Gfx.gl.bufferData(Gfx.gl.ARRAY_BUFFER, new Float32Array(vertices), Gfx.gl.STATIC_DRAW);
		Gfx.gl.bindBuffer(Gfx.gl.ARRAY_BUFFER, null);
	}
	
	public function bind() {
		if (!ready) return;
		
		Gfx.gl.bindFramebuffer(Gfx.gl.FRAMEBUFFER, handle);
	}
	
	public function unbind() {
		if (!ready) return;
		
		Gfx.gl.bindFramebuffer(Gfx.gl.FRAMEBUFFER, null);
	}
	
	public function draw(w:Int, h:Int, ?c:Color = null) {
		Gfx.gl.bindTexture(Gfx.gl.TEXTURE_2D, texture);
		
		Gfx.gl.uniform1i(Shader.current.u_Texture0, 0);
		Gfx.gl.uniformMatrix4fv(Shader.current.u_camMatrix, false, Gfx._matrix_framebuffer);
		
		Gfx.gl.bindBuffer(Gfx.gl.ARRAY_BUFFER, buffer);
		
		if (c != null) {
			for (i in 0 ... 6) {
				vertices[i * 8 + 4] = c.r;
				vertices[i * 8 + 5] = c.g;
				vertices[i * 8 + 6] = c.b;
				vertices[i * 8 + 7] = c.a;
			}
			
			// Gfx.gl.bufferData(Gfx.gl.ARRAY_BUFFER, vertices.length * Float32Array.BYTES_PER_ELEMENT, new Float32Array(vertices), Gfx.gl.STATIC_DRAW);
			Gfx.gl.bufferData(Gfx.gl.ARRAY_BUFFER, new Float32Array(vertices), Gfx.gl.STATIC_DRAW);
		}
		
		Shader.current.setAttribute(Shader.current.a_Position, 2, Gfx.gl.FLOAT, 8 * Float32Array.BYTES_PER_ELEMENT, 0);
		Shader.current.setAttribute(Shader.current.a_TexCoord0, 2, Gfx.gl.FLOAT, 8 * Float32Array.BYTES_PER_ELEMENT, 2 * Float32Array.BYTES_PER_ELEMENT);
		Shader.current.setAttribute(Shader.current.a_Color, 4, Gfx.gl.FLOAT, 8 * Float32Array.BYTES_PER_ELEMENT, 4 * Float32Array.BYTES_PER_ELEMENT);
		
		Gfx.gl.drawArrays(Gfx.gl.TRIANGLES, 0, 6);
		
		Gfx.gl.bindBuffer(Gfx.gl.ARRAY_BUFFER, null);
		Gfx.gl.bindTexture(Gfx.gl.TEXTURE_2D, null);
	}
}