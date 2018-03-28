package world.entities.std;
import lime.math.Vector2;
import world.entities.Entity;
import world.entities.interfaces.IContainer;
import world.entities.interfaces.IElectric;

/**
 * ...
 * @author Matthias Faust
 */
class Notice extends EntityCollectable implements IElectric {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(208, 12));
	}
	
	function getTextID():String {
		return "TXT_NOTICE_" + room.getID() + "_NR_" + flag;
	}
	
	override public function onPickup() {
		if (getWorld().editing) return;
		
		if (flag != Marker.MARKER_NO) getWorld().showMessage(getTextID());
	}
	
	override public function onSetMarker(f:Int) {
		if (f != Marker.MARKER_NO) {
			Text.getFromWorld(getTextID());
		}
	}
}