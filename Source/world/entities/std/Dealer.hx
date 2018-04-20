package world.entities.std;

/**
 * ...
 * @author Matthias Faust
 */
class Dealer extends NPC {

	public function new() {
		super();
		
		SPR_NPC_0 = Gfx.getSprite(64, 276);
		SPR_NPC_1 = Gfx.getSprite(64 + 16, 276);
		
		SPR_NPC_LAYER_0 = Gfx.getSprite(64 + 32, 276);
		SPR_NPC_LAYER_1 = Gfx.getSprite(64 + 48, 276);
	}
	
}