package world;

import ui.Dialog;
import ui.DialogMessage;
import world.entities.std.Charlie;
import tjson.TJSON;
import world.entities.std.StartPosition;
/**
 * ...
 * @author Matthias Faust
 */
class World {
	public var editing:Bool = false;
	
	public var file:FileEpisode;
	
	public var factory:ObjectFactory;
	
	private var roomCurrent:Room;
	public var room(get, null):Room;
	
	public var rooms:Array<Room> = [];
	
	public var player:Charlie;
	
	public var oldPlayerX:Int = 0;
	public var oldPlayerY:Int = 0;
	
	// Temporär?
	var inRoomX:Int = 0;
	var inRoomY:Int = 0;
	var inRoomZ:Int = 0;
	
	public var inventory:Inventory;
	
	public var lives:Int = 3;
	public var points:Int = 0;
	public var gold:Int = 0;
	
	public var garlic:Float = 0;
	
	public var flags:Array<Bool> = [false, false, false, false, false];
	
	private var game:Tobor;
	
	public function new(game:Tobor, file:FileEpisode) {
		this.game = game;
		this.file = file;
		
		factory = new ObjectFactory();
	}
	
	public function init() {
		player = cast factory.create("OBJ_CHARLIE");
		player.setPosition(0, 0);
		oldPlayerX = 0;
		oldPlayerY = 0;
		
		inventory = new Inventory();
		
		gold = 0;
		lives = 3;
		points = 0;
		
		Text.loadForWorld(file.loadFile('translation.json'));
		
		var content:String = file.loadFile('rooms.json');
		
		if (content == null) { 
			addRoom(createRoom(0, 0, 0));
			switchRoom(0, 0, 0);
		
			var sp:StartPosition = cast factory.create("OBJ_START_POSITION");
			room.addEntity(sp);
			
			player.setRoom(roomCurrent);
		} else {
			loadData(content);
			
			switchRoom(inRoomX, inRoomY, inRoomZ);
			player.setRoom(roomCurrent);
		}
		
		flags = [false, false, false, false, false];
	}
	
	public function start() {
		// Startposition suchen...
		var sp:StartPosition = null;
		
		for (r in rooms) {
			if (sp == null) {
				sp = r.findStartPosition();
				
				if (sp != null) {
					oldPlayerX = Std.int(sp.x);
					oldPlayerY = Std.int(sp.y);
			
					player.setPosition(oldPlayerX, oldPlayerY);
				
					switchRoom(r.x, r.y, r.z);
				}
			}
		}

		if (room != null) {
			room.start();
		}
	}
	
	public function clearStartPositions() {
		for (r in rooms) {
			r.removeStateEntity(StartPosition);
		}
	}
	
	public function update(deltaTime:Float) {
		if (garlic > 0) {
			garlic = garlic - deltaTime;
			if (garlic < 0) garlic = 0;
		}
		
		if (player != null) player.update(deltaTime);
		if (roomCurrent != null) roomCurrent.update(deltaTime);
	}
	
	public function render(?editMode:Bool = false) {
		if (roomCurrent != null) roomCurrent.render(editMode);
	}
	
	function get_room():Room {
		return roomCurrent;
	}
	
	public function createRoom(x:Int, y:Int, z:Int, ?data:Dynamic = null):Room {
		var r:Room = findRoom(x, y, z);
		
		if (r == null) {
			r = new Room(this);
			r.x = x;
			r.y = y;
			r.z = z;
			
			r.getName();
		}
		
		return r;
	}
	
	public function addRoom(r:Room) {
		if (rooms.indexOf(r) == -1) {
			rooms.push(r);
		}
	}
	
	public function findRoom(x:Int, y:Int, z:Int):Room {
		for (r in rooms) {
			if (r.x == x && r.y == y && r.z == z) {
				return r;
			}
		}
		
		return null;
	}
	
	public function switchRoom(x:Int, y:Int, z:Int) {
		var r:Room = findRoom(x, y, z);
		
		if (r != null) {
			roomCurrent = r;
			player.setRoom(roomCurrent);
		}
	}
	
	public function showDialog(dialog:Dialog) {
		game.showDialog(dialog);
	}
	
	public function showMessage(key:String) {
		var messageBox:DialogMessage = new DialogMessage(game.getScreen(), 0, 0, Text.getFromWorld(key), true);
		
		showDialog(messageBox);
	}
	
	/*
	public function restoreState() {
		roomCurrent.restoreState();
		player.setPosition(oldPlayerX, oldPlayerY);
	}
	
	public function saveState() {
		roomCurrent.saveState();
		oldPlayerX = player.gridX;
		oldPlayerY = player.gridY;
	}
	*/
	
	// Save / Load
	
	public function load() {
		var content:String = file.loadFile('rooms.json');
		if (content != null) loadData(content);
	}
	
	public function save() {
		var content:String;
		
		Text.loadForWorld(file.loadFile('translation.json'));
		Text.loadForWorld(file.loadFile('translation_missing.json'));
		
		content = saveData();
		file.saveFile('rooms.json', content);
		
		content = Text.saveForWorld();
		file.saveFile('translation.json', content);
		
		content = Text.saveForWorldMissing();
		file.saveFile('translation_missing.json', content);
	}
	
	function saveData():String {
		var data:Map<String, Dynamic> = new Map<String, Dynamic>();
		
		var playerData:Map<String, Dynamic> = player.saveData();
		
		playerData.set("inRoomX", roomCurrent.x);
		playerData.set("inRoomY", roomCurrent.y);
		playerData.set("inRoomZ", roomCurrent.z);
		
		data.set("player", playerData);
		data.set("flags", flags);
		
		for (r in rooms) {
			var worldData:Map<String, Dynamic> = new Map();
			
			worldData.set("x", r.x);
			worldData.set("y", r.y);
			worldData.set("z", r.z);
			
			worldData.set("data", r.save());
			
			data.set(r.getID(), worldData);
		}
		
		return TJSON.encode(data, 'fancy');
	}
	
	function loadData(fileData:String) {
		roomCurrent = null;
		rooms = [];
		
		// player.reset();
		
		var data = TJSON.parse(fileData);
		
		for (key in Reflect.fields(data)) {
			switch(key) {
			case "player":
				parsePlayer(Reflect.field(data, "player"));
			case "flags":
				flags = Reflect.field(data, "flags");
			default:
				if (StringTools.startsWith(key, "ROOM_")) {
					parseRoom(Reflect.field(data, key));
				} else {
					// Debug.error(this, "Unknown key '" + key + "' in WorldData!");
				}
			}
		}
		
		/*
		for (roomData in data.data) {
			
		}
		*/
	}
	
	function parseRoom(data) {
		var rx:Int = -1;
		var ry:Int = -1;
		var rz:Int = -1;
		var rdata = null;
		
		for (key in Reflect.fields(data)) {
			switch(key) {
			case "x":
				rx = Reflect.field(data, "x");
			case "y":
				ry = Reflect.field(data, "y");
			case "z":
				rz = Reflect.field(data, "z");
			case "data":
				rdata = Reflect.field(data, "data");
			default:
			}
		}
		
		var newRoom:Room = new Room(this, rx, ry, rz);
		newRoom.load(rdata);
		newRoom.getName();
		
		addRoom(newRoom);
		switchRoom(rx, ry, rz);
	}
	
	function parsePlayer(data) {
		player.parseData(data);
		
		oldPlayerX = Std.int(player.x);
		oldPlayerY = Std.int(player.y);
		
		for (key in Reflect.fields(data)) {
			switch(key) {
			case "x":
				inRoomX = Reflect.field(data, "inRoomX");
			case "y":
				inRoomY = Reflect.field(data, "inRoomY");
			case "z":
				inRoomZ = Reflect.field(data, "inRoomZ");
			default:
			}
		}
	}
}