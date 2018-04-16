package screens;

import ui.DialogQuestion;
import ui.DialogRooms;
import ui.DialogTiles;
import ui.DialogMenu;
import ui.DialogInventoryTemplate;
import world.Inventory;
import world.ObjectFactory.ObjectTemplate;
import world.World;
import world.entities.EntityItem;
import world.entities.Marker;
import world.entities.interfaces.IContainer;
import world.entities.std.StartPosition;

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
	var SPR_EFENCE:Sprite;
	
	var dialogTiles:DialogTiles;
	var dialogRooms:DialogRooms;
	
	var inventoryTemplate:Inventory;
	var dialogInventoryTemplate:DialogInventoryTemplate;
	
	public function new(game:Tobor) {
		SPR_EFENCE = Gfx.getSprite(64, 12);
		SPR_CURSOR = Gfx.getSprite(208, 240);
		SPR_MODE_PLAY = Gfx.getSprite(176, 240);
		SPR_MODE_EDIT = Gfx.getSprite(192, 240);
		
		game.world.editing = true;
		
		super(game);
		
		dialogTiles = new DialogTiles(this, 0, 0);
		
		dialogRooms = new DialogRooms(this, 0, 0);
		dialogRooms.onOk = function() {
			switchRoom(dialogRooms.roomX, dialogRooms.roomY, dialogRooms.roomZ);
		}
	}
	
	override public function update(deltaTime:Float) {
		cursorX = Math.floor(Input.mouseX / Tobor.TILE_WIDTH);
		cursorY = Math.floor(Input.mouseY / Tobor.TILE_HEIGHT);
				
		if (dialog != null) {
			dialog.update(deltaTime);
			return;
		} else {
			if (Input.isKeyDown([Input.key.ESCAPE])) {
				if (editMode) {
					showEditMenu();
				} else {
					showMainMenu();
				}
				
				return;
			} else if (Input.isKeyDown([Input.key.RETURN])) {
				if (editMode) {
					showDialog(dialogTiles);
					
					return;
				} else {
					showInventory();
					
					return;
				}
				
				return;
			} else if (Input.isKeyDown([Input.key.TAB])) {
				if (editMode) {
					showDialog(dialogRooms);
					
					return;
				}
			}
		
			if (!editMode) checkPlayerMovement();
			else checkRoomSwitch();
			
			if (cursorX == 1 && cursorY == 0 && Input.mouseBtnLeft) {
				switchEditMode();
				return;
			}
			
			if (Input.isKeyDown([Input.key.F5])) {
				if (!game.world.player.isMoving()) {
					switchEditMode();
					return;
				}
			}
			
			if (Input.mouseBtnLeft) {
				if (editMode) {
					if (cursorX >= 0 && cursorX < Room.WIDTH && cursorY >= 1 && cursorY <= Room.HEIGHT) {
						// im Raum zeichnen
						var template = game.world.factory.get(currentTile);
						
						if (template.name != "OBJ_CHARLIE") {
							var e:Entity = template.create();
							
							if (template.layer == Room.LAYER_MARKER) {
								var l:Array<Entity> = game.world.room.getAllEntitiesAt(cursorX, cursorY -  1);
								for (le in l) {
									le.setMarker(e.type);
								}
							} else if (template.layer == Room.LAYER_DRIFT) {
								var l:Array<Entity> = game.world.room.getAllEntitiesAt(cursorX, cursorY -  1);
								for (le in l) {
									le.setDrift(e.type);
								}
							} else {
								if (template.canBePlaced) {
									e.setPosition(cursorX, cursorY - 1);
									addEntity(e, template);
								}
							}
						} else {
							game.world.player.setPosition(cursorX, cursorY - 1);
							game.world.oldPlayerX = cursorX;
							game.world.oldPlayerY = cursorY - 1;
						}
						
						return;
					} else if (cursorX == 10 && cursorY == 0) {
						// den Objektwahl Dialog öffnen
						showDialog(dialogTiles);
						
						return;
					}
				}
			} else if (Input.mouseBtnRight) {
				if (editMode) {
					if (cursorX >= 0 && cursorX < Room.WIDTH && cursorY >= 1 && cursorY <= Room.HEIGHT) {
						var template = game.world.factory.get(currentTile);
						
						// Objekte an Position entfernen
						var list = game.world.room.getAllEntitiesAt(cursorX, cursorY - 1);
						
						for (e in list) {
							if (template.layer == Room.LAYER_MARKER) {
								e.setMarker(Marker.MARKER_NO);
							} else if (template.layer == Room.LAYER_DRIFT) {
								e.setDrift( -1);
							} else {
								// if (e.z == template.layer) {
									game.world.room.removeEntity(e);
								// }
							}
						}
						
						return;
					}
				}
			}
		}
		
		if (!editMode) game.world.update(deltaTime);
	}
	
	function checkRoomSwitch() {
		var rx:Int = game.world.room.position.x;
		var ry:Int = game.world.room.position.y;
		var rz:Int = game.world.room.position.z;
		
		if (Input.isKeyDown(Tobor.KEY_LEFT)) {
			switchRoom(rx - 1, ry, rz);
			Input.clearKeys();
		} else if (Input.isKeyDown(Tobor.KEY_RIGHT)) {
			switchRoom(rx + 1, ry, rz);
			Input.clearKeys();
		} else if (Input.isKeyDown(Tobor.KEY_UP)) {
			switchRoom(rx, ry - 1, rz);
			Input.clearKeys();
		} else if (Input.isKeyDown(Tobor.KEY_DOWN)) {
			switchRoom(rx, ry + 1, rz);
			Input.clearKeys();
		} else if (Input.isKeyDown([Input.key.PAGE_UP])) {
			switchRoom(rx, ry, rz - 1);
			Input.clearKeys();
		} else if (Input.isKeyDown([Input.key.PAGE_DOWN])) {
			switchRoom(rx, ry, rz + 1);
			Input.clearKeys();
		}
	}
	
	function switchRoom(x:Int, y:Int, z:Int) {
		if (x < 0 || x >= 10) return;
		if (y < 0 || y >= 10) return;
		if (z < 0 || z >= 10) return;
		
		game.world.room.saveState();
		
		var nextRoom:Room = game.world.rooms.find(x, y, z);
		
		if (nextRoom == null) {
			askNewRoom(function () {
				nextRoom = new Room(game.world, x, y, z);
				game.world.rooms.add(nextRoom);
				game.world.switchRoom(x, y, z);
				nextRoom.getName();
				hideDialog();
			});
		}
		
		if (nextRoom != null) {
			game.world.switchRoom(x, y, z);
			hideDialog();
		}
		
		game.world.room.restoreState();
	}

	function switchEditMode() {
		// kein Umschalten während Spieler sich bewegt oder unsichtbar ist
		if (getPlayer().isMoving() || !getPlayer().visible) return;
		
		if (editMode) {
			// Savestate anlegen
			game.world.room.saveState();
		}
		
		editMode = !editMode;
		
		Input.clearKeys();
		
		if (!editMode) {
			//game.world.inventory.clear();
			game.world.inventory.fillFrom(inventoryTemplate);
		} else {
			game.world.room.restoreState();
			game.world.player.setPosition(game.world.oldPlayerX, game.world.oldPlayerY);
		}
	}
	
	override public function render() {
		Gfx.setOffset(0, Tobor.TILE_HEIGHT);
		
		if (game.world.room == null) {
			return;
		}
		
		if (editMode) {
			var template = game.world.factory.get(currentTile);
			game.world.room.underRoof = template.layer != Room.LAYER_ROOF;
		}
		
		game.world.render(editMode);
	}
	
	override function renderStatusLine() {
		super.renderStatusLine();
		
		for (x in 0 ... 8) {
			if (x == 1) {
				Gfx.drawSprite(x * Tobor.TILE_WIDTH, 0, SPR_MODE_EDIT);
			} else {
				Gfx.drawSprite(x * Tobor.TILE_WIDTH, 0, SPR_ISOLATOR);
			}
			
			Gfx.drawSprite((39 - x) * Tobor.TILE_WIDTH, 0, SPR_ISOLATOR);
		}
		
		renderObjectCount();
	}
	
	override public function renderUI() {
		Gfx.setOffset(0, 0);
		
		if (!editMode) {
			renderStatusLine();
		} else {
			if (dialog == null || Std.is(dialog, DialogMenu)) {
				renderMenuBar();
			}
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
				Gfx.drawSprite(x * Tobor.TILE_WIDTH, 0, SPR_MODE_PLAY);
			} else {
				Gfx.drawSprite(x * Tobor.TILE_WIDTH, 0, SPR_EFENCE);
			}
			
			Gfx.drawSprite((39 - x) * Tobor.TILE_WIDTH, 0, SPR_EFENCE);
			
			// aktives Objekt
			Tobor.fontBig.drawString(9 * 16 + 8, 0, "[", Color.BLACK);
			Tobor.fontBig.drawString(11 * 16 - 4, 0, "]", Color.BLACK);
			
			Gfx.drawSprite(10 * Tobor.TILE_WIDTH, 0, game.world.factory.get(currentTile).spr);
			
			if (game.world.room != null) {
				var roomCoords:String = Text.get("TXT_EDITOR_ROOM") + " " 
					+ Std.string(game.world.room.position.x) 
					+ Std.string(game.world.room.position.y) 
					+ Std.string(game.world.room.position.z);
				
				Tobor.fontSmall.drawString(224, 0, roomCoords, Color.BLACK);
			}
			
			// Cursor Koordinaten
			if (cursorY > 0) {
				var strCoords:String = "" + StringTools.lpad(Std.string(cursorX), "0", 2) + ", " + StringTools.lpad(Std.string(cursorY - 1), "0", 2);
				Tobor.fontSmall.drawString(48, 1, strCoords, Color.BLACK, Color.WHITE);
			}
		
			renderObjectCount();
		}
	}
	
	function renderObjectCount() {
		if (game.world.room == null) {
			return;
		}
		
		var countEntities:Int;
		
		countEntities = game.world.room.length;
		
		var strStatus:String = Text.get("TXT_EDITOR_OBJECTS") + ": " + StringTools.lpad(Std.string(countEntities), "0", 4);
		Tobor.fontSmall.drawString(524, 1, strStatus, Color.BLACK, Color.WHITE);
	}
	
	override function showMainMenu() {
		var menu = new DialogMenu(this, 320, 166, [
			[Text.get("TXT_MENU_OPTIONS"), "", function () {
				showOptionMenu();
			}],
			[Text.get("TXT_MENU_HELP"), ""],
			[Text.get("TXT_MENU_SCREENSHOT"), "", function() {
				game.takeScreenShot();
				hideDialog();
			}],
		]);
		
		menu.select(0);
		
		menu.onCancel = function () {
			hideDialog();
		};
			
		menu.onOk = function () {
			hideDialog();
		};
		
		showDialog(menu);
	}
	
	function showEditOptionsMusic() {
		var menu = new DialogMenu(this, 320, 166, [
			[Text.get("TXT_ROOM_MUSIC_NONE"), "", function () {
				game.world.room.config.music = "";
				hideDialog();
			}],
			[Text.get("TXT_ROOM_MUSIC_NATURE"), "", function () {
				game.world.room.config.music = "MUS_NATURE";
				hideDialog();
			}],
		]);
		
		if (game.world.room.config.music == "MUS_NATURE") {
			menu.select(1);
		} else {
			menu.select(0);
		}
		
		menu.onCancel = function () {
			hideDialog();
		};
			
		menu.onOk = function () {
			hideDialog();
		};
		
		showDialog(menu);
	}
	
	function showEditOptions() {
		var menu = new DialogMenu(this, 320, 166, [
			[Text.get("TXT_MENU_EDIT_OPTIONS_MUSIC"), "", function () {
				showEditOptionsMusic();
			}],
		]);
		
		menu.select(0);
		
		menu.onCancel = function () {
			hideDialog();
		};
			
		menu.onOk = function () {
			hideDialog();
		};
		
		showDialog(menu);
	}
	
	function showEditMenu() {
		var menu = new DialogMenu(this, 320, 166, [
			[Text.get("TXT_MENU_CLEAR"), "", function () {
				askClearRoom();
			}],
			[Text.get("TXT_MENU_BORDERS"), "", function () {
				askRoomTemplate();
			}],
			[Text.get("TXT_MENU_OPTIONS"), "", function () {
				showEditOptions();
			}],
			[Text.get("TXT_MENU_CHOOSE_SCENE"), "TAB", function() {
				showDialog(dialogRooms);
			}],
			[Text.get("TXT_MENU_OBJECTS"), "ENTER", function () {
				showDialog(dialogTiles);
			}],
			[Text.get("TXT_MENU_EDIT_INVENTORY"), "", function () {
				showInventoryTemplate();
			}],
			[Text.get("TXT_MENU_HELP"), ""],
			[Text.get("TXT_MENU_SAVE"), "", function () {
				game.world.save();
				hideDialog();
			}],
			[Text.get("TXT_MENU_LOAD"), "", function () {
				// game.world.load();
				game.world = new World(game, game.world.file);
				game.setScreen(new EditorScreen(game));
				// hideDialog();
			}],
			[Text.get("TXT_MENU_CANCEL"), "", function() {
				game.setScreen(new IntroScreen(game));
			}],
			[Text.get("TXT_MENU_SCREENSHOT"), "", function() {
				game.takeScreenShot();
				hideDialog();
			}],
		]);
		
		menu.select(2);
		
		menu.onCancel = function () {
			hideDialog();
		};
			
		menu.onOk = function () {
			// hideDialog();
		};
		
		showDialog(menu);
	}
	
	function askClearRoom() {
		var d:DialogQuestion = new DialogQuestion(this, 0, 0, Text.get("TXT_EDITOR_ASK_REMOVE_OBJECTS_FROM_ROOM"));
		d.index = 1;
		
		d.onOk = function () {
			game.world.room.clear();
			hideDialog();
		}
		
		showDialog(d);
	}
	
	function askRoomTemplate() {
		var d:DialogQuestion = new DialogQuestion(this, 0, 0, Text.get("TXT_EDITOR_ASK_CREATE_ROOM_BORDER"));
		d.index = 0;
		
		d.onOk = function () {
			var tmpl:ObjectTemplate = game.world.factory.findFromID("OBJ_WALL_HARD");
			
			if (tmpl != null) {
				for (x in 0 ... Room.WIDTH) {
					for (y in 0 ... Room.HEIGHT) {
						if (x == 0 || x == Room.WIDTH - 1 || y == 0 || y == Room.HEIGHT - 1) {
							addEntity(tmpl.create().setPosition(x, y), tmpl);
						}
					}
				}
			}
			
			hideDialog();
		}
		
		showDialog(d);
	}
	
	function askNewRoom(cb:Dynamic) {
		var d:DialogQuestion = new DialogQuestion(this, 0, 0, Text.get("TXT_EDITOR_ASK_CREATE_NEW_ROOM"));
		d.index = 0;
		
		d.onOk = cb;
		
		showDialog(d);
	}
	
	function addEntity(e:Entity, template:ObjectTemplate) {
		if (Std.is(e, EntityItem)) {
			var container:Array<Entity> = game.world.room.findEntityAt(e.x, e.y, IContainer);
			if (container.length > 0) {
				for (ce in container) {
					ce.setContent(template.name);
				}
			
				return;
			}
		}
		
		var atPosition:Array<Entity> = game.world.room.getAllEntitiesAt(e.x, e.y);
			
		for (o in atPosition) {
			if (o.z == e.z) {
				return;
			}
		}
		
		if (Std.is(e, StartPosition)) {
			game.world.clearStartPositions();
		}
		
		game.world.room.addEntity(e);
	}
	
	function showInventoryTemplate() {
		if (!editMode) return;
		
		if (dialogInventoryTemplate == null) {
			inventoryTemplate = new Inventory();
			
			for (item in game.world.factory.listItems) {
				// inventoryTemplate.add(item.name, item.spr, 1);
				inventoryTemplate.set(item.name, item.spr, 0);
			}
			
			dialogInventoryTemplate = new DialogInventoryTemplate(this, 0, 0, inventoryTemplate);
		
			dialogInventoryTemplate.onOk = function () {
				hideDialog();
			}
		
			dialogInventoryTemplate.onCancel = function () {
				hideDialog();
			}
		}
		
		showDialog(dialogInventoryTemplate);
	}
}