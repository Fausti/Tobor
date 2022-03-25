package ui;

/**
 * ...
 * @author Matthias Faust
 */
class DialogFiles extends DialogMessage {
	var index:Int = 0;
	var files:Array<String>;
	
	var SPR_SCROLLBAR_UP:Sprite;
	var SPR_SCROLLBAR_DOWN:Sprite;
	var SPR_SCROLLBAR_0:Sprite;
	var SPR_SCROLLBAR_1:Sprite;
	
	public function new(screen:Screen, x:Int, y:Int, msg:String, files:Array<String>) {
		SPR_SCROLLBAR_UP = Gfx.getSprite(112, 24);
		SPR_SCROLLBAR_DOWN = Gfx.getSprite(144, 24);
		SPR_SCROLLBAR_0 = Gfx.getSprite(240, 0);
		SPR_SCROLLBAR_1 = Gfx.getSprite(64, 12);
		
		maxWidth = 18;
		
		super(screen, x, y, msg, true);
		
		this.files = files;
		
		this.h = this.h + Std.int(Math.min(10, files.length)) + 1;
		
		this.y = Tobor.TILE_HEIGHT * Std.int(14 - (this.h / 2));
	}
	
	override public function render() {
		super.render();
		
		var maxFiles:Int = 10;
		var countFiles:Int = Std.int(Math.min(maxFiles, files.length));
		
		var begin:Int = 0;
		if (index >= maxFiles) {
			begin = index - maxFiles + 1;
		}
		
		for (i in 0 ... countFiles) {
			var bg:Color = Color.WHITE;
			var fg:Color = Color.BLACK;
			
			if ((begin + i) == index) {
				bg = Color.BLUE2;
				fg = Color.YELLOW;
			}
			
			Tobor.fontSmall.drawString(x + 16 + offsetX, y + 12 * ( lines.length + 2 ) + i * 12, files[begin + i].rpad(" ", (w - 2) * 2 - 3), fg, bg);
		}
		
		if (files.length > countFiles) {
			var ps:Float = files.length / 10;
			var end:Int = Std.int(Math.min(files.length, begin + countFiles));
		
			for (i in 0 ... countFiles) {
				if (i == 0) {
					Gfx.drawSprite(x + (w - 2) * Tobor.TILE_WIDTH, y + (3 + i) * Tobor.TILE_HEIGHT, SPR_SCROLLBAR_UP);
				} else if (i == maxFiles - 1) {
					Gfx.drawSprite(x + (w - 2) * Tobor.TILE_WIDTH, y + (3 + i) * Tobor.TILE_HEIGHT, SPR_SCROLLBAR_DOWN);
				} else {
					var pos:Int = Std.int(i * ps);
					if (pos >= begin && pos <= end) {
						Gfx.drawSprite(x + (w - 2) * Tobor.TILE_WIDTH, y + (3 + i) * Tobor.TILE_HEIGHT, SPR_SCROLLBAR_0);
					} else {
						// Gfx.drawSprite(4 + 36 * Tobor.TILE_WIDTH, (10 + i) * Tobor.TILE_HEIGHT, SPR_SCROLLBAR_0);
					}
				}
			}
		}
	}
	
	override public function update(deltaTime:Float) {
		if (Input.isKeyDown(Tobor.KEY_ENTER)) {
			ok();
		} else if (Input.isKeyDown(Tobor.KEY_ESC)) {
			exit();
		} else if (Input.isKeyDown([KeyCode.UP])) {
			index--;
			
			if (index < 0) index = 0;
			Input.wait(0.25);
		} else if (Input.isKeyDown([KeyCode.DOWN])) {
			index++;
			
			if (index >= files.length) index = files.length - 1;
			Input.wait(0.25);
		}
	}
	
	public function getInput():String {
		return files[index];
	}
}