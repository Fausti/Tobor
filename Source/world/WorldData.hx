package world;

import world.entities.Entity;
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
		
		tileset.register("SPR_CHARLIE", [
			// stehend
			[1, 0], 
			
			// in Bewegung
			[2, 0], 
			[3, 0]
		]);
		
		tileset.register("SPR_EXPLOSION", [
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
		
/*
			// dunkel
			[3, 11],
			
			// Ecken (dunkel)
			[4, 11],
			[5, 11],
			[6, 11],
			[7, 11],
*/
		
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
	}
	
	/*
	public static var tableEntities:Array<EntityTemplate> = [];
		{
			key:"OBJ_CHARLIE",
			subType:0,
			editorSprite:"SPR_CHARLIE",
			classPath:CORE + "Charlie",
		},
		{
			key:"OBJ_MAUER",
			subType:0,
			editorSprite:"SPR_MAUER",
			classPath:CORE + "Mauer",
		},
		{
			key:"OBJ_MAUER",
			editorSprite:"SPR_MAUER_1",
			classPath:CORE + "Mauer",
			subType:1,
		},
		{	key:"OBJ_MAUER",
			editorSprite:"SPR_MAUER_2",
			classPath:CORE + "Mauer",
			subType:2,
		},
		{
			key:"OBJ_MAUER",
			editorSprite:"SPR_MAUER_3",
			classPath:CORE + "Mauer",
			subType:3,
		},
		{
			key:"OBJ_MAUER",
			editorSprite:"SPR_MAUER_4",
			classPath:CORE + "Mauer",
			subType:4,
		},
		{
			key:"OBJ_MAUER",
			editorSprite:"SPR_MAUER_5",
			classPath:CORE + "Mauer",
			subType:5,
		},
		
		{
			key:"OBJ_ISOLATOR",
			subType:0,
			editorSprite:"SPR_ISOLATOR",
			classPath:CORE + "Isolator",
		},
		{
			key:"OBJ_ELEKTROZAUN",
			subType:0,
			editorSprite:"SPR_ELEKTROZAUN",
			classPath:CORE + "Elektrozaun",
		},
		
		{
			key:"OBJ_MAUER_AUFLOESEN",
			subType:0,
			editorSprite:"SPR_MAUER_AUFLOESEN_1",
			classPath:CORE + "MauerZersetzen",
		},
		{
			key:"OBJ_GOLD",
			subType:0,
			editorSprite:"SPR_GOLD",
			classPath:CORE + "Gold",
		},
	];
	*/
}