package dialog;

import gfx.Gfx;
import gfx.Color;
import screens.Screen;
import world.WorldData;
import world.entities.Object;
/**
 * ...
 * @author Matthias Faust
 */
class Dialog {
	var x:Int = 0;
	var y:Int = 0;
	var w:Int = 0;
	var h:Int = 0;
	
	var screen:Screen;
	var child:Dialog;
	
	public var onOK:Dynamic = null;
	public var onEXIT:Dynamic = null;
	
	public function new(screen:Screen, x:Int, y:Int) {
		this.screen = screen;
		
		this.x = x;
		this.y = y;
	}
	
	public function update(deltaTime:Float) {
		
	}
	
	public function render() {
		
	}
	
	public function show() {
		
	}
	
	public function hide() {
		
	}
	
	public function exit() {
		if (onEXIT != null) onEXIT();
	}
	
	public function ok() {
		if (onOK != null) onOK();
	}
	
	public function onTextInput(text:String) {
		trace(text);
	}
	
	// Static
	
	public static function drawBackground(x:Int, y:Int, w:Int, h:Int, ?c:Color = null) {
		if (c == null) c = Color.GREEN;
		
		Gfx.drawTexture(x, y, w, h, Tobor.Tileset.rect(0, 0, 16, 12), c);
	}
}