package world.entities.std;

import world.entities.EntityRoof;

/**
 * ...
 * @author Matthias Faust
 */
class Roof extends EntityRoof {

	public function new() {
		super();
	}
	
	override public function init() {
		var spr:Sprite = null;
		
		switch (type) {
			// Blau
			
			case 0: // Rand Norden
				spr = Gfx.getSprite(0, 132);
			case 1: // Rand Süden
				spr = Gfx.getSprite(0, 144);
				
			case 2: // Spitze Süden
				spr = Gfx.getSprite(16, 132);
			case 3: // Spitze Norden
				spr = Gfx.getSprite(16, 144);
				
			case 4: // Tür Norden
				spr = Gfx.getSprite(32, 132);
			case 5: // Tür Süden
				spr = Gfx.getSprite(32, 144);
				
			case 6: // Mitte Norden
				spr = Gfx.getSprite(48, 144);
			case 7: // Mitten Süden
				spr = Gfx.getSprite(64, 144);
				
			case 8: // Schornstein
				spr = Gfx.getSprite(80, 144);
				
				// Rot
				
			case 9: // Rand Norden
				spr = Gfx.getSprite(208, 324);
			case 10: // Rand Süden
				spr = Gfx.getSprite(208 + 16, 324);
			case 11: // Spitze Süden
				spr = Gfx.getSprite(208 + 32, 324);
				
			case 12: // Spitze Norden
				spr = Gfx.getSprite(208, 324 + 12);
			case 13: // Tür Norden
				spr = Gfx.getSprite(208 + 16, 324 + 12);
			case 14: // Tür Süden
				spr = Gfx.getSprite(208 + 32, 324 + 12);
				
			case 15: // Mitte Norden
				spr = Gfx.getSprite(208, 324 + 24);
			case 16: // Mitten Süden
				spr = Gfx.getSprite(208 + 16, 324 + 24);
			case 17: // Schornstein
				spr = Gfx.getSprite(208 + 32, 324 + 24);
		}
		
		if (spr != null) {
			setSprite(spr);
		}
		
		this.z = Room.LAYER_ROOF;
	}
}