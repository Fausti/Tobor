package ui;
import world.entities.Entity;

/**
 * ...
 * @author Matthias Faust
 */
class DialogHelp extends Dialog {
	var SPR_NONE:Sprite;
	var SPR_CURSOR:Sprite;
	
	var oldMouseX:Int;
	var oldMouseY:Int;
	var cursorX:Int;
	var cursorY:Int;
	
	public var lookTarget:String = null;

	public function new(screen:Screen, x:Int, y:Int) {
		super(screen, x, y);
		
		SPR_NONE = Gfx.getSprite(0, 0);
		SPR_CURSOR = Gfx.getSprite(192, 12);
	}
	
	override public function update(deltaTime:Float):Void {
		if (oldMouseX != Input.mouseX || oldMouseY != Input.mouseY) {
			oldMouseX = Input.mouseX;
			oldMouseY = Input.mouseY;
			
			cursorX = Math.floor(oldMouseX / Tobor.TILE_WIDTH);
			cursorY = Math.floor(oldMouseY / Tobor.TILE_HEIGHT);
		}
		
		if (Input.isKeyDown(Tobor.KEY_ENTER) || Input.mouseBtnLeft) {
			var targets = screen.game.world.room.getEntitiesAt(cursorX, cursorY - 1);
			if (targets.length > 0) {
				var target:Entity = targets[0];
				lookTarget = target.getID();
			}
			
			ok();
		} else if (Input.isKeyDown(Tobor.KEY_ESC) || Input.mouseBtnRight) {
			exit();
		} else if (Input.isKeyDown(Tobor.KEY_LEFT)) {
			cursorX = cursorX - 1;
			Input.wait(0.25);
		} else if (Input.isKeyDown(Tobor.KEY_RIGHT)) {
			cursorX = cursorX + 1;
			Input.wait(0.25);
		} else if (Input.isKeyDown(Tobor.KEY_UP)) {
			cursorY = cursorY - 1;
			Input.wait(0.25);
		} else if (Input.isKeyDown(Tobor.KEY_DOWN)) {
			cursorY = cursorY + 1;
			Input.wait(0.25);
		}
	}
	
	override public function render():Void {
		super.render();
		
		Gfx.drawTexture(x, y, 40 * Tobor.TILE_WIDTH, Tobor.TILE_HEIGHT, SPR_NONE.uv, Color.GREEN);
		
		if (cursorY > 0) {
			Gfx.drawSprite(cursorX * Tobor.TILE_WIDTH, cursorY * Tobor.TILE_HEIGHT, SPR_CURSOR, Color.WHITE);
		}
	}
}