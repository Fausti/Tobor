package;

import core.LimeGame;
import core.LimeApplication;

class Main extends LimeApplication {
	
	public function new() {
		super();
	}
	
	override public function init() {
		this.game = new Tobor();
	}

}