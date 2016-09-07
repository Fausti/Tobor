package gfx;
import lime.graphics.Image;
import lime.graphics.opengl.GLTexture;
import lime.math.Rectangle;
import lime.utils.UInt8Array;

import gfx.Gfx.gl;

/**
 * ...
 * @author Matthias Faust
 */
class Texture {
	public var handle:GLTexture;
		
	private var _width:Int;
	private var _height:Int;
	
	public var width(get, null):Int;
	function get_width():Int {
		return _width;
	}
	
	public var height(get, null):Int;
	function get_height():Int {
		return _height;
	}
	
	private var data:UInt8Array = null;
	
	public function new() {
		handle = gl.createTexture();
	}
	
	public function bind() {
		gl.activeTexture(gl.TEXTURE0);
		gl.bindTexture(gl.TEXTURE_2D, handle);
	}
	
	public function prepare() {
		gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
		gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
		gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
		gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
	}
	
	public function createFromImage(img:Image) {
		this._width = img.width;
		this._height = img.height;
		
		bind();
		prepare();
		
		#if js
			gl.texImage2D (gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, img.src);
		#else
			gl.texImage2D (gl.TEXTURE_2D, 0, gl.RGBA, img.buffer.width, img.buffer.height, 0, gl.RGBA, gl.UNSIGNED_BYTE, img.data);
		#end
	}
	
	// Custom texture stuff
	
	public function createFromArray(widthArray:Int, heightArray:Int) {
		this._width = widthArray;
		this._height = heightArray;
		
		bind();
		prepare();
		
		data = new UInt8Array(4 * widthArray * heightArray);
	}
	
	public function loadFromImage(img:Image) {
		// PIXEL DATEN AUSLESEN
		
		var d = img.getPixels(new Rectangle(0, 0, img.width, img.height));
		
		for (i in 0 ... d.length) {
			data[i] = d.get(i);
		}
	}
	
	public function update() {
		if (data == null) return;
		
		gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, _width, _height, 0, gl.RGBA, gl.UNSIGNED_BYTE, data);
	}
	
	public function setPixel(x:Int, y:Int, c:Color) {
		var offset:Int = ((y * _width) + x) * 4;
		
		data[offset] = c.intR;
		data[offset + 1] = c.intG;
		data[offset + 2] = c.intB;
		data[offset + 3] = 255;
	}
}