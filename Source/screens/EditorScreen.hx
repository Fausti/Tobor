package screens;

import lime.system.System;
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
	public static var COLOR_TRANSPARENT:Color = new Color(1, 1, 1, 0.5);
	
	var editMode:Bool = true;
	
	public var cursorX:Int;
	public var cursorY:Int;
	var oldCursorX:Int = -1;
	var oldCursorY:Int = -1;
	
	var brush:Int = 0;
	
	var brushes = [
		[
			[1]
		],
		[
			[0, 1, 0],
			[1, 1, 1],
			[0, 1, 0]
		],
		[
			[0, 0, 1, 0, 0],
			[0, 1, 1, 1, 0],
			[1, 1, 1, 1, 1],
			[0, 1, 1, 1, 0],
			[0, 0, 1, 0, 0]
		]
	];
	
	var brushSpr:Array<Sprite>;
	var brushSprActive:Array<Sprite>;
	
	var autoTiling:Bool = false;
	var autoSpr:Sprite;
	var autoSprActive:Sprite;
	
	public var currentTile:Int = 0;
	
	var SPR_CURSOR:Sprite;
	var SPR_MODE_PLAY:Sprite;
	var SPR_MODE_EDIT:Sprite;
	var SPR_EFENCE:Sprite;
	var SPR_SELECTOR:Sprite;
	
	var SPR_DISC_0:Sprite;
	var SPR_DISC_1:Sprite;
	
	var dialogTiles:DialogTiles;
	var dialogRooms:DialogRooms;
	
	var inventoryTemplate:Inventory;
	var dialogInventoryTemplate:DialogInventoryTemplate;
	
	var changed:Bool = false;
	
	public function new(game:Tobor) {
		brushSpr = [
			Gfx.getSprite(176, 432),
			Gfx.getSprite(176 + 16, 432),
			Gfx.getSprite(176 + 32, 432),
		];
		
		brushSprActive = [
			Gfx.getSprite(176, 432 + 12),
			Gfx.getSprite(176 + 16, 432 + 12),
			Gfx.getSprite(176 + 32, 432 + 12),
		];
		
		autoSpr = Gfx.getSprite(224, 432);
		autoSprActive = Gfx.getSprite(224, 444);
		
		SPR_SELECTOR = Gfx.getSprite(160, 240);
		
		SPR_DISC_0 = Gfx.getSprite(240, 432);
		SPR_DISC_1 = Gfx.getSprite(240, 432 + 12);
		
		SPR_EFENCE = Gfx.getSprite(64, 12);
		SPR_CURSOR = Gfx.getSprite(208, 240);
		SPR_MODE_PLAY = Gfx.getSprite(176, 240);
		SPR_MODE_EDIT = Gfx.getSprite(192, 240);
		
		game.world.editing = true;
		
		super(game);
		
		dialogTiles = new DialogTiles(this, 0, 0);
		dialogTiles.onOk = function() {
			checkBrushSetting();
		}
		
		dialogTiles.onCancel = function() {
			checkBrushSetting();
		}
		
		dialogRooms = new DialogRooms(this, 0, 0);
		dialogRooms.onOk = function() {
			switchRoom(dialogRooms.roomX, dialogRooms.roomY, dialogRooms.roomZ, true, false);
		}
	}
	
	function checkBrushSetting() {
		var template = game.world.factory.get(currentTile);
		if (!template.allowBrush) brush = 0;
		
		autoTiling = false;
		
		oldCursorX = -1;
		oldCursorY = -1;
	}
	
	function hasBrush():Bool {
		var template = game.world.factory.get(currentTile);
		return template.allowBrush;
	}
	
	function hasAutoTiling():Bool {
		var template = game.world.factory.get(currentTile);
		if (template.autoFull == null || template.autoEdges == null) return false;
		
		return true;
	}
	
	override public function update(deltaTime:Float) {
		// Cursorposition aus Mauskoordinaten errechnen
		cursorX = Math.floor(Input.mouseX / Tobor.TILE_WIDTH);
		cursorY = Math.floor(Input.mouseY / Tobor.TILE_HEIGHT);
		
		// Dialogbox updaten...
		if (dialog != null) {
			dialog.update(deltaTime);
			return;
		}
		
		if (game.world.isLoading) return;
		
		if (game.world.canStart) {
			getWorld().start();
			game.world.canStart = false;
		}
		
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
		
		if (!editMode) {
			checkPlayerMovement();
		} else {
			checkRoomSwitch();
				
			if (Input.wheelUp()) {
				currentTile--;
				if (currentTile < 0) currentTile = 0;
					
				checkBrushSetting();
			} else if (Input.wheelDown()) {
				currentTile++;
				if (currentTile > game.world.factory.length) {
					currentTile = game.world.factory.length - 1;
				}
					
				checkBrushSetting();
			}
		}
		
		if (cursorX == 0 && cursorY == 0 && Input.mouseBtnLeft) {
			if (changed) {
				oldCursorX = -1;
				oldCursorY = -1;
						
				changed = false;
				game.world.save();
			
				Input.clearKeys();
			}
			return;
		}
			
		if (cursorX == 2 && cursorY == 0 && Input.mouseBtnLeft) {
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
					if (cursorX != oldCursorX || cursorY != oldCursorY) {
						changed = true;
						
						oldCursorX = cursorX;
						oldCursorY = cursorY;
								
						// im Raum zeichnen
						var template = game.world.factory.get(currentTile);
						
						if (template.name != "OBJ_CHARLIE") {
							if (brush == 0) {
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
								// if (cursorX != oldCursorX || cursorY != oldCursorY) {
									addBrush(template);
									// oldCursorX = cursorX;
									// oldCursorY = cursorY;
								//}
							}
						} else {
							game.world.player.setPosition(cursorX, cursorY - 1);
							game.world.oldPlayerX = cursorX;
							game.world.oldPlayerY = cursorY - 1;
						}
					
						return;
					}
				} else if (cursorX == 10 && cursorY == 0) {
					// den Objektwahl Dialog öffnen
					showDialog(dialogTiles);
					
					return;
				}  else if (cursorX >= 12 && cursorX <= 14 && cursorY == 0) {
					// Brush wählen
					brush = cursorX - 12;
					autoTiling = false;
					
					checkBrushSetting();
					
					return;
				} else if (cursorX == 16 && cursorY == 0) {
					if (autoTiling) autoTiling = false;
					else {
						autoTiling = hasAutoTiling();
						brush = 0;
					}
					
					Input.clearKeys();
				}
			}
		} else if (Input.mouseBtnMiddle) {
			if (editMode) {
				if (autoTiling) autoTiling = false;
				else {
					autoTiling = hasAutoTiling();
					brush = 0;
				}
				
				Input.clearKeys();
			}
		} else if (Input.mouseBtnRight) {
			if (editMode) {
				oldCursorX = -1;
				oldCursorY = -1;
				
				if (cursorX >= 0 && cursorX < Room.WIDTH && cursorY >= 1 && cursorY <= Room.HEIGHT) {
					changed = true;
					
					var template = game.world.factory.get(currentTile);
					
					if (brush == 0) {
						// Objekte an Position entfernen
						var list = game.world.room.getAllEntitiesAt(cursorX, cursorY - 1);
					
						for (e in list) {
							if (template.layer == Room.LAYER_MARKER) {
								e.setMarker(Marker.MARKER_NO);
							} else if (template.layer == Room.LAYER_DRIFT) {
								e.setDrift( -1);
							} else {
								if (template.layer == Room.LAYER_ROOF) {
									if (e.z == Room.LAYER_ROOF) {
										game.world.room.removeEntity(e);
									}
								} else {
									if (e.subType > 0) {
										e.subType = 0;
										
										oldCursorX = cursorX;
										oldCursorY = cursorY;
									} else {
										game.world.room.removeEntity(e);
									}
								}
							}
						}
					} else {
						if (cursorX != oldCursorX || cursorY != oldCursorY) {
							removeBrush(template);
							oldCursorX = cursorX;
							oldCursorY = cursorY;
						}
					}
					
					return;
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
		} else if (Input.isKeyDown([Input.key.PAGE_UP, Input.key.MINUS])) {
			switchRoom(rx, ry, rz - 1);
			Input.clearKeys();
		} else if (Input.isKeyDown([Input.key.PAGE_DOWN, Input.key.PLUS])) {
			switchRoom(rx, ry, rz + 1);
			Input.clearKeys();
		}
	}
	
	public function switchRoom(x:Int, y:Int, z:Int, ?ask:Bool = true, ?saveState:Bool = true) {
		if (x < 0 || x >= 10) return;
		if (y < 0 || y >= 10) return;
		if (z < 0 || z >= 10) return;
		
		if (saveState) game.world.room.saveState();
		
		var nextRoom:Room = game.world.rooms.find(x, y, z);
		
		if (nextRoom == null) {
			if (ask) {
				askNewRoom(function () {
					nextRoom = new Room(game.world, x, y, z);
					game.world.rooms.add(nextRoom);
					game.world.switchRoom(x, y, z);
					nextRoom.getName();
					hideDialog();
				});
			}
		}
		
		if (nextRoom != null) {
			game.world.switchRoom(x, y, z);
			if (ask) hideDialog();
		}
		
		game.world.room.restoreState();
	}
	
	public function switchRoomPreview(x:Int, y:Int, z:Int) {
		if (x < 0 || x >= 10) return;
		if (y < 0 || y >= 10) return;
		if (z < 0 || z >= 10) return;
		
		var nextRoom:Room = game.world.rooms.find(x, y, z);

		if (nextRoom != null) {
			game.world.switchRoomTo(nextRoom);
		}
		
		// game.world.room.restoreState();
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
		
		oldCursorX = -1;
		oldCursorY = -1;
	}
	
	override public function render() {
		Gfx.setOffset(0, Tobor.TILE_HEIGHT);
		
		if (game.world.isLoading) {
			renderLoadingProcess();
			return;
		}
		
		if (game.world.room == null) {
			return;
		}
		
		if (editMode) {
			game.drawLight = false;
			var template = game.world.factory.get(currentTile);
			game.world.room.underRoof = template.layer != Room.LAYER_ROOF;
		} else {
			checkDarkness();
		}
		
		if (dialog == dialogRooms) {
			game.world.renderPreview();
		} else {
			game.world.render(editMode);
		}
	}
	
	override function renderStatusLine() {
		super.renderStatusLine();
		
		for (x in 0 ... 8) {
			if (x == 2) {
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
		Gfx.drawTexture(0, 0, 40 * Tobor.TILE_WIDTH, Tobor.TILE_HEIGHT, SPR_NONE.uv, Color.WHITE);
		
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
			if (!game.world.isLoading) {
				if (editMode) {
					if (cursorY > 0) {
						for (xx in (0 - brush) ... (1 + brush)) {
							for (yy in (0 - brush) ... (1 + brush)) {
								if (brushes[brush][brush + yy][brush + xx] == 1) {
									var px:Int = cursorX + xx;
									var py:Int = cursorY + yy;
								
									if (px >= 0 && px < Room.WIDTH && py >= 1 && py <= Room.HEIGHT) {
										Gfx.drawSprite(px * Tobor.TILE_WIDTH, py * Tobor.TILE_HEIGHT, game.world.factory.get(currentTile).spr, COLOR_TRANSPARENT);
										if (xx == 0 && yy == 0) Gfx.drawSprite(px * Tobor.TILE_WIDTH, py * Tobor.TILE_HEIGHT, SPR_CURSOR, COLOR_TRANSPARENT);
									}
								}
							}
						}
					}
				}
			}
		}
	}
	
	function renderMenuBar() {
		for (x in 0 ... 8) {
			Gfx.drawSprite(x * Tobor.TILE_WIDTH, 0, SPR_EFENCE);
			
			if (x == 0) {
				Gfx.drawSprite(x * Tobor.TILE_WIDTH, 0, changed?SPR_DISC_1:SPR_DISC_0);
			} else if (x == 2) {
				Gfx.drawSprite(x * Tobor.TILE_WIDTH, 0, SPR_MODE_PLAY);
			}
			
			Gfx.drawSprite((39 - x) * Tobor.TILE_WIDTH, 0, SPR_EFENCE);
			
			// aktives Objekt
			Tobor.fontBig.drawString(9 * 16 + 8, 0, "[", Color.BLACK);
			Tobor.fontBig.drawString(11 * 16 - 4, 0, "]", Color.BLACK);
			
			Gfx.drawSprite(10 * Tobor.TILE_WIDTH, 0, game.world.factory.get(currentTile).spr);
			// Gfx.drawSprite(10 * Tobor.TILE_WIDTH, 0, SPR_SELECTOR);
			
			for (x in 0 ... 3) {
				if (brush == x) {
					Gfx.drawSprite((12 + x) * Tobor.TILE_WIDTH, 0, brushSprActive[x]);
				} else {
					if (hasBrush()) {
						Gfx.drawSprite((12 + x) * Tobor.TILE_WIDTH, 0, brushSpr[x]);
					} else {
						Gfx.drawSprite((12 + x) * Tobor.TILE_WIDTH, 0, brushSpr[x], Color.GRAY);
					}
				}
			}
			
			if (autoTiling) {
				Gfx.drawSprite(16 * Tobor.TILE_WIDTH, 0, autoSprActive);
			} else {
				if (hasAutoTiling()) {
					Gfx.drawSprite(16 * Tobor.TILE_WIDTH, 0, autoSpr);
				} else {
					Gfx.drawSprite(16 * Tobor.TILE_WIDTH, 0, autoSpr, Color.GRAY);
				}
			}
			
			if (game.world.room != null) {
				var roomCoords:String = Text.get("TXT_EDITOR_ROOM") + " " 
					+ Std.string(game.world.room.position.x) 
					+ Std.string(game.world.room.position.y) 
					+ Std.string(game.world.room.position.z);
				
				Tobor.fontSmall.drawString(224 + 64, 0, roomCoords, Color.BLACK);
			}
			
			// Cursor Koordinaten
			if (cursorY > 0) {
				var strCoords:String = "" + StringTools.lpad(Std.string(cursorX), "0", 2) + ", " + StringTools.lpad(Std.string(cursorY - 1), "0", 2);
				Tobor.fontSmall.drawString(48 + 16, 1, strCoords, Color.BLACK, Color.WHITE);
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
	
	override function showMainMenu(atX:Int = 320, atY:Int = 166) {
		var menu = new DialogMenu(this, atX, atY, [
			[Text.get("TXT_MENU_OPTIONS"), ">>", function () {
				showOptionMenu(atX, atY);
			}],
			[Text.get("TXT_MENU_HELP"), ""],
			[Text.get("TXT_MENU_SCREENSHOT"), "F12", function() {
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
	
	function showEditOptionsDarkness(atX:Int = 320, atY:Int = 166) {
		var menu = new DialogMenu(this, atX, atY, [
			[Text.get("TXT_ROOM_DARKNESS_NONE"), "", function () {
				game.world.room.config.darkness = Room.DARKNESS_OFF;
				hideDialog();
			}],
			[Text.get("TXT_ROOM_DARKNESS_HALF"), "", function () {
				game.world.room.config.darkness = Room.DARKNESS_HALF;
				hideDialog();
			}],
			[Text.get("TXT_ROOM_DARKNESS_FULL"), "", function () {
				game.world.room.config.darkness = Room.DARKNESS_FULL;
				hideDialog();
			}],
		]);
		
		menu.select(game.world.room.config.darkness);
		
		menu.onCancel = function () {
			hideDialog();
		};
			
		menu.onOk = function () {
			hideDialog();
		};
		
		showDialog(menu);
	}
	
	function showEditOptionsMusic(atX:Int = 320, atY:Int = 166) {
		var menu = new DialogMenu(this, atX, atY, [
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
	
	function showEditOptionsRingEffects(atX:Int = 320, atY:Int = 166) {
		var menu = new DialogMenu(this, atX, atY, [
			[Text.get("TXT_RINGS_OFF"), "", function () {
				game.world.config.ringEffects = false;
				hideDialog();
			}],
			[Text.get("TXT_RINGS_ON"), "", function () {
				game.world.config.ringEffects = true;
				hideDialog();
			}],
		]);
		
		if (game.world.config.ringEffects) {
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
	
	function showEditOptionsWinCondition(atX:Int = 320, atY:Int = 166) {
		var menu = new DialogMenu(this, atX, atY, [
			[Text.get("TXT_WIN_CONDITION_0"), "", function () {
				game.world.config.winType = World.WIN_FLAG_ONLY;
				hideDialog();
			}],
			[Text.get("TXT_WIN_CONDITION_1"), "", function () {
				game.world.config.winType = World.WIN_RING_1;
				hideDialog();
			}],
			[Text.get("TXT_WIN_CONDITION_2"), "", function () {
				game.world.config.winType = World.WIN_RING_2;
				hideDialog();
			}],
			[Text.get("TXT_WIN_CONDITION_3"), "", function () {
				game.world.config.winType = World.WIN_RING_3;
				hideDialog();
			}],
			[Text.get("TXT_WIN_CONDITION_4"), "", function () {
				game.world.config.winType = World.WIN_RING_4;
				hideDialog();
			}],
		]);
		
		menu.select(game.world.config.winType);
		
		menu.onCancel = function () {
			hideDialog();
		};
			
		menu.onOk = function () {
			hideDialog();
		};
		
		showDialog(menu);
	}
	
	function showEditOptions(atX:Int = 320, atY:Int = 166) {
		var menu = new DialogMenu(this, atX, atY, [
			[Text.get("TXT_MENU_EDIT_OPTIONS_WIN_CONDITION"), ">>", function () {
				showEditOptionsWinCondition(atX, atY);
			}],
			[Text.get("TXT_MENU_EDIT_OPTIONS_RING_EFFECTS"), ">>", function () {
				showEditOptionsRingEffects(atX, atY);
			}],
			[Text.get("TXT_MENU_EDIT_OPTIONS_MUSIC"), ">>", function () {
				showEditOptionsMusic(atX, atY);
			}],
			[Text.get("TXT_MENU_EDIT_OPTIONS_DARKNESS"), ">>", function () {
				showEditOptionsDarkness(atX, atY);
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
	
	function showEditEditMenu(atX:Int = 320, atY:Int = 166) {
		var menu = new DialogMenu(this, atX, atY, [
		/*
			[Text.get("TXT_MENU_COPY"), "", function () {
				// askClearRoom();
			}],
			[Text.get("TXT_MENU_CUT"), "", function () {
				// askClearRoom();
			}],
			[Text.get("TXT_MENU_PASTE"), "", function () {
				// askClearRoom();
			}],
			["", "", function () {
				
			}],
		*/
			[Text.get("TXT_MENU_CLEAR"), "", function () {
				askClearRoom();
			}],
			[Text.get("TXT_MENU_BORDERS"), "", function () {
				askRoomTemplate();
			}],
			["", "", function () {
				
			}],
			[Text.get("TXT_MENU_OPTIONS"), ">>", function () {
				showEditOptions(atX, atY);
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
	
	function showEditMenu(atX:Int = 320, atY:Int = 166) {
		var menu = new DialogMenu(this, atX, atY, [
			[Text.get("TXT_MENU_EDIT"), ">>", function () {
				showEditEditMenu(atX, atY);
			}],
			["", "", function () {
				
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
			["", "", function () {
				
			}],
			[Text.get("TXT_MENU_HELP"), "", function () {
				System.openURL("https://github.com/Fausti/Tobor#inhalt");
				hideDialog();
			}],
			[Text.get("TXT_MENU_SAVE"), "", function () {
				changed = false;
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
			["", "", function () {
				
			}],
			[Text.get("TXT_MENU_SCREENSHOT"), "F12", function() {
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
			game.world.room.clear(true);
			changed = true;
			hideDialog();
		}
		
		showDialog(d);
	}
	
	function askRoomTemplate() {
		var d:DialogQuestion = new DialogQuestion(this, 0, 0, Text.get("TXT_EDITOR_ASK_CREATE_ROOM_BORDER"));
		d.index = 0;
		
		d.onOk = function () {
			changed = true;
			
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
	
	function removeBrush(template:ObjectTemplate) {
		if (!template.canBePlaced) return;
		
		changed = true;
		
		for (xx in (0 - brush) ... (1 + brush)) {
			for (yy in (0 - brush) ... (1 + brush)) {
				if (brushes[brush][brush + yy][brush + xx] == 1) {
					var px:Int = cursorX + xx;
					var py:Int = cursorY + yy;
								
					if (px >= 0 && px < Room.WIDTH && py >= 1 && py <= Room.HEIGHT) {
						// Objekte an Position entfernen
						var list = game.world.room.getAllEntitiesAt(px, py - 1, template.classPath);
						
						for (e in list) {
							if (template.layer == Room.LAYER_MARKER) {
								e.setMarker(Marker.MARKER_NO);
							} else if (template.layer == Room.LAYER_DRIFT) {
								e.setDrift( -1);
							} else {
								if (template.layer == Room.LAYER_ROOF) {
									if (e.z == Room.LAYER_ROOF) {
										game.world.room.removeEntity(e);
									}
								} else {
									game.world.room.removeEntity(e);
								}
							}
						}
					}
				}
			}
		}
	}
	
	function addBrush(template:ObjectTemplate) {
		if (!template.canBePlaced) return;
		
		changed = true;
		
		for (xx in (0 - brush) ... (1 + brush)) {
			for (yy in (0 - brush) ... (1 + brush)) {
				if (brushes[brush][brush + yy][brush + xx] == 1) {
					var px:Int = cursorX + xx;
					var py:Int = cursorY + yy;
								
					if (px >= 0 && px < Room.WIDTH && py >= 1 && py <= Room.HEIGHT) {
						var atPosition:Array<Entity> = game.world.room.getAllEntitiesAt(px, py - 1);
						
						if (atPosition.length == 0 || template.layer == Room.LAYER_ROOF) {
							var e:Entity = template.createRandom();
							if (e != null) {
								e.setPosition(px, py - 1);
								addEntity(e, template);
							}
						} else {
							var e:Entity = template.createRandom();
							if (e != null) {
								e.setPosition(px, py - 1);
							}
								
							for (o in atPosition) {
								if (combine(o, e)) break;
							}
						}
					}
				}
			}
		}
	}
	
	function combine(e1:Entity, e2:Entity):Bool {
		if (e1.canCombine(e2)) {
			e1.doCombine(e2);
			return true;
		} else {
			if (e2.canCombine(e1, true)) {
				game.world.room.addEntity(e2);
				game.world.room.removeEntity(e1);
				
				e2.doCombine(e1, true);
				
				return true;
			}
		}
		
		return false;
	}
	
	function addEntity(e:Entity, template:ObjectTemplate) {
		changed = true;
		
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
			
			// können Objekte kombiniert werden?
			if (combine(o, e)) return;
			
			if (o.z == e.z) {
				if (!autoTiling) return;
				else {
					if (!Std.is(o, template.classPath)) return;
					else {
						game.world.room.removeEntity(o);
					}
				}
			}
		}
		
		if (Std.is(e, StartPosition)) {
			game.world.clearStartPositions();
		}
		
		if (autoTiling && brush == 0) {
			var nTileable:Int = 0;
			var nSameClass:Int = 0;
			var atN:Bool = false;
			var atS:Bool = false;
			var atW:Bool = false;
			var atE:Bool = false;
			
			for (ee in getRoom().findEntityAt(e.x, e.y - 1, template.classPath)) {
				if (template.isTileable(ee.type)) atN = true;
				nSameClass++;
			}
			if (atN) nTileable++;
			
			for (ee in getRoom().findEntityAt(e.x, e.y + 1, template.classPath)) {
				if (template.isTileable(ee.type)) atS = true;
				nSameClass++;
			}
			if (atS) nTileable++;
			
			for (ee in getRoom().findEntityAt(e.x - 1, e.y, template.classPath)) {
				if (template.isTileable(ee.type)) atW = true;
				nSameClass++;
			}
			if (atW) nTileable++;
			
			for (ee in getRoom().findEntityAt(e.x + 1, e.y, template.classPath)) {
				if (template.isTileable(ee.type)) atE = true;
				nSameClass++;
			}
			if (atE) nTileable++;
			
			if (nTileable == 2) {
				if (atN && atW) {
					if (nSameClass == 2) e.type = template.getAutoTile(0);
					else e.type = template.autoFull[Std.random(template.autoFull.length)];
				} else if (atN && atE) {
					if (nSameClass == 2) e.type = template.getAutoTile(1);
					else e.type = template.autoFull[Std.random(template.autoFull.length)];
				} else if (atS && atE) {
					if (nSameClass == 2) e.type = template.getAutoTile(2);
					else e.type = template.autoFull[Std.random(template.autoFull.length)];
				} else if (atS && atW) {
					if (nSameClass == 2) e.type = template.getAutoTile(3);
					else e.type = template.autoFull[Std.random(template.autoFull.length)];
				} else {
					e.type = template.autoFull[Std.random(template.autoFull.length)];
				}
			}
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