package dialog;
import lime.math.Rectangle;
import world.EntityFactory;

import screens.ScreenEditor;
import gfx.Gfx;
import gfx.Color;
import world.EntityFactory;
import world.WorldData;
import world.entities.Object;

/**
 * ...
 * @author Matthias Faust
 */
class DialogTileChooser extends Dialog {
	var UI_SELECTOR:Rectangle;
	var UI_NONE:Rectangle;
	
	var cursorX:Int = 0;
	var cursorY:Int = 0;
	
	public static inline var MAX_ITEMS:Int = 32;
	
	var editor:ScreenEditor;
	
	public function new(screen:ScreenEditor) {
		super(screen, 0, 0);
		
		editor = screen;
		
		UI_NONE = Tobor.Tileset.find("SPR_NONE");
		UI_SELECTOR = Tobor.Tileset.find("UI_SELECTOR");
	}
	
	override
	public function update(deltaTime:Float) {
		if (Input.mouseInside) {
			cursorX = Math.floor((Input.mouseX * Gfx.scaleX) / Tobor.OBJECT_WIDTH);
			cursorY = Math.floor((Input.mouseY * Gfx.scaleY) / Tobor.OBJECT_HEIGHT);
		}
		
		var tile:Int = editor.currentTile;
		
		if (Input.keyDown(Input.RIGHT)) {
			tile++;
			Input.wait(0.2);
		} else if (Input.keyDown(Input.LEFT)) {
			tile--;
			Input.wait(0.2);
		} else if (Input.keyDown(Input.UP)) {
			tile -= MAX_ITEMS;
			Input.wait(0.2);
		} else if (Input.keyDown(Input.DOWN)) {
			tile += MAX_ITEMS;
			Input.wait(0.2);
		}
		
		if (tile < 0) {
			tile = 0;
		} else if (tile >= EntityFactory.table.length) {
			tile = EntityFactory.table.length - 1;
		}
		
		editor.currentTile = tile;
		
		if (Input.keyDown(Input.ESC) || Input.keyDown(Input.TAB) || Input.keyDown(Input.ENTER)) {
			exit();
			Input.wait(2);
		}
	}
	
	override
	public function render() {
		var tiles:Int = EntityFactory.table.length; // 256
		
		var boxH:Int;
		var boxW:Int;
		
		if (tiles <= MAX_ITEMS) {
			boxW = MAX_ITEMS;
			boxH = 1;
		} else {
			boxW = MAX_ITEMS;
			boxH = Math.ceil(tiles / boxW);
		}
		
		Dialog.drawBackground(x, y, 40 * 16, boxH * 12);
		
		// Tobor.Frame8.drawBox(x + Tobor.Frame8.sizeX * 7, y - Tobor.Frame8.sizeY, boxW * 2 + 2, 2 + Math.ceil((boxH * 12) / Tobor.Frame8.sizeY));
		
		var tX:Int = 0;
		var tY:Int = 0;
		
		for (i in 0 ... tiles) {
			var t = EntityFactory.table[i];
			
			Gfx.drawRect(16 * 4 + tX * Tobor.OBJECT_WIDTH, tY * Tobor.OBJECT_HEIGHT, UI_NONE);
			
			if (editor.currentTile == i) {
				Gfx.drawRect(16 * 4 + tX * Tobor.OBJECT_WIDTH, tY * Tobor.OBJECT_HEIGHT, Tobor.Tileset.find(t.editorSprite));
				Gfx.drawRect(16 * 4 + tX * Tobor.OBJECT_WIDTH, tY * Tobor.OBJECT_HEIGHT, UI_SELECTOR);
			} else {
				Gfx.drawRect(16 * 4 + tX * Tobor.OBJECT_WIDTH, tY * Tobor.OBJECT_HEIGHT, Tobor.Tileset.find(t.editorSprite), Color.DARK_GREEN);
			}
			
			tX++;
			if (tX >= boxW) {
				tX = 0;
				tY++;
			}
		}
	}
}