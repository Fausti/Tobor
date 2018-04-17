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
		}
		
		if (spr != null) {
			setSprite(spr);
		}
		
		this.z = Room.LAYER_ROOF;
	}
}