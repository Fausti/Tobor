package screens;

import gfx.Gfx;
import gfx.Color;
import world.Room;
import world.entities.Entity;

/**
 * ...
 * @author Matthias Faust
 */
class ScreenPlay extends Screen {

	public function new(game:Tobor) {
		super(game);
	}
	
	override
	public function update(deltaTime:Float) {
		var mx:Int = 0;
		var my:Int = 0;
		
		if (Input.keyDown(Input.RIGHT)) mx = 1;		
		if (Input.keyDown(Input.LEFT)) mx = -1;
		if (Input.keyDown(Input.UP)) my = -1;
		if (Input.keyDown(Input.DOWN)) my = 1;
		
		game.world.player.move(mx, my);
		
		if (Input.keyDown(Input.ESC)) {
			Input.wait(2);
				
			game.switchScreen(new ScreenMainMenu(game));
		}
		
		game.world.room.update(deltaTime);
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
		renderStatusLine();
	}
	
	function renderStatusLine() {
		for (x in 0 ... 8) {
			Gfx.drawRect(x * Entity.WIDTH, 0, Tobor.Tileset.tile(15, 0));
			Gfx.drawRect((39 - x) * Entity.WIDTH, 0, Tobor.Tileset.tile(15, 0));
		}
		
		// TODO: Blaumann! Oder Charlieobjekt fragen?
		Gfx.drawRect(8 * Entity.WIDTH + Entity.WIDTH / 2, 0, Tobor.Tileset.tile(2, 0));
		
		var punkte = game.world.player.points;
		var leben = game.world.player.lives;
		
		var strStatus:String = "Punkte " + StringTools.lpad(Std.string(punkte), "0", 8) + " Leben " + Std.string(leben);
		Tobor.Font8.drawString(224, 0, strStatus, Color.BLACK);
		
		var gold = game.world.player.gold;
		if (gold > 0) {
			Gfx.drawRect(416, 0, Tobor.Tileset.tile(6, 1));
			Tobor.Font8.drawString(416 + 24, 0, StringTools.lpad(Std.string(gold), " ", 3), Color.BLACK);
		}
		
		var weight = 32;
		var strWeight:String = StringTools.lpad(Std.string(weight), " ", 2);
		Gfx.drawRect(471, 0, Tobor.Tileset.tile(7, 1));
		Tobor.Font8.drawString(488, 0, strWeight, Color.BLACK);
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