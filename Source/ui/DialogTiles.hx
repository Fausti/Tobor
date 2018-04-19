package ui;
import screens.EditorScreen;
import world.ObjectFactory;

/**
 * ...
 * @author Matthias Faust
 */
class DialogTiles extends Dialog {
	public static inline var MAX_ITEMS:Int = 32;
	
	var SPR_SELECTOR:Sprite;
	var SPR_NONE:Sprite;
	
	var cursorX:Int = 0;
	var cursorY:Int = 0;
	
	var factory:ObjectFactory;
	var editor:EditorScreen;
	
	public function new(screen:Screen, x:Int, y:Int) {
		super(screen, x, y);
		
		SPR_SELECTOR = Gfx.getSprite(160, 240);
		SPR_NONE = Gfx.getSprite(0, 0);
		
		this.editor = cast screen;
		this.factory = screen.game.world.factory;
	}

	override public function update(deltaTime:Float) {
		super.update(deltaTime);
		
		var tile:Int = editor.currentTile;
		
		{
			var oldX = cursorX;
			var oldY = cursorY;
			
			cursorX = editor.cursorX;
			cursorY = editor.cursorY;
			
			var tiles:Int = factory.length; // 256
		
			var boxH:Int;
			var boxW:Int;
		
			if (tiles <= MAX_ITEMS) {
				boxW = MAX_ITEMS;
				boxH = 1;
			} else {
				boxW = MAX_ITEMS;
				boxH = Math.ceil(tiles / boxW);
			}
			
			if (oldX != cursorX || oldY != cursorY) {
				// trace(cursorX, cursorY);
				
				if (cursorY < boxH && cursorX >= 4 && cursorX < 36) {
					// trace(cursorX, cursorY);
					tile = cursorY * MAX_ITEMS + (cursorX - 4);
				}
			}
			
			if (Input.mouseBtnLeft) {
				if (cursorY < boxH && cursorX >= 4 && cursorX < 36) {
					Input.clearKeys();
					editor.currentTile = tile;
					if (onOk != null) onOk();
					screen.hideDialog();
				}
			}
		}
		
		if (Input.isKeyDown([Input.key.ESCAPE])) {
			screen.hideDialog();
		} else if (Input.isKeyDown([Input.key.RETURN])) {
			screen.hideDialog();
		} else if (Input.isKeyDown(Tobor.KEY_LEFT)) {
			tile--;
			Input.wait(0.2);
		} else if (Input.isKeyDown(Tobor.KEY_RIGHT)) {
			tile++;
			Input.wait(0.2);
		} else if (Input.isKeyDown(Tobor.KEY_UP)) {
			tile -= MAX_ITEMS;
			Input.wait(0.2);
		} else if (Input.isKeyDown(Tobor.KEY_DOWN)) {
			tile += MAX_ITEMS;
			Input.wait(0.2);
		}
		
		if (tile < 0) {
			tile = 0;
		} else if (tile >= factory.length) {
			tile = factory.length - 1;
		}
		
		editor.currentTile = tile;
	}
	
	override public function render() {
		var tiles:Int = factory.length; // 256
		
		var boxH:Int;
		var boxW:Int;
		
		if (tiles <= MAX_ITEMS) {
			boxW = MAX_ITEMS;
			boxH = 1;
		} else {
			boxW = MAX_ITEMS;
			boxH = Math.ceil(tiles / boxW);
		}
		
		Gfx.drawTexture(x, y, 40 * Tobor.TILE_WIDTH, boxH * Tobor.TILE_HEIGHT, SPR_NONE.uv, Color.GREEN);
		// Dialog.drawBackground(x, y, 40 * 16, boxH * 12);
		
		var tX:Int = 0;
		var tY:Int = 0;
		
		for (i in 0 ... tiles) {
			var t = factory.get(i);
			
			Gfx.drawSprite((4 + tX) * Tobor.TILE_WIDTH, tY * Tobor.TILE_HEIGHT, SPR_NONE);
			
			if (editor.currentTile == i) {
				if (t.canBePlaced) {
					Gfx.drawSprite((4 + tX) * Tobor.TILE_WIDTH, tY * Tobor.TILE_HEIGHT, t.spr);
					Gfx.drawSprite((4 + tX) * Tobor.TILE_WIDTH, tY * Tobor.TILE_HEIGHT, SPR_SELECTOR);
				} else {
					Gfx.drawSprite((4 + tX) * Tobor.TILE_WIDTH, tY * Tobor.TILE_HEIGHT, SPR_NONE, Color.RED);
					Gfx.drawSprite((4 + tX) * Tobor.TILE_WIDTH, tY * Tobor.TILE_HEIGHT, t.spr, Color.RED);
				}
			} else {
				if (t.canBePlaced) {
					Gfx.drawSprite((4 + tX) * Tobor.TILE_WIDTH, tY * Tobor.TILE_HEIGHT, t.spr, Color.DARK_GREEN);
				} else {
					Gfx.drawSprite((4 + tX) * Tobor.TILE_WIDTH, tY * Tobor.TILE_HEIGHT, SPR_NONE, Color.RED);
					Gfx.drawSprite((4 + tX) * Tobor.TILE_WIDTH, tY * Tobor.TILE_HEIGHT, t.spr, Color.DARK_RED);
				}
			}
			
			tX++;
			if (tX >= boxW) {
				tX = 0;
				tY++;
			}
		}
		
		var c:ObjectTemplate = factory.get(editor.currentTile);
		
		Gfx.drawTexture(16, 28 * 12, 40 * Tobor.TILE_WIDTH, Tobor.TILE_HEIGHT, SPR_NONE.uv, Color.GREEN);
		
		Tobor.fontSmall.drawString(0, 28 * 12 + 1, "    " + c.editorName, Color.BLACK);
		Gfx.drawSprite(0, 28 * 12, c.spr);
	}
}