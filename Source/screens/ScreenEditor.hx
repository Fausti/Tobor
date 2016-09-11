package screens;

import lime.math.Rectangle;
import screens.dialog.Dialog;
import screens.dialog.DialogTileChooser;
import tjson.TJSON;
import world.Room;
import gfx.Gfx;
import gfx.Color;
import world.WorldData;
import world.EntityFactory;
import world.entities.Entity;
import world.entities.EntityPushable;
import world.entities.core.Mauer;

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
	
	var dialogCurrent:Dialog;
	var dialogTileset:Dialog;
	
	var saveGame:String;
	
	public function new(game:Tobor) {
		super(game);
		
		SPR_ISOLATOR = Tobor.Tileset.find("SPR_ISOLATOR");
		SPR_ELEKTROZAUN = Tobor.Tileset.find("SPR_ELEKTROZAUN");
		
		dialogCurrent = null;
		dialogTileset = new DialogTileChooser(this);
		
		game.world.room.redraw = true;
	}
	
	override
	public function update(deltaTime:Float) {
		// Spielfeldkoordinaten
		
		if (Input.mouseInside) {
			cursorX = Math.floor((Input.mouseX * Gfx.scaleX) / Entity.WIDTH);
			cursorY = Math.floor((Input.mouseY * Gfx.scaleY) / Entity.HEIGHT);
		}
		
		if (Input.keyDown(Input.F5)) {
			Input.wait(2);
			
			/*
			var fin = File.read("room_000.map", false);
			saveGame = fin.readAll().toString();
			fin.close();
			
			game.world.room.load(TJSON.parse(saveGame));
			*/
			
			game.world.load("tobor.ep");
		}
		
		if (Input.keyDown(Input.F2)) {
			Input.wait(2);
			
			/*
			saveGame = TJSON.encode(game.world.room.save());
			
			var fout = File.write("room_000.map", false);
			fout.writeString(saveGame);
			fout.close();
			*/
			
			game.world.save("tobor.ep");
		}
		
		if (dialogCurrent == null) {
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
				if (dialogCurrent != dialogTileset) {
					dialogCurrent = dialogTileset;
					Input.wait(2);
				}
			}
			
			if (Input.keyDown(Input.ESC)) {
				Input.wait(2);
				
				game.switchScreen(new ScreenMainMenu(game));
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
		
			if (dialogCurrent != null) dialogCurrent.update(deltaTime);
		
			if (Input.keyDown(Input.ESC) || Input.keyDown(Input.TAB)) {
				if (dialogCurrent != null) {
					dialogCurrent = null;
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
		if (dialogCurrent != null) {
			// Wenn Dialog offen:
			
			dialogCurrent.render();
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
		var strStatus:String = "Entities: " + StringTools.lpad(Std.string(countEntities), "0", 4);
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
}