package ui;

import lime.math.Rectangle;
import screens.EditorScreen;
import world.World;
import world.Room;

/**
 * ...
 * @author Matthias Faust
 */
class DialogRooms extends Dialog {
	var rooms:Array<Array<Array<Bool>>>;
	
	public var roomX:Int;
	public var roomY:Int;
	public var roomZ:Int;
	
	var editor:EditorScreen;
	var world:World;
		
	var SPR_NONE:Sprite;
	
	var SPR_SELECTOR_ROOM_NW:Sprite;
	var SPR_SELECTOR_ROOM_NE:Sprite;
	var SPR_SELECTOR_ROOM_SW:Sprite;
	var SPR_SELECTOR_ROOM_SE:Sprite;
	
	var SPR_SCROLLBAR_UP:Sprite;
	var SPR_SCROLLBAR_DOWN:Sprite;
	var SPR_SCROLLBAR_0:Sprite;
	var SPR_SCROLLBAR_1:Sprite;
	
	var rectFrame:Rectangle;
	var rectUp:Rectangle;
	var rectDown:Rectangle;
	
	public function new(screen:Screen, x:Int, y:Int) {
		super(screen, x, y);
	
		this.editor = cast screen;
		this.world = screen.game.world;
		
		SPR_NONE = Gfx.getSprite(0, 0);
		SPR_SELECTOR_ROOM_NW = Gfx.getSprite(8 * 16, 18 * 12);
		SPR_SELECTOR_ROOM_NE = Gfx.getSprite(9 * 16, 18 * 12);
		SPR_SELECTOR_ROOM_SW = Gfx.getSprite(8 * 16, 19 * 12);
		SPR_SELECTOR_ROOM_SE = Gfx.getSprite(9 * 16, 19 * 12);
		
		SPR_SCROLLBAR_UP = Gfx.getSprite(112, 24);
		SPR_SCROLLBAR_DOWN = Gfx.getSprite(144, 24);
		SPR_SCROLLBAR_0 = Gfx.getSprite(240, 0);
		SPR_SCROLLBAR_1 = Gfx.getSprite(64, 12);
		
		rooms = [];
		for (_z in 0 ... 10) {
			rooms.push([]);
			for (_x in 0 ... 10) {
				rooms[_z].push([]);
				for (_y in 0 ... 10) {
					rooms[_z][_x].push(false);
				}
			}
		}
		
		rectFrame = new Rectangle(
			160 - Tobor.frameBig.sizeX - 8, 
			60 - Tobor.frameBig.sizeY, 
			23 * Tobor.frameBig.sizeX, 
			22 * Tobor.frameBig.sizeY
		);
		
		rectUp = new Rectangle(480 - 4, 60, 16 ,12);
		rectDown = new Rectangle(480 - 4, 60 + 19 * 12, 16, 12);
	}
	
	override public function show() {
		roomX = world.room.position.x;
		roomY = world.room.position.y;
		roomZ = world.room.position.z;
		
		for (r in world.rooms) {
			rooms[r.position.z][r.position.x][r.position.y] = true;
		}
	}
	
	override
	public function update(deltaTime:Float) {
		// befindet sich der Mauszeiger innerhalb des Rahmens?
		if (rectFrame.contains(Input.mouseX, Input.mouseY)) {
			
			// Raumkoordinaten unter dem Mauszeiger berechnen
			var mouseRoomX:Int = Std.int((Input.mouseX - rectFrame.x - Tobor.frameBig.sizeX) / 32);
			var mouseRoomY:Int = Std.int((Input.mouseY - rectFrame.y - Tobor.frameBig.sizeY) / 24);
			
			// befindet sich der Mauszeiger über einem Raum?
			if (mouseRoomX >= 0 && mouseRoomX < 10 && mouseRoomY >= 0 && mouseRoomY < 10) {
				roomX = mouseRoomX;
				roomY = mouseRoomY;
				
				if (Input.mouseBtnLeft) {
					ok();
					Input.wait(0.25);
				}
			} else {
				if (Input.mouseBtnLeft) {
					if (rectUp.contains(Input.mouseX, Input.mouseY)) {
						roomZ--;
						Input.clearKeys();
					} else if (rectDown.contains(Input.mouseX, Input.mouseY)) {
						roomZ++;
						Input.clearKeys();
					}
				}
			}
		}
		
		if (Input.wheelUp()) {
			roomZ--;
		} else if (Input.wheelDown()) {
			roomZ++;
		}
		
		if (Input.isKeyDown(Tobor.KEY_ENTER)) {
			ok();
			Input.wait(2);
		}
		
		if (Input.isKeyDown(Tobor.KEY_ESC)) {
			screen.showDialog(null);
			Input.wait(2);
		}
		
		if (Input.isKeyDown(Tobor.KEY_RIGHT)) {
			roomX++;
			Input.wait(0.2);
		} else if (Input.isKeyDown(Tobor.KEY_LEFT)) {
			roomX--;
			Input.wait(0.2);
		} else if (Input.isKeyDown(Tobor.KEY_UP)) {
			roomY--;
			Input.wait(0.2);
		} else if (Input.isKeyDown(Tobor.KEY_DOWN)) {
			roomY++;
			Input.wait(0.2);
		}
		
		if (Input.isKeyDown([Input.key.PAGE_UP, Input.key.MINUS])) {
			roomZ--;
			Input.wait(0.2);
		} else if (Input.isKeyDown([Input.key.PAGE_DOWN, Input.key.PLUS])) {
			roomZ++;
			Input.wait(0.2);
		}
		
		if (roomX < 0) roomX = 0;
		if (roomX > 9) roomX = 9;
		if (roomY < 0) roomY = 0;
		if (roomY > 9) roomY = 9;
		if (roomZ < 0) roomZ = 0;
		if (roomZ > 9) roomZ = 9;
		
		if (world.room.position.x != roomX || world.room.position.y != roomY || world.room.position.z != roomZ) {
			editor.switchRoom(roomX, roomY, roomZ, false);
		}
	}
	
	override
	public function render() {
		// Statusline
		for (_x in 0 ... 8) {
			Gfx.drawSprite(_x * Tobor.TILE_WIDTH, 0, SPR_NONE, Color.LIGHT_GREEN);
			Gfx.drawSprite((39 - _x) * Tobor.TILE_WIDTH, 0, SPR_NONE, Color.LIGHT_GREEN);
		}
		
		var room:Room = world.rooms.find(roomX, roomY, roomZ);
		if (room == null) {
			Tobor.fontSmall.drawString(9 * Tobor.TILE_WIDTH, 0, Text.get("TXT_EDITOR_NO_ROOM"), Color.BLACK);
		} else {
			Tobor.fontSmall.drawString(9 * Tobor.TILE_WIDTH, 0, room.getName(), Color.BLACK);
		}
		
		// Raumauswahl
		Tobor.frameBig.drawBoxRect(rectFrame);
		
		for (xx in 0 ... 10) {
			for (yy in 0 ... 10) {
				if (xx == roomX && yy == roomY) {
					if (rooms[roomZ][xx][yy]) drawRoom(160 - 8, 60, xx, yy, true);
					else drawEmpty(160 - 8, 60, xx, yy);
				} else {
					if (rooms[roomZ][xx][yy]) drawRoom(160 - 8, 60, xx, yy, false);
				}
			}
		}
		
		// Ebenenleiste
		for (i in 0 ... 20) {
			var part = Math.floor(i / 2);
			
			if (i == 0) {
				Gfx.drawSprite(480 - 4, 60 + i * 12, SPR_SCROLLBAR_UP);
			} else if (i == 19) {
				Gfx.drawSprite(480 - 4, 60 + i * 12, SPR_SCROLLBAR_DOWN);
			} else {
				if (part == roomZ) {
					Gfx.drawSprite(480 - 4, 60 + i * 12, SPR_SCROLLBAR_1);
				} else {
					Gfx.drawSprite(480 - 4, 60 + i * 12, SPR_SCROLLBAR_0);
				}
			}
			
		}
	}
	
	function drawRoom(offsetX:Int, offsetY:Int, rx:Int, ry:Int, active:Bool) {
		offsetX += rx * 2 * Tobor.TILE_WIDTH;
		offsetY += ry * 2 * Tobor.TILE_HEIGHT;
		
		Gfx.drawSprite(offsetX + 0 * Tobor.TILE_WIDTH, offsetY + 0 * Tobor.TILE_HEIGHT, SPR_SELECTOR_ROOM_NW, active?Color.GREEN:Color.WHITE);
		Gfx.drawSprite(offsetX + 1 * Tobor.TILE_WIDTH, offsetY + 0 * Tobor.TILE_HEIGHT, SPR_SELECTOR_ROOM_NE, active?Color.GREEN:Color.WHITE);
		Gfx.drawSprite(offsetX + 0 * Tobor.TILE_WIDTH, offsetY + 1 * Tobor.TILE_HEIGHT, SPR_SELECTOR_ROOM_SW, active?Color.GREEN:Color.WHITE);
		Gfx.drawSprite(offsetX + 1 * Tobor.TILE_WIDTH, offsetY + 1 * Tobor.TILE_HEIGHT, SPR_SELECTOR_ROOM_SE, active?Color.GREEN:Color.WHITE);
		
		Tobor.fontSmall.drawString(offsetX + 4, offsetY + 7, rx + "" + ry + "" + roomZ, Color.BLACK, Color.NONE);
	}
	
	function drawEmpty(offsetX:Int, offsetY:Int, rx:Int, ry:Int) {
		offsetX += rx * 2 * Tobor.TILE_WIDTH;
		offsetY += ry * 2 * Tobor.TILE_HEIGHT;

		Gfx.drawSprite(offsetX + 0 * Tobor.TILE_WIDTH, offsetY + 0 * Tobor.TILE_HEIGHT, SPR_NONE, Color.GREEN);
		Gfx.drawSprite(offsetX + 1 * Tobor.TILE_WIDTH, offsetY + 0 * Tobor.TILE_HEIGHT, SPR_NONE, Color.GREEN);
		Gfx.drawSprite(offsetX + 0 * Tobor.TILE_WIDTH, offsetY + 1 * Tobor.TILE_HEIGHT, SPR_NONE, Color.GREEN);
		Gfx.drawSprite(offsetX + 1 * Tobor.TILE_WIDTH, offsetY + 1 * Tobor.TILE_HEIGHT, SPR_NONE, Color.GREEN);
		
		Tobor.fontSmall.drawString(offsetX + 4, offsetY + 7, rx + "" + ry + "" + roomZ, Color.DARK_GRAY, Color.NONE);
	}
}