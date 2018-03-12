package screens;

import ui.DialogTiles;
import world.Room;
import world.entities.Entity;

/**
 * ...
 * @author Matthias Faust
 */
class EditorScreen extends PlayScreen {
	var editMode:Bool = true;
	
	public var cursorX:Int;
	public var cursorY:Int;
	var oldCursorX:Int;
	var oldCursorY:Int;
	
	public var currentTile:Int = 0;
	
	var SPR_CURSOR:Sprite;
	var SPR_MODE_PLAY:Sprite;
	var SPR_MODE_EDIT:Sprite;
	
	var dialogTiles:DialogTiles;
	
	public function new(game:Tobor) {
		super(game);
		
		SPR_CURSOR = Gfx.getSprite(208, 240);
		SPR_MODE_PLAY = Gfx.getSprite(176, 240);
		SPR_MODE_EDIT = Gfx.getSprite(192, 240);
		
		dialogTiles = new DialogTiles(this, 0, 0);
	}
	
	override public function update(deltaTime:Float) {
		cursorX = Math.floor(Input.mouseX / Tobor.TILE_WIDTH);
		cursorY = Math.floor(Input.mouseY / Tobor.TILE_HEIGHT);
				
		if (dialog != null) {
			dialog.update(deltaTime);
			return;
		} else {
			if (Input.isKeyDown([Input.key.ESCAPE])) {
				showMainMenu();
				
				return;
			} else if (Input.isKeyDown([Input.key.RETURN])) {
				if (editMode) {
					showDialog(dialogTiles);
					
					return;
				} else {
					// showDialog(dialogInventory);
					
					return;
				}
				
				return;
			}
		
			if (!editMode) checkPlayerMovement();
			
			if (cursorX == 1 && cursorY == 0 && Input.mouseBtnLeft) {
				switchEditMode();
				return;
			}
			
			if (Input.isKeyDown([Input.key.F5])) {
				switchEditMode();
				return;
			}
			
			if (Input.mouseBtnLeft) {
				if (editMode) {
					if (cursorX >= 0 && cursorX < Room.WIDTH && cursorY >= 1 && cursorY < Room.HEIGHT) {
						// im Raum zeichnen
						var template = game.world.factory.get(currentTile);
						
						var e:Entity = template.create();
						e.setPosition(cursorX, cursorY - 1);
						
						game.world.room.addEntity_editor(e);
						
						return;
					} else if (cursorX == 10 && cursorY == 0) {
						// den Objektwahl Dialog öffnen
						showDialog(dialogTiles);
						
						return;
					}
				}
			} else if (Input.mouseBtnRight) {
				if (editMode) {
					if (cursorX >= 0 && cursorX < Room.WIDTH && cursorY >= 1 && cursorY < Room.HEIGHT) {
						// Objekte an Position entfernen
						
						var list = game.world.room.getEntitiesAt_editor(cursorX, cursorY - 1);
						
						for (e in list) {
							game.world.room.removeEntity_editor(e);
						}
						
						return;
					}
				}
			}
		}
		
		if (!editMode) game.world.update(deltaTime);
	}
	
	function switchEditMode() {
		editMode = !editMode;
		
		Input.clearKeys();
		
		if (!editMode) {
			game.world.room.loadState();
		}
	}
	
	override public function render() {
		Gfx.setOffset(0, Tobor.TILE_HEIGHT);
		if (editMode) {
			game.world.render_editor();
		} else {
			game.world.render();
		}
	}
	
	override function renderStatusLine() {
		for (x in 0 ... 8) {
			if (x == 1) {
				Gfx.drawSprite(x * Tobor.TILE_WIDTH, 0, SPR_MODE_PLAY);
			} else {
				Gfx.drawSprite(x * Tobor.TILE_WIDTH, 0, SPR_ISOLATOR);
			}
			
			Gfx.drawSprite((39 - x) * Tobor.TILE_WIDTH, 0, SPR_ISOLATOR);
		}
		
		// TODO: Blaumann! Oder Charlieobjekt fragen?
		Gfx.drawSprite(8 * Tobor.TILE_WIDTH + Tobor.TILE_WIDTH / 2, 0, SPR_CHARLIE);
		
		var punkte = 0; // game.world.player.points;
		var leben = 0; // game.world.player.lives;
		
		var strStatus:String = "Punkte " + StringTools.lpad(Std.string(punkte), "0", 8) + " Leben " + Std.string(leben);
		Tobor.fontSmall.drawString(224, 0, strStatus, Color.BLACK);
		
		var gold = 0; // game.world.player.gold;
		if (gold > 0) {
			Gfx.drawSprite(416, 0, SPR_GOLD);
			Tobor.fontSmall.drawString(416 + 24, 0, StringTools.lpad(Std.string(gold), " ", 3), Color.BLACK);
		}
		
		var weight = 0; // game.world.player.inventory.length;
		var strWeight:String = StringTools.lpad(Std.string(weight), " ", 2);
		Gfx.drawSprite(471, 0, SPR_BAG);
		Tobor.fontSmall.drawString(488, 0, strWeight, Color.BLACK);
	}
	
	override public function renderUI() {
		Gfx.setOffset(0, 0);
		
		if (!editMode) {
			renderStatusLine();
		} else {
			renderMenuBar();
		}
		
		if (dialog != null) {
			dialog.render();
		} else {
			if (editMode) {
				if (cursorY > 0) {
					Gfx.drawSprite(cursorX * Tobor.TILE_WIDTH, cursorY * Tobor.TILE_HEIGHT, SPR_CURSOR);
				}
			}
		}
	}
	
	function renderMenuBar() {
		for (x in 0 ... 8) {
			if (x == 1) {
				Gfx.drawSprite(x * Tobor.TILE_WIDTH, 0, SPR_MODE_EDIT);
			} else {
				Gfx.drawSprite(x * Tobor.TILE_WIDTH, 0, SPR_ISOLATOR);
			}
			
			Gfx.drawSprite((39 - x) * Tobor.TILE_WIDTH, 0, SPR_ISOLATOR);
			
			// aktives Objekt
			Tobor.fontBig.drawString(9 * 16 + 8, 0, "[", Color.BLACK);
			Tobor.fontBig.drawString(11 * 16 - 4, 0, "]", Color.BLACK);
			
			Gfx.drawSprite(10 * Tobor.TILE_WIDTH, 0, game.world.factory.get(currentTile).spr);
			
			// (Debug) Anzahl Objekte im Raum
			var countEntities:Int = game.world.room.length;
			var strStatus:String = "Objekte: " + StringTools.lpad(Std.string(countEntities), "0", 4);
			Tobor.fontSmall.drawString(224, 0, strStatus, Color.BLACK);
		}
	}
}