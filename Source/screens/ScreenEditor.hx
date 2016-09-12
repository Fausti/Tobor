package screens;

import lime.math.Rectangle;
import dialog.Dialog;
import dialog.DialogTileChooser;
import tjson.TJSON;
import world.Room;
import gfx.Gfx;
import gfx.Color;
import world.WorldData;
import world.EntityFactory;
import world.entities.Entity;
import world.entities.EntityPushable;
import world.entities.core.Wall;
import dialog.DialogMenu;

import sys.io.File;

/**
 * ...
 * @author Matthias Faust
 */
class ScreenEditor extends Screen {
	var cursorX:Int = 0;
	var cursorY:Int = 0;
	
	public var currentTile:Int = 0;
	
	var SPR_ISOLATOR:Rectangle;
	var SPR_ELEKTROZAUN:Rectangle;
	
	var dialogTileset:Dialog;
	
	var saveGame:String;
	
	public function new(game:Tobor) {
		super(game);
		
		SPR_ISOLATOR = Tobor.Tileset.find("SPR_ISOLATOR");
		SPR_ELEKTROZAUN = Tobor.Tileset.find("SPR_ELEKTROZAUN");
		
		dialogTileset = new DialogTileChooser(this);
	}
	
	override
	public function update(deltaTime:Float) {
		// Spielfeldkoordinaten
		
		if (Input.mouseInside) {
			cursorX = Math.floor((Input.mouseX * Gfx.scaleX) / Entity.WIDTH);
			cursorY = Math.floor((Input.mouseY * Gfx.scaleY) / Entity.HEIGHT);
		}
		
		if (dialog == null) {
			if (Input.keyDown(Input.ESC)) {
				Input.wait(2);
				showMainMenu();
			}
			
			// Spielerbewegung
		
			var mx:Int = 0;
			var my:Int = 0;
		
			if (Input.keyDown(Input.RIGHT)) mx = 1;		
			if (Input.keyDown(Input.LEFT)) mx = -1;
			if (Input.keyDown(Input.UP)) my = -1;
			if (Input.keyDown(Input.DOWN)) my = 1;
		
			game.world.player.move(mx, my);
		
			// Raumupdate
		
			game.world.room.update(deltaTime);
			
			if (Input.keyDown(Input.TAB)) {
				if (dialog != dialogTileset) {
					dialog = dialogTileset;
					Input.wait(2);
				}
			}
			
			if (cursorY > 0) {
				if (Input.mouseBtnLeft) {
					if (EntityFactory.table[currentTile].name == "OBJ_CHARLIE") {
						game.world.player.gridX = cursorX;
						game.world.player.gridY = cursorY - 1;
					} else {
						var entity:Entity = EntityFactory.create(currentTile);
						
						if (entity != null) {
							var e = game.world.room.getEntitiesAt(cursorX, cursorY - 1);
							if (e.length == 0) {
								entity.gridX = cursorX;
								entity.gridY = cursorY - 1;
					
								game.world.room.add(entity);
							} else {
								// trace("Position not free!");
							}
						}
					}
				} else if (Input.mouseBtnRight) {
					var e = game.world.room.getEntitiesAt(cursorX, cursorY - 1);
				
					if (e.length != 0) {
						for (o in e) {
							if (o != game.world.player) {
								game.world.room.remove(o);
							}
						}
					}
				}
			}
			
		} else {
			// -- Editorstuff
		
			if (dialog != null) dialog.update(deltaTime);
		
			if (Input.keyDown(Input.ESC) || Input.keyDown(Input.TAB)) {
				if (dialog != null) {
					dialog = null;
					Input.wait(2);
				}
			}
		}
	}
	
	override
	public function render() {
		Gfx.clear(backgroundColor);
		
		// offsetY um ein "Feld" nach unten verschieben
		
		Gfx.setOffset(0, 12);
		
		// statische Sprites zeichnen
		
		renderStatic();
		
		// bewegliche Sprites zeichnen
		
		renderSprites();
	}
	
	override
	public function renderUI() {
		if (dialog != null) {
			// Wenn Dialog offen:
			
			if (Std.is(dialog, DialogMenu)) {
				renderStatusLine();
			}
			
			dialog.render();
		} else {
			// ansonsten:
			renderStatusLine();
			
			// Cursor
			if (Input.mouseInside && cursorY > 0) {
				Gfx.drawTexture(
					cursorX * Entity.WIDTH, 
					cursorY * Entity.HEIGHT, 
					Entity.WIDTH, Entity.HEIGHT, 
					Tobor.Tileset.tile(13, 20)
				);
			}
		}
	}
	
	function renderStatusLine() {
		for (x in 0 ... 8) {
			Gfx.drawRect(x * Entity.WIDTH, 0, SPR_ELEKTROZAUN);
			Gfx.drawRect((39 - x) * Entity.WIDTH, 0, SPR_ELEKTROZAUN);
		}
		
		// aktives Objekt
		Tobor.Font16.drawString(9 * Entity.WIDTH + 8, 0, "[", Color.BLACK);
		Tobor.Font16.drawString(11 * Entity.WIDTH - 4, 0, "]", Color.BLACK);
		Gfx.drawRect(10 * Entity.WIDTH, 0, Tobor.Tileset.find(EntityFactory.table[currentTile].editorSprite));
		
		
		var countEntities:Int = game.world.room.entities.length;
		var strStatus:String = "Objekte: " + StringTools.lpad(Std.string(countEntities), "0", 4);
		Tobor.Font8.drawString(224, 0, strStatus, Color.BLACK);
	}
	
	function renderStatic() {
		Gfx.setBatch(batchStatic);
		
		if (game.world.room.redraw) {
			batchStatic.clear();
			
			game.world.room.draw(Room.LAYER_BACKGROUND);
		}
		
		batchStatic.bind();
		batchStatic.draw();
	}
	
	function renderSprites() {
		Gfx.setBatch(batchSprites);
		
		batchSprites.clear();
		
		game.world.room.draw(Room.LAYER_SPRITE);
				
		batchSprites.bind();
		batchSprites.draw();
	}
	
	function showMainMenu() {
		var menu = new DialogMenu(this, 320, 166, [
			["Laden", ""],		// 0
			["Speichern", ""], 	// 1
			["Ende", "F9"],		// 2
		]);
		
		dialog = menu;
		
		dialog.onEXIT = function () {
			dialog = null;
		};
			
		dialog.onOK = function () {
			switch(menu.getSelected()) {
				case 0:
					game.world.load("tobor.ep");
				case 1:
					game.world.save("tobor.ep");
				case 2:
					game.switchScreen(new ScreenMainMenu(game));
				default:
			}

			dialog = null;
		};
	}
}