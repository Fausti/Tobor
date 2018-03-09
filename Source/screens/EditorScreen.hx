package screens;

/**
 * ...
 * @author Matthias Faust
 */
class EditorScreen extends PlayScreen {
	var SPR_CURSOR:Sprite;
	
	public function new(game:Tobor) {
		super(game);
		
		SPR_CURSOR = Gfx.getSprite(208, 240);
	}
	
	override public function renderUI() {
		Gfx.setOffset(0, 0);
		
		renderStatusLine();
		
		if (dialog != null) {
			dialog.render();
		}
		
		var cursorX:Int = Math.floor(Input.mouseX / Tobor.TILE_WIDTH);
		var cursorY:Int = Math.floor(Input.mouseY / Tobor.TILE_HEIGHT);
		
		if (cursorY > 0) {
			Gfx.drawSprite(cursorX * Tobor.TILE_WIDTH, cursorY * Tobor.TILE_HEIGHT, SPR_CURSOR);
		}
	}
}