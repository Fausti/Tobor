package world.entities.std;

import lime.math.Vector2;
import world.InventoryItem;
import world.entities.EntityItem;

/**
 * ...
 * @author Matthias Faust
 */
class Seed extends EntityItem {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(240, 216));
	}
	
	override public function onUse(item:InventoryItem, x:Float, y:Float) {
		var player = getPlayer();
		
		var atPlayer = room.getAllEntitiesAt(player.x, player.y, player);
		if (atPlayer.length > 0) {
			return;
		}
		
		var e:Plant = new Plant();
		room.spawnEntity(getPlayer().x, getPlayer().y, e);
		
		var places:Array<Vector2> = [];
		if (player.x > 0 && room.getAllEntitiesAt(player.x - 1, player.y).length == 0) places.push(Direction.W);
		if (player.x < (Room.WIDTH - 1) && room.getAllEntitiesAt(player.x + 1, player.y).length == 0) places.push(Direction.E);
		if (player.y > 0 && room.getAllEntitiesAt(player.x, player.y - 1).length == 0) places.push(Direction.N);
		if (player.y < (Room.HEIGHT - 1) && room.getAllEntitiesAt(player.x, player.y + 1).length == 0) places.push(Direction.S);

		if (places.length == 1) {
			spawnPlant(places[0]);
		} else if (places.length > 1) {
			var index:Int = Std.random(places.length);
			spawnPlant(places[index]);
			places.remove(places[index]);
			
			index = Std.random(places.length);
			spawnPlant(places[index]);
		}
		
		if (getWorld().checkFirstUse("USED_SEED")) {
				removeFromInventory();
			} else {
				getWorld().markFirstUse("USED_SEED");
				getWorld().showPickupMessage("OBJ_SEED_USE", false, function () {
					getWorld().addPoints(1500);
					removeFromInventory();
					getWorld().hideDialog();
			}, 1500);
		}
	}
	
	function spawnPlant(d:Vector2) {
		var e:PlantGrowing = new PlantGrowing();
		
		if (d == Direction.W) {
			e.type = 0;
		} else if (d == Direction.N) {
			e.type = 3;
		} else if (d == Direction.E) {
			e.type = 6;
		} else if (d == Direction.S) {
			e.type = 9;
		} else {
			return;
		}
		
		room.spawnEntity(getPlayer().x + d.x, getPlayer().y + d.y, e);
	}
}