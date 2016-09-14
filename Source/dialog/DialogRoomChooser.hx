package dialog;

import gfx.Gfx;
import gfx.Color;
import lime.math.Rectangle;
import screens.ScreenEditor;
import world.Room;

/**
 * ...
 * @author Matthias Faust
 */
class DialogRoomChooser extends Dialog {
	var rooms:Array<Array<Array<Bool>>>;
	
	public var roomX:Int;
	public var roomY:Int;
	public var roomZ:Int;
	
	var editor:ScreenEditor;
	var world:world.World;
	
	var UI_NONE:Rectangle;
	
	var UI_SELECTOR_ROOM_NW:Rectangle;
	var UI_SELECTOR_ROOM_NE:Rectangle;
	var UI_SELECTOR_ROOM_SW:Rectangle;
	var UI_SELECTOR_ROOM_SE:Rectangle;
	
	var UI_SCROLLBAR_UP:Rectangle;
	var UI_SCROLLBAR_DOWN:Rectangle;
	var UI_SCROLLBAR_0:Rectangle;
	var UI_SCROLLBAR_1:Rectangle;
	
	public function new(screen:ScreenEditor, world:world.World) {
		super(screen, 0, 0);
		
		this.world = world;
		this.editor = screen;
		
		UI_NONE = Tobor.Tileset.find("SPR_NONE");
		UI_SELECTOR_ROOM_NW = Tobor.Tileset.find("UI_SELECTOR_ROOM_0");
		UI_SELECTOR_ROOM_NE = Tobor.Tileset.find("UI_SELECTOR_ROOM_1");
		UI_SELECTOR_ROOM_SW = Tobor.Tileset.find("UI_SELECTOR_ROOM_2");
		UI_SELECTOR_ROOM_SE = Tobor.Tileset.find("UI_SELECTOR_ROOM_3");
		
		UI_SCROLLBAR_UP = Tobor.Tileset.find("SPR_PFEIL_N");
		UI_SCROLLBAR_DOWN = Tobor.Tileset.find("SPR_PFEIL_S");
		UI_SCROLLBAR_0 = Tobor.Tileset.find("SPR_ISOLATOR");
		UI_SCROLLBAR_1 = Tobor.Tileset.find("SPR_ELEKTROZAUN");
		
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
		show();
	}
	
	override public function show() {
		roomX = world.room.worldX;
		roomY = world.room.worldY;
		roomZ = world.room.worldZ;
		
		for (r in world.rooms) {
			rooms[r.worldZ][r.worldX][r.worldY] = true;
		}
	}
	
	override
	public function update(deltaTime:Float) {
		if (Input.keyDown(Input.ESC) || Input.keyDown(Input.ENTER)) {
			exit();
			Input.wait(2);
		}
		
		if (Input.keyDown(Input.RIGHT)) {
			roomX++;
			Input.wait(0.2);
		} else if (Input.keyDown(Input.LEFT)) {
			roomX--;
			Input.wait(0.2);
		} else if (Input.keyDown(Input.UP)) {
			roomY--;
			Input.wait(0.2);
		} else if (Input.keyDown(Input.DOWN)) {
			roomY++;
			Input.wait(0.2);
		}
		
		if (Input.keyDown(Input.PAGE_UP)) {
			roomZ--;
			Input.wait(0.2);
		} else if (Input.keyDown(Input.PAGE_DOWN)) {
			roomZ++;
			Input.wait(0.2);
		}
		
		if (roomX < 0) roomX = 0;
		if (roomX > 9) roomX = 9;
		if (roomY < 0) roomY = 0;
		if (roomY > 9) roomY = 9;
		if (roomZ < 0) roomZ = 0;
		if (roomZ > 9) roomZ = 9;
	}
	
	override
	public function render() {
		// Statusline
		for (_x in 0 ... 8) {
			Gfx.drawRect(_x * Tobor.OBJECT_WIDTH, 0, UI_NONE, Color.LIGHT_GREEN);
			Gfx.drawRect((39 - _x) * Tobor.OBJECT_WIDTH, 0, UI_NONE, Color.LIGHT_GREEN);
		}
		
		var room:Room = world.findRoom(roomX, roomY, roomZ);
		if (room == null) {
			Tobor.Font8.drawString(9 * Tobor.OBJECT_WIDTH, 0, "Kein Raum vorhanden", Color.BLACK);
		} else {
			Tobor.Font8.drawString(9 * Tobor.OBJECT_WIDTH, 0, "Unbenannter Raum (" + roomZ + "" + roomX + "" + roomY + ")", Color.BLACK);
		}
		
		// Raumauswahl
		Tobor.Frame16.drawBox(160 - Tobor.Frame16.sizeX - 8, 60 - Tobor.Frame16.sizeY, 23, 22);
		
		for (xx in 0 ... 10) {
			for (yy in 0 ... 10) {
				if (xx == roomX && yy == roomY) {
					if (rooms[0][xx][yy]) drawRoom(160 - 8, 60, xx, yy, true);
					else drawEmpty(160 - 8, 60, xx, yy);
				} else {
					if (rooms[0][xx][yy]) drawRoom(160 - 8, 60, xx, yy, false);
				}
			}
		}
		
		// Ebenenleiste
		for (i in 0 ... 20) {
			var part = Math.floor(i / 2);
			
			if (i == 0) {
				Gfx.drawRect(480 - 4, 60 + i * 12, UI_SCROLLBAR_UP);
			} else if (i == 19) {
				Gfx.drawRect(480 - 4, 60 + i * 12, UI_SCROLLBAR_DOWN);
			} else {
				if (part == roomZ) {
					Gfx.drawRect(480 - 4, 60 + i * 12, UI_SCROLLBAR_1);
				} else {
					Gfx.drawRect(480 - 4, 60 + i * 12, UI_SCROLLBAR_0);
				}
			}
			
		}
	}
	
	function drawRoom(offsetX:Int, offsetY:Int, rx:Int, ry:Int, active:Bool) {
		offsetX += rx * 2 * Tobor.OBJECT_WIDTH;
		offsetY += ry * 2 * Tobor.OBJECT_HEIGHT;
		
		Gfx.drawRect(offsetX + 0 * Tobor.OBJECT_WIDTH, offsetY + 0 * Tobor.OBJECT_HEIGHT, UI_SELECTOR_ROOM_NW, active?Color.GREEN:Color.WHITE);
		Gfx.drawRect(offsetX + 1 * Tobor.OBJECT_WIDTH, offsetY + 0 * Tobor.OBJECT_HEIGHT, UI_SELECTOR_ROOM_NE, active?Color.GREEN:Color.WHITE);
		Gfx.drawRect(offsetX + 0 * Tobor.OBJECT_WIDTH, offsetY + 1 * Tobor.OBJECT_HEIGHT, UI_SELECTOR_ROOM_SW, active?Color.GREEN:Color.WHITE);
		Gfx.drawRect(offsetX + 1 * Tobor.OBJECT_WIDTH, offsetY + 1 * Tobor.OBJECT_HEIGHT, UI_SELECTOR_ROOM_SE, active?Color.GREEN:Color.WHITE);
		
		Tobor.Font8.drawString(offsetX + 4, offsetY + 7, roomZ + "" + rx + "" + ry, Color.BLACK, Color.NONE);
	}
	
	function drawEmpty(offsetX:Int, offsetY:Int, rx:Int, ry:Int) {
		offsetX += rx * 2 * Tobor.OBJECT_WIDTH;
		offsetY += ry * 2 * Tobor.OBJECT_HEIGHT;
		
		Gfx.drawRect(offsetX + 0 * Tobor.OBJECT_WIDTH, offsetY + 0 * Tobor.OBJECT_HEIGHT, UI_NONE, Color.GREEN);
		Gfx.drawRect(offsetX + 1 * Tobor.OBJECT_WIDTH, offsetY + 0 * Tobor.OBJECT_HEIGHT, UI_NONE, Color.GREEN);
		Gfx.drawRect(offsetX + 0 * Tobor.OBJECT_WIDTH, offsetY + 1 * Tobor.OBJECT_HEIGHT, UI_NONE, Color.GREEN);
		Gfx.drawRect(offsetX + 1 * Tobor.OBJECT_WIDTH, offsetY + 1 * Tobor.OBJECT_HEIGHT, UI_NONE, Color.GREEN);
	}
}