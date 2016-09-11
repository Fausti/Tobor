package screens.dialog;

import gfx.Gfx;
import gfx.Color;
import world.WorldData;
import world.entities.Entity;
/**
 * ...
 * @author Matthias Faust
 */
class Dialog {
	var x:Int = 0;
	var y:Int = 0;
	var w:Int = 0;
	var h:Int = 0;
	
	public function new(x:Int, y:Int) {
		this.x = x;
		this.y = y;
	}
	
	public function update(deltaTime:Float) {
		
	}
	
	public function render() {
		
	}
	
	// Static
	
	public static function drawBackground(x:Int, y:Int, w:Int, h:Int, ?c:Color = null) {
		if (c == null) c = Color.GREEN;
		
		Gfx.drawTexture(x, y, w, h, Tobor.Tileset.rect(0, 0, 16, 12), c);
	}
}