package screens;

import lime.math.Rectangle;
import world.Room;
import gfx.Gfx;
import gfx.Color;
import world.entity.Entity;
import world.entity.EntityPushable;
import world.entity.Wall;

/**
 * ...
 * @author Matthias Faust
 */
class EditorScreen extends Screen {
	var cursorX:Int = 0;
	var cursorY:Int = 0;
	
	var SPR_ISOLATOR:Rectangle;
	var SPR_ELEKTROZAUN:Rectangle;
	
	public function new(game:Tobor) {
		super(game);
		
		SPR_ISOLATOR = Tobor.Tileset.find("Isolator");
		SPR_ELEKTROZAUN = Tobor.Tileset.find("Elektrozaun");
	}
	
	override
	public function update(deltaTime:Float) {
		// Spielerbewegung
		
		var mx:Int = 0;
		var my:Int = 0;
		
		if (Input.keyDown(Input.RIGHT)) mx = 1;		
		if (Input.keyDown(Input.LEFT)) mx = -1;
		if (Input.keyDown(Input.UP)) my = -1;
		if (Input.keyDown(Input.DOWN)) my = 1;
		
		game.world.player.move(mx, my);
		
		// Animationstest
		
		if (Input.keyDown(Input.ESC)) {
			game.world.player.die();
		}
		
		// Raumupdate
		
		game.world.room.update(deltaTime);
		
		// -- Editorstuff
		
		// Spielfeldkoordinaten
		
		if (Input.mouseInside) {
			cursorX = Math.floor((Input.mouseX * Gfx.scaleX) / Entity.WIDTH);
			cursorY = Math.floor((Input.mouseY * Gfx.scaleY) / Entity.HEIGHT);
		}
		
		if (cursorY > 0) {
			if (Input.mouseBtnLeft) {
				trace("MBL", cursorX, cursorY);
				
				var e = game.world.room.getEntitiesAt(cursorX, cursorY - 1);
				
				if (e.length == 0) {
					var w = new EntityPushable();
					w.gridX = cursorX;
					w.gridY = cursorY - 1;
					
					game.world.room.add(w);
				} else {
					trace("Position not free!");
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
		// Statusline
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
	
	function renderStatusLine() {
		for (x in 0 ... 8) {
			Gfx.drawRect(x * Entity.WIDTH, 0, SPR_ELEKTROZAUN);
			Gfx.drawRect((39 - x) * Entity.WIDTH, 0, SPR_ELEKTROZAUN);
		}
		
		// TODO: Blaumann! Oder Charlieobjekt fragen?
		Gfx.drawRect(8 * Entity.WIDTH + Entity.WIDTH / 2, 0, Tobor.Tileset.tile(2, 0));
		
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