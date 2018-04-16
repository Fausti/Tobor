package ui;
import world.Room;

/**
 * ...
 * @author Matthias Faust
 */
class DialogFade extends Dialog {
	var SPR_BLACK:Sprite;
	
	var fadeX:Int = 0;
	var fadeY:Int = 0;
	
	var type:Int = 0;
	
	var cb:Dynamic = null;
	
	public function new(screen:Screen, ?type:Int = 0, ?cb:Dynamic = null) {
		super(screen, x, y);
		
		SPR_BLACK = Gfx.getSprite(48, 156);
		
		this.type = type;
		this.cb = cb;
		
		switch(type) {
			case 0:
				fadeX = -4;
				fadeY = 0;
			case 1:
				fadeX = Room.WIDTH + 4;
				fadeY = 0;
		}
	}
	
	
	override public function update(deltaTime:Float) {
		switch(type) {
			case 0:
				fadeX = fadeX + 8;
		
				if (fadeX > Room.WIDTH) {
					if (cb != null) cb();
					screen.hideDialog();
				}
			case 1:
				fadeX = fadeX - 8;
		
				if (fadeX < 0) {
					if (cb != null) cb();
					screen.hideDialog();
				}
		}
	}
	
	override public function render() {
		switch(type) {
			case 0:
				for (_x in 0 ... fadeX) {
					for (_y in 0 ... Room.HEIGHT) {
						Gfx.drawSprite(_x * Tobor.TILE_WIDTH, Tobor.TILE_HEIGHT + _y * Tobor.TILE_HEIGHT, SPR_BLACK);
					}
				}
			case 1:
				for (_x in Utils.range(0, fadeX, 1)) {
					for (_y in Utils.range(Room.HEIGHT, -1, -1)) {
						Gfx.drawSprite(_x * Tobor.TILE_WIDTH, Tobor.TILE_HEIGHT + _y * Tobor.TILE_HEIGHT, SPR_BLACK);
					}
				}
		}
	}
}