package world;

import world.entities.Object;
import gfx.Tilesheet;
import tjson.TJSON;
import world.entity.*;

/**
 * ...
 * @author Matthias Faust
 */
class WorldData {

	public static function initTilesheet(tileset:Tilesheet) {
		tileset.register("SPR_NONE", [
			[0, 0], 
		]);
		
		tileset.register("UI_SELECTOR", [
			[10, 20], 
		]);
		
		tileset.register("UI_PLAY", [
			[11, 20], 
		]);
		
		tileset.register("UI_PAUSE", [
			[12, 20], 
		]);
		
		tileset.register("UI_SELECTOR_ROOM", [
			[8, 18], 
			[9, 18], 
			[8, 19], 
			[9, 19], 
		]);
		
		tileset.register("SPR_CHARLIE", [
			// stehend
			[1, 0], 
			
			// in Bewegung
			[2, 0], 
			[3, 0]
		]);
		
		tileset.register("SPR_EXPLOSION", [
			[4, 0], 
			[5, 0], 
			[6, 0], 
			[7, 0], 
			[8, 0], 
			[9, 0]
		]);
		
		tileset.register("SPR_ISOLATOR", [
			[15, 0], 
		]);
		
		tileset.register("SPR_ELEKTROZAUN", [
			[4, 1], 
		]);
		
		// ätzbar
		tileset.register("SPR_MAUER", [
			[10, 0], 
		]);
		
		// stabil
		tileset.register("SPR_MAUER_STABIL", [
			[10, 1], 
		]);
		
		// Ecken
		tileset.register("SPR_MAUER_SW", [
			[11, 0], 
		]);
		
		tileset.register("SPR_MAUER_NE", [
			[12, 0], 
		]);
		
		tileset.register("SPR_MAUER_NW", [
			[13, 0], 
		]);
		
		tileset.register("SPR_MAUER_SE", [
			[14, 0], 
		]);
		
		tileset.register("SPR_MAUER_BLACK", [
			[3, 11], 
		]);
		
		tileset.register("SPR_MAUER_BLACK_SW", [
			[4, 11], 
		]);
		
		tileset.register("SPR_MAUER_BLACK_NE", [
			[5, 11], 
		]);
		
		tileset.register("SPR_MAUER_BLACK_NW", [
			[6, 11], 
		]);
		
		tileset.register("SPR_MAUER_BLACK_SE", [
			[7, 11], 
		]);
		
		// Pfeile
		
		tileset.register("SPR_PFEIL_E", [
			[6, 2], 
		]);
		
		tileset.register("SPR_PFEIL_N", [
			[7, 2], 
		]);
		
		tileset.register("SPR_PFEIL_W", [
			[8, 2], 
		]);
		
		tileset.register("SPR_PFEIL_S", [
			[9, 2], 
		]);
		
		tileset.register("SPR_AUSGANG", [
			[0, 1], 
		]);
		
		tileset.register("SPR_AUSGANG_WE", [
			[1, 1], 
		]);
		
		tileset.register("SPR_AUSGANG_NS", [
			[2, 1], 
		]);
		
		tileset.register("SPR_MAUER_AUFLOESEN", [
			[0, 5],
			[1, 5],
			[2, 5],
			[3, 5],
			[4, 5],
		]);
		
		tileset.register("SPR_GOLD", [
			[6, 1], 
		]);
		
		tileset.register("SPR_LEBEN", [
			[14, 2], 
		]);
		
		tileset.register("SPR_SAEURE_FLASCHE", [
			[13, 2], 
		]);
		
		tileset.register("SPR_UHR", [
			[11, 1], 
		]);
		
		tileset.register("SPR_TOTENKOPF", [
			[5, 1], 
		]);
		
		tileset.register("SPR_BANK", [
			[3, 1], 
		]);
		
		tileset.register("SPR_KNOBLAUCH", [
			[12, 2], 
		]);
		
		tileset.register("SPR_DIAMANT", [
			[11, 2],
			[10, 2]
		]);
		
		tileset.register("SPR_MAGNET", [
			[14, 1],
			[15, 1]
		]);
		
		tileset.register("SPR_BLOCKADE_ROBOTER_AKTIV", [
			[15, 8],
		]);
		
		tileset.register("SPR_BLOCKADE_ROBOTER_INAKTIV", [
			[14, 8],
		]);
		
		tileset.register("SPR_TUER", [
			[0, 3],
			[1, 3],
			[2, 3],
			[3, 3],
			[4, 3],
			[5, 3],
			[6, 3],
			[7, 3],
			[8, 3],
			[9, 3],
			[10, 3],
			[11, 3],
			[12, 3],
			[13, 3],
			[14, 3],
		]);
		
		tileset.register("SPR_TUER_MASK", [
			[2, 15],
			[3, 15],
			[4, 15],
		]);
		
		tileset.register("SPR_SCHLUESSEL", [
			[0, 4],
			[1, 4],
			[2, 4],
			[3, 4],
			[4, 4],
			[5, 4],
			[6, 4],
			[7, 4],
			[8, 4],
			[9, 4],
			[10, 4],
			[11, 4],
			[12, 4],
			[13, 4],
			[14, 4],
		]);
		
		tileset.register("SPR_SCHLUESSEL_MASK", [
			[15, 16],
			[15, 17]
		]);
		
		tileset.register("SPR_TUER_MONO", [
			[0, 16],
			[1, 16],
			[2, 16],
			[3, 16],
			[4, 16],
			[5, 16],
			[6, 16],
			[7, 16],
			[8, 16],
			[9, 16],
			[10, 16],
			[11, 16],
			[12, 16],
			[13, 16],
			[14, 16],
		]);
		
		tileset.register("SPR_SCHLUESSEL_MONO", [
			[0, 17],
			[1, 17],
			[2, 17],
			[3, 17],
			[4, 17],
			[5, 17],
			[6, 17],
			[7, 17],
			[8, 17],
			[9, 17],
			[10, 17],
			[11, 17],
			[12, 17],
			[13, 17],
			[14, 17],
		]);
		
		tileset.register("SPR_PLATIN", [
			[8, 1], 
		]);
		
		tileset.register("SPR_AUSRUFEZEICHEN", [
			[12, 1], 
		]);
		
		tileset.register("SPR_NEST", [
			[5, 5], 
			[6, 5],
			[7, 5]
		]);
		
		tileset.register("SPR_ROBOT_EDITOR", [
			[0, 10], 
		]);
		
		// Roboter 0
		
		tileset.register("SPR_ROBOT_0_PART_0", [
			[0, 7], 
			[1, 7], 
		]);
		
		tileset.register("SPR_ROBOT_0_PART_1", [
			[0, 8], 
			[1, 8], 
		]);
		
		tileset.register("SPR_ROBOT_0_PART_2", [
			[0, 9], 
			[1, 9], 
		]);
		
		// Roboter 1
		
		tileset.register("SPR_ROBOT_1_PART_0", [
			[2, 7], 
			[3, 7], 
		]);
		
		tileset.register("SPR_ROBOT_1_PART_1", [
			[2, 8], 
			[3, 8], 
		]);
		
		tileset.register("SPR_ROBOT_1_PART_2", [
			[2, 9], 
			[3, 9], 
		]);
		
		// Roboter 2
		
		tileset.register("SPR_ROBOT_2_PART_0", [
			[4, 7], 
			[5, 7], 
		]);
		
		tileset.register("SPR_ROBOT_2_PART_1", [
			[4, 8], 
			[5, 8], 
		]);
		
		tileset.register("SPR_ROBOT_2_PART_2", [
			[4, 9], 
			[5, 9], 
		]);
		
		// Roboter 3
		
		tileset.register("SPR_ROBOT_3_PART_0", [
			[6, 7], 
			[7, 7], 
		]);
		
		tileset.register("SPR_ROBOT_3_PART_1", [
			[6, 8], 
			[7, 8], 
		]);
		
		tileset.register("SPR_ROBOT_3_PART_2", [
			[6, 9], 
			[7, 9], 
		]);
		
		// Roboter 4
		
		tileset.register("SPR_ROBOT_4_PART_0", [
			[8, 7], 
			[9, 7], 
		]);
		
		tileset.register("SPR_ROBOT_4_PART_1", [
			[8, 8], 
			[9, 8], 
		]);
		
		tileset.register("SPR_ROBOT_4_PART_2", [
			[8, 9], 
			[9, 9], 
		]);
		
		// Roboter 5
		
		tileset.register("SPR_ROBOT_5_PART_0", [
			[10, 7], 
			[11, 7], 
		]);
		
		tileset.register("SPR_ROBOT_5_PART_1", [
			[10, 8], 
			[11, 8], 
		]);
		
		tileset.register("SPR_ROBOT_5_PART_2", [
			[10, 9], 
			[11, 9], 
		]);
	}
}