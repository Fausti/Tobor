package gfx;

import lime.math.Rectangle;

/**
 * ...
 * @author Matthias Faust
 */
interface IDrawable {
	public function update(deltaTime:Float):Void;

	public function getUV():Rectangle;
}