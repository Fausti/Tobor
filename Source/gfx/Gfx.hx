package gfx;

import lime.Assets;
import lime.graphics.Image;
import lime.graphics.opengl.GL;
import lime.math.Matrix4;
import lime.math.Rectangle;

import gfx.Color;

/**
 * ...
 * @author Matthias Faust
 */
class Gfx {
	private static var _shader:Shader;
	
	public static var _texture:Texture;
	private static var _textureDefault:Texture;
	
	private static var _matrix:Matrix4;
	private static var _batch:Batch;
	private static var _color:Color = Color.WHITE;
	
	private static var _width:Int;
	private static var _height:Int;
	private static var _offsetX:Int = 0;
	private static var _offsetY:Int = 0;
	
	public static inline function setup(w:Int, h:Int) {
		_width = w;
		_height = h;
		
		_matrix = Matrix4.createOrtho(0, w, h, 0, -1000, 1000);
	}
	
	public static inline function begin(batch:Batch) {
		_batch = batch;
		_batch.clear();
	}
	
	public static inline function end() {
		_batch.bind();
		_batch.draw();
	}
	
	public static inline function setColor(color:Color) {
		_color = color;
	}
	
	public static function resetTexture() {
		if (_textureDefault != null) _texture = _textureDefault;
	}
	
	public static function loadTexture(fileName:String) {
		var texture:Texture = new Texture();
		texture.createFromImage(Assets.getImage(fileName));
		
		if (texture != null) {
			_texture = texture;
			_textureDefault = texture;
		}
		
		return texture;
	}
	
	public static function loadTextureFrom(image:Image) {
		var texture:Texture = new Texture();
		
		if (image != null) {
			texture.createFromImage(image);
		
			if (texture != null) {
				_texture = texture;
			}
		} else {
			trace("image is null!");
		}
		
		return texture;
	}
	
	public static inline function setTexture(texture:Texture) {
		if (_shader == null) {
			trace("setTexture() -> No shader in use!");
			return;
		}
		
		_texture = texture;
		
		texture.bind();
		GL.uniform1i(_shader.u_Texture0, 0);
	}
	
	public static inline function setShader(shader:Shader) {
		_shader = shader;
		shader.use();
	}
	
	public static inline function setOffset(x:Int, y:Int) {
		_offsetX = x;
		_offsetY = y;
	}
	
	public static inline function setViewport(x:Int, y:Int, w:Int, h:Int) {
		if (_matrix == null) {
			trace("setViewport() -> No matrix!");
			return;
		}
		
		if (_shader == null) {
			trace("setViewport() -> No shader in use!");
			return;
		}
		
		GL.uniformMatrix4fv(_shader.u_camMatrix, 1, false, _matrix);
		GL.viewport(x, y, w, h);
	}
	
	public static function clear(color:Color) {
		GL.clearColor(color.r, color.g, color.b, 1.0);
		GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
	}
	
	public static inline function drawTexture(x:Float, y:Float, w:Float, h:Float, rect:Rectangle, ?color:Color = null) {
		if (_batch == null) {
			trace("GFX ERROR: No batch bound!");
			return;
		}
		
		if (color == null) color = _color;
		
		_batch.pushVertex(
			_offsetX + x, 
			_offsetY + y, 			
			rect.left, rect.top, 	
			color.r, color.g, color.b, color.a
		);
		
		_batch.pushVertex(
			_offsetX + x, 
			_offsetY + y + h, 		
			rect.left, rect.bottom, 	
			color.r, color.g, color.b, color.a
		);
		
		_batch.pushVertex(
			_offsetX + x + w, 
			_offsetY + y + h, 	
			rect.right, rect.bottom, 	
			color.r, color.g, color.b, color.a
		);
		
		_batch.pushVertex(
			_offsetX + x + w, 
			_offsetY + y, 		
			rect.right, rect.top, 	
			color.r, color.g, color.b, color.a
		);
		
		_batch.addIndices([0, 1, 2, 2, 3, 0]);
	}
	
	public static inline function drawSprite(x:Float, y:Float, spr:Sprite, ?color:Color = null) {
		if (color == null) {
			if (spr.color != null) color = spr.color;
		}
		
		drawTexture(Std.int(x), Std.int(y), spr.width, spr.height, spr.uv, color);
	}
	
	public static inline function getSprite(x:Int, y:Int, ?w:Int = -1, ?h:Int = -1):Sprite {
		if (_texture == null) {
			trace("getSprite(): No texture loaded!");
			return null;
		}
		
		if (w == -1 || h == -1) {
			return new Sprite(_texture, x, y, Tobor.TILE_WIDTH, Tobor.TILE_HEIGHT);
		} else {
			return new Sprite(_texture, x, y, w, h);
		}
	}
}