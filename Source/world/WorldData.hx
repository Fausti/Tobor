package world;
import gfx.Tilesheet;

/**
 * ...
 * @author Matthias Faust
 */
class WorldData {

	public static function initTilesheet(tileset:Tilesheet) {
		tileset.register("Charlie", [
			// stehend
			[1, 0], 
			
			// in Bewegung
			[2, 0], 
			[3, 0]
		]);
		
		tileset.register("Explosion", [
			[5, 0], 
			[6, 0], 
			[7, 0], 
			[8, 0], 
			[9, 0]
		]);
		
		tileset.register("Mauer", [
			// ätzbar
			[10, 0],
			
			// fest
			[10, 1],
			
			// Ecken (normal)
			[11, 0],
			[12, 0],
			[13, 0],
			[14, 0],
			[15, 0],
			
			// dunkel
			[3, 11],
			
			// Ecken (dunkel)
			[4, 11],
			[5, 11],
			[6, 11],
			[7, 11],
		]);
		
		tileset.register("MauerEffekt", [
			[0, 5],
			[1, 5],
			[2, 5],
			[3, 5],
			[4, 5],
		]);
	}
	
}